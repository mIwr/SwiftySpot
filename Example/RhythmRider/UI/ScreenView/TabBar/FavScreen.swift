//
//  FavScreen.swift
//  RhythmRider
//
//  Created by developer on 30.10.2023.
//

import SwiftUI
import SwiftySpot

struct FavScreen: View {
    
    @EnvironmentObject var api: ApiController
    @EnvironmentObject var playController: PlaybackController
    
    @State fileprivate var _loaded: Bool?
    @State fileprivate var _loadingNextPage: Bool
    @State fileprivate var _errMsg: String
    @StateObject fileprivate var _favTracks: FavStorageVModel
    
    init() {
        __loaded = State(initialValue: nil)
        __loadingNextPage = State(initialValue: false)
        __errMsg = State(initialValue: "")
        __favTracks = StateObject(wrappedValue: FavStorageVModel())
    }
    
    var body: some View {
        VStack(alignment: .leading, content: {
            if (_loaded == nil) {
                LoadingView()
            } else if (_loaded == false) {
                ErrorView(title: R.string.localizable.favLikedTracksLoadError(), subtitle: _errMsg) {
                    _loaded = nil
                    _errMsg = ""
                    Task {
                        await loadInitData()
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            } else {
                ScrollViewReader { proxy in
                    OffsetObservingScrollView(.vertical, showsIndicators: true, onScroll: scrollHandler) {
                        LazyVStack(alignment: .leading, spacing: 12) {
                            ForEach(0..._favTracks.orderedPlayUris.count - 1, id: \.self) { index in
                                let uri = _favTracks.orderedPlayUris[index]
                                let onPress: () -> Void = {
#if DEBUG
                                    print("Track TAP")
                                    if (ProcessInfo.processInfo.previewMode) {
                                        //Disable real play track in preview
                                        return
                                    }
#endif
                                    if (playController.playingTrackUri == uri) {
                                        return
                                    }
                                    let vmodelHash = _favTracks.playSeqHash
                                    let playbackHash = playController.playSeqHash
                                    if (vmodelHash == playbackHash && !playController.shuffle) {
                                        _ = playController.setPlayingTrackByIndex(index, play: true)
                                        return
                                    }
                                    _ = playController.setPlaybackSeq(_favTracks.playSeq, playIndex: index, playNow: true)
                                }
                                if let safeTrack = _favTracks.details[uri] {
                                    let artists: [(uri: String, name: String)] = safeTrack.artists.map({ artist in
                                        return (uri: artist.uri, name: artist.name)
                                    })
                                    TrackView(trackUri: uri, title: safeTrack.name, img: nil, artists: artists, onPress: onPress, playUri: playController.playingTrackUri)
                                        .id(uri)
                                } else {
                                    TrackView(trackUri: uri, title: "N/A", img: nil, artists: [], onPress: onPress, playUri: playController.playingTrackUri)
                                        .id(uri)
                                        .onAppear {
                                            scrollHandler(offset: CGPoint(x: 0, y: 200), maxScrollExtent: CGPoint(x: 0, y: 100))
                                        }
                                }
                            }
                        }
                        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                    }
                }
            }
        })
        .navigationTitle(R.string.localizable.favTitle())
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .topBarTrailing) {
                NavigationLink(destination: {
                    return ProfileScreen()
                }, label: {
                    Image(R.image.icUser)
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                })
                .frame(width: 24, height: 24)
            }
        }
        .onAppear(perform: {
            if (_loaded != nil) {
                return
            }
#if DEBUG
            if (ProcessInfo.processInfo.previewMode) {
                //Disable real API requests
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    _favTracks.updateMeta([
                        "sp:t:123": SPMetadataTrack(gid: [], name: "Some track name"),
                        "sp:t:1234": SPMetadataTrack(gid: [], name: "Some track name 2"),
                        "sp:t:12345": SPMetadataTrack(gid: [], name: "Some track name 3"),
                        "sp:t:123456": SPMetadataTrack(gid: [], name: "Some track name 4"),
                        "sp:t:1234567": SPMetadataTrack(gid: [], name: "Some track name 5"),
                        "sp:t:12345678": SPMetadataTrack(gid: [], name: "Some track name 6"),
                        "sp:t:123456789": SPMetadataTrack(gid: [], name: "Some track name 7"),
                        "sp:t:1234567890": SPMetadataTrack(gid: [], name: "Some track name 8"),
                        "sp:t:12345678901": SPMetadataTrack(gid: [], name: "Some track name 9"),
                        "sp:t:123456789012": SPMetadataTrack(gid: [], name: "Some track name 10"),
                    ])
                    _favTracks.setLikesData(orderedLikedUris: [String].init(_favTracks.details.keys))
                    _loaded = true
                }
                return
            }
#endif
            _favTracks.setLikesData(orderedLikedUris: api.client.likedTracksStorage.orderedItems.map({ item in
                return item.uri
            }))
            Task {
                await loadInitData()
            }
        })
        .onReceive(NotificationCenter.default.publisher(for: .SPTrackLikeUpdate)) { notification in
            let parseRes = notification.tryParseTrackLikeUpdate()
            let success = parseRes.0
            if (!success) {
                return
            }
            guard let collectionItem = parseRes.1 else {return}
            if let safeLocalMeta = api.client.tracksMetaStorage.find(uri: collectionItem.uri) {
                _favTracks.applyOnTrackLikeUpdate(collectionItem: collectionItem, meta: safeLocalMeta)
                return
            }
            loadPageMetaChunk(trackUris: [collectionItem.uri])
            _favTracks.applyOnTrackLikeUpdate(collectionItem: collectionItem, meta: nil)
        }
        .onReceive(NotificationCenter.default.publisher(for: .SPPlayItemUpdate)) { notification in
            if (_favTracks.playSeqHash != playController.playSeqHash) {
                return
            }
            let parseRes = notification.tryParsePlayItemUpdate()
            let success = parseRes.0
            if (!success) {
                return
            }
            guard let track = parseRes.1 else {return}
            if (track.uri != _favTracks.orderedPlayUris.last) {
                return
            }
            scrollHandler(offset: CGPoint(x: 0, y: 100), maxScrollExtent: CGPoint(x: 0, y: 50))
        }
    }
    
    fileprivate func scrollHandler(offset: CGPoint, maxScrollExtent: CGPoint) {
        if (_loadingNextPage || maxScrollExtent.y == 0) {
            return
        }
        let delta = maxScrollExtent.y - offset.y
        if (delta >= 500) {
            return
        }
        let noInfoTracks = _favTracks.orderedNoDetailsUris
        if (noInfoTracks.isEmpty) {
            guard let safeNextPageToken = api.client.likedTracksStorage.nextPageToken, !safeNextPageToken.isEmpty else {return}
            _loadingNextPage = true
            loadPageFavCollectionChunk(pageLimit: api.client.likedTracksStorage.pageSize, pageToken: safeNextPageToken)
            return
        }
        _loadingNextPage = true
#if DEBUG
            if (ProcessInfo.processInfo.previewMode) {
                //Disable real API requests
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    _loadingNextPage = false
                }
                return
            }
