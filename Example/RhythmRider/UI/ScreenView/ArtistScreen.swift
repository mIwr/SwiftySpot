//
//  ArtistScreen.swift
//  RhythmRider
//
//  Created by developer on 18.12.2023.
//

import SwiftUI
import SwiftySpot

struct ArtistScreen: View {
    
    @EnvironmentObject var api: ApiController
    @EnvironmentObject var playController: PlaybackController
    
    @State fileprivate var _loaded: Bool?
    @State fileprivate var _errMsg: String = ""
    
    @State fileprivate var _artistInfo: ArtistInfoVModel
    
    init(artistShort: SPMetadataArtist) {
        __artistInfo = State(initialValue: ArtistInfoVModel(artist: artistShort))
        __loaded = State(initialValue: nil)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if (_loaded == nil) {
                LoadingView()
            } else if (_loaded == false) {
                ErrorView(title: R.string.localizable.artistLoadError(), subtitle: _errMsg) {
                    _loaded = nil
                    _errMsg = ""
                    Task {
                        _loaded = await loadData()
                    }
                }
            } else {
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVStack(alignment: .leading, spacing: 12, content: {
                        ArtistHeaderView(uri: _artistInfo.artist.uri, name: _artistInfo.artist.name, genres: _artistInfo.artist.genres, img: nil)
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        Divider()
                        if (!_artistInfo.albums.orderedUris.isEmpty) {
                            Text(R.string.localizable.generalAlbums())
                                .font(.title3.weight(.semibold))
                                .multilineTextAlignment(.leading)
                                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            AlbumsCollectionView(collection: _artistInfo.albums)
                            Divider()
                        }
                        if (!_artistInfo.singles.orderedUris.isEmpty) {
                            Text(R.string.localizable.artistSingles())
                                .font(.title3.weight(.semibold))
                                .multilineTextAlignment(.leading)
                                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            AlbumsCollectionView(collection: _artistInfo.singles)
                            Divider()
                        }
                        if (!_artistInfo.appears.orderedUris.isEmpty) {
                            Text(R.string.localizable.artistAppears())
                                .font(.title3.weight(.semibold))
                                .multilineTextAlignment(.leading)
                                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            AlbumsCollectionView(collection: _artistInfo.appears)
                            Divider()
                        }
                        if (!_artistInfo.compilations.orderedUris.isEmpty) {
                            Text(R.string.localizable.artistCompilations())
                                .font(.title3.weight(.semibold))
                                .multilineTextAlignment(.leading)
                                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            AlbumsCollectionView(collection: _artistInfo.compilations)
                            Divider()
                        }
                        if (!_artistInfo.topTracks.orderedUris.isEmpty) {
                            HStack(alignment: .center, spacing: 0) {
                                Text(R.string.localizable.artistTopTracks())
                                    .font(.title3.weight(.semibold))
                                    .multilineTextAlignment(.leading)
                                /*Spacer(minLength: 16)
                                Button(action: {
                                    //TODO open all songs
                                }, label: {
                                    Text(R.string.localizable.generalAll)
                                        .font(.headline)
                                        .foregroundColor(Color(R.color.primary))
                                })*/
                            }
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                            
                            ForEach(0..._artistInfo.topTracks.orderedUris.count - 1, id: \.self) { index in
                                let uri = _artistInfo.topTracks.orderedUris[index]
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
                                    let vmodelHash = _artistInfo.orderedUrisSeqHash
                                    let playbackHash = playController.playSeqHash
                                    if (vmodelHash == playbackHash && !playController.shuffle) {
                                        _ = playController.setPlayingTrackByIndex(index, play: true)
                                        return
                                    }
                                    _ = playController.setPlaybackSeq(_artistInfo.orderedPlaybackSeq, playIndex: index, playNow: true)
                                }
                                if let safeTrack = _artistInfo.topTracks.details[uri] {
                                    let artists: [String] = safeTrack.artists.map({ artist in
                                        return artist.name
                                    })
                                    TrackView(trackUri: uri, title: safeTrack.name, img: nil, artists: artists, onPress: onPress, playUri: playController.playingTrackUri)
                                } else {
                                    TrackView(trackUri: uri, title: "N/A", img: nil, artists: [], onPress: onPress, playUri: playController.playingTrackUri)
                                }
                            }
                            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                        }
                    })
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: 16, trailing: 0))
                }
            }
        }
        .navigationTitle(_artistInfo.artist.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear(perform: {
            if let safeArtistInfo = api.client.artistsMetaStorage.find(uri: _artistInfo.artist.uri) {
                //Cache search
                _artistInfo.updateArtist(safeArtistInfo)
                let tracks = safeArtistInfo.allTopTracks
                _artistInfo.topTracks.setUris(tracks.map({ track in
                    return track.uri
                }))
                let trackDetails = api.client.tracksMetaStorage.findAsDict(uris: _artistInfo.topTracks.noInfoUris)
                _artistInfo.topTracks.updateDetails(trackDetails)
                
                _artistInfo.albums.setUris(safeArtistInfo.albums.map({ album in
                    return album.uri
                }))
                _artistInfo.singles.setUris(safeArtistInfo.singles.map({ album in
                    return album.uri
                }))
                _artistInfo.appears.setUris(safeArtistInfo.appears.map({ album in
                    return album.uri
                }))
                _artistInfo.compilations.setUris(safeArtistInfo.compilations.map({ album in
                    return album.uri
                }))
                var allNoInfoUris: [String] = []
                allNoInfoUris.append(contentsOf: _artistInfo.albums.noInfoUris)
                allNoInfoUris.append(contentsOf: _artistInfo.singles.noInfoUris)
                allNoInfoUris.append(contentsOf: _artistInfo.appears.noInfoUris)
                allNoInfoUris.append(contentsOf: _artistInfo.compilations.noInfoUris)
                let details = api.client.albumsMetaStorage.findAsDict(uris: Set<String>(allNoInfoUris))
                _artistInfo.updateAlbumsDetails(details)
                
                if (_artistInfo.topTracks.noInfoUris.isEmpty && (_artistInfo.albums.orderedUris.isEmpty || _artistInfo.albums.noInfoUris.isEmpty) && (_artistInfo.singles.orderedUris.isEmpty || _artistInfo.singles.noInfoUris.isEmpty) && (_artistInfo.appears.orderedUris.isEmpty || _artistInfo.appears.noInfoUris.isEmpty) &&  (_artistInfo.compilations.orderedUris.isEmpty || _artistInfo.compilations.noInfoUris.isEmpty)) {
                    _artistInfo.refreshAlbumsOrderByReleaseDate()
                    _loaded = true
                    return
                }
            }
#if DEBUG
            if (ProcessInfo.processInfo.previewMode) {
                //Disable real API requests
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    _artistInfo.topTracks.setUris([
                        "sp:t:123",
                        "sp:t:1234",
                        "sp:t:12345",
                        "sp:t:123456",
                        "sp:t:1234567",
                        "sp:t:12345678",
                    ])
                    _artistInfo.topTracks.updateDetails([
                        "sp:t:123": SPMetadataTrack(gid: [], name: "Some track name"),
                        "sp:t:1234": SPMetadataTrack(gid: [], name: "Some track name 2"),
                        "sp:t:12345": SPMetadataTrack(gid: [], name: "Some track name 3"),
                        "sp:t:123456": SPMetadataTrack(gid: [], name: "Some track name 4"),
                        "sp:t:1234567": SPMetadataTrack(gid: [], name: "Some track name 5"),
                        "sp:t:12345678": SPMetadataTrack(gid: [], name: "Some track name 6")
                    ])
                    _artistInfo.albums.setUris([
                        "sp:t:123",
                        "sp:t:1234",
                        "sp:t:12345",
                        "sp:t:123456",
                        "sp:t:1234567",
                        "sp:t:12345678",
                    ])
                    _artistInfo.albums.updateDetails([
                        "sp:t:123": SPMetadataAlbum(gid: [], name: "Some album name"),
                        "sp:t:1234": SPMetadataAlbum(gid: [], name: "Some album name 2"),
                        "sp:t:12345": SPMetadataAlbum(gid: [], name: "Some album name 3"),
                        "sp:t:123456": SPMetadataAlbum(gid: [], name: "Some album name 4"),
                        "sp:t:1234567": SPMetadataAlbum(gid: [], name: "Some album name 5"),
                        "sp:t:12345678": SPMetadataAlbum(gid: [], name: "Some album name 6")
                    ])
                    _loaded = true
                }
                return
            }
#endif
            Task {
                _loaded = await loadData()
            }
        })
    }
    
    fileprivate func loadData() async -> Bool {
        if let safeArtist = api.client.artistsMetaStorage.find(uri: _artistInfo.artist.uri) {
            _artistInfo.updateArtist(safeArtist)
        } else {
            let artistMeta = await withCheckedContinuation { continuation in
                api.client.getArtistsDetails(artistUris: [_artistInfo.artist.uri]) { result in
                    switch(result) {
                    case .success(let artistInfo):
                        continuation.resume(returning: artistInfo)
                        break
                    case .failure(let error):
                        _errMsg = error.errorDescription
                        continuation.resume(returning: [:])
                        break
                    }
                }
            }
            guard let safeArtistMeta = artistMeta.first else {
                return false
            }
            _artistInfo.updateArtist(safeArtistMeta.value)
        }
        let allTopTrackUris = _artistInfo.artist.allTopTracks.map { track in
            return track.uri
        }
        _artistInfo.topTracks.setUris(allTopTrackUris)
        let noInfoTrackUris = _artistInfo.topTracks.noInfoUris
        if (!noInfoTrackUris.isEmpty) {
            let topTracks = await withCheckedContinuation { continuation in
                api.client.getTracksDetails(trackUris: [String].init(noInfoTrackUris)) { result in
                    switch(result) {
                    case .success(let tracksInfo):
                        continuation.resume(returning: tracksInfo)
                        break
                    case .failure(let error):
                        _errMsg = error.errorDescription
                        continuation.resume(returning: [:])
                        break
                    }
                }
            }
            if (!topTracks.isEmpty) {
                _artistInfo.topTracks.updateDetails(topTracks)
            }
            if (!_errMsg.isEmpty) {
                return false
            }
        }
        var allAlbumUris: [String] = []
        allAlbumUris.append(contentsOf: _artistInfo.albums.orderedUris)
        allAlbumUris.append(contentsOf: _artistInfo.singles.orderedUris)
        allAlbumUris.append(contentsOf: _artistInfo.appears.orderedUris)
        allAlbumUris.append(contentsOf: _artistInfo.compilations.orderedUris)
        return await withCheckedContinuation { continuation in
            api.client.getAlbumsDetails(albumUris: allAlbumUris) { result in
                switch(result) {
                case .success(let albumsInfo):
                    _artistInfo.updateAlbumsDetails(albumsInfo)
                    _artistInfo.refreshAlbumsOrderByReleaseDate()
                    continuation.resume(returning: true)
                    break
                case .failure(let error):
                    _errMsg = error.errorDescription
                    continuation.resume(returning: false)
                    break
                }
            }
        }
    }
}

#Preview(body: {
    @StateObject var api = ApiController(previewApiClient)
    let shortArtistInfo = SPMetadataArtist(gid: [], name: "Artist name", uri: SPNavigateUriUtil.generateArtistUri(id: "123435"))
    return ArtistScreen(artistShort: shortArtistInfo)
        .environmentObject(api)
        .environmentObject(previewPlayController)
})