#endif
        //Download meta partially
        var metaChunkTask: [String] = []
        if (noInfoTracks.count <= SPCollectionController.defaultPageSize) {
            metaChunkTask = noInfoTracks
        } else {
            metaChunkTask.append(contentsOf: noInfoTracks.prefix(Int(SPCollectionController.defaultPageSize)))
        }
        loadPageMetaChunk(trackUris: metaChunkTask)
    }
    
    fileprivate func loadInitData() async {
        if (_favTracks.orderedPlayUris.isEmpty) {
            let success = await withCheckedContinuation { continuation in
                api.client.getLikedTracks(pageLimit: SPCollectionController.defaultPageSize, pageToken: nil) { result in
                    switch(result) {
                    case .success(let collection):
                        self._favTracks.setLikesData(orderedLikedUris: collection.items.sorted { a, b in
                            return a.addedTs > b.addedTs
                        }.map({ collectionItem in
                            return collectionItem.uri
                        }))
                        continuation.resume(returning: true)
                        return
                    case .failure(let error):
                        _errMsg = error.errorDescription
                        continuation.resume(returning: false)
                    }
                }
            }
            if (!success) {
                _loaded = false
                return
            }
        }
        _favTracks.updateMeta(api.client.tracksMetaStorage.findAsDict(uris: _favTracks.noDetailsUris))
        let noInfoTracks = _favTracks.orderedNoDetailsUris
        let resolved = !_favTracks.orderedPlayUris.isEmpty && noInfoTracks.count == 0
        if (resolved) {
            _loaded = true
            return
        }
        //Download meta partially
        var metaChunkTask: [String] = []
        if (noInfoTracks.count <= SPCollectionController.defaultPageSize) {
            metaChunkTask = noInfoTracks
        } else {
            metaChunkTask.append(contentsOf: noInfoTracks.prefix(Int(SPCollectionController.defaultPageSize)))
        }
        let metaLoadSuccess = await withCheckedContinuation { continuation in
            api.client.getTracksDetails(trackUris: metaChunkTask) { metaRes in
                switch(metaRes) {
                case .success(let meta):
                    self._favTracks.updateMeta(meta)
                    continuation.resume(returning: true)
                    return
                case .failure(let error):
                    _errMsg = error.errorDescription
                    continuation.resume(returning: false)
                    return
                }
            }
        }
        _loaded = metaLoadSuccess
    }
    
    fileprivate func loadPageFavCollectionChunk(pageLimit: UInt, pageToken: String) {
        if (pageToken.isEmpty) {
            _loadingNextPage = false
            return
        }
        api.client.getLikedTracks(pageLimit: pageLimit, pageToken: pageToken) { result in
            switch (result) {
            case .success:
                let uris = api.client.likedTracksStorage.orderedItems.map({ item in
                    return item.uri
                })
                self._favTracks.updateMeta(api.client.tracksMetaStorage.findAsDict(uris: Set<String>(uris)))
                self._favTracks.setLikesData(orderedLikedUris: uris)
                let noInfoTracks = self._favTracks.orderedNoDetailsUris
                if (noInfoTracks.isEmpty) {
                    _loadingNextPage = false
                    return
                }
                var metaChunkTask: [String] = []
                if (noInfoTracks.count <= SPCollectionController.defaultPageSize) {
                    metaChunkTask = noInfoTracks
                } else {
                    metaChunkTask.append(contentsOf: noInfoTracks.prefix(Int(SPCollectionController.defaultPageSize)))
                }
                self.loadPageMetaChunk(trackUris: metaChunkTask)
                return
            case .failure:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    _loadingNextPage = false
                }
                return
            }
        }
    }
    
    fileprivate func loadPageMetaChunk(trackUris: [String]) {
        if (trackUris.isEmpty) {
            _loadingNextPage = false
            return
        }
        api.client.getTracksDetails(trackUris: trackUris) { metaRes in
            switch(metaRes) {
            case .success(let meta):
                self._favTracks.updateMeta(meta)
                _loadingNextPage = false
                return
            case .failure:
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    _loadingNextPage = false
                }
                return
            }
        }
    }
}

#Preview {
    @StateObject var api: ApiController = ApiController(previewApiClient)
    return NavigationView(content: {
        FavScreen()
    })
    .environmentObject(previewProperties)
    .environmentObject(api)
    .environmentObject(previewPlayController)
}
