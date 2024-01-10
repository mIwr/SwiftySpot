//
//  PlaylistScreen.swift
//  RhythmRider
//
//  Created by Developer on 16.10.2023.
//

import SwiftUI
import SwiftySpot

struct PlaylistScreen: View {
    
    @EnvironmentObject var api: ApiController
    @EnvironmentObject var playController: PlaybackController
    
    @State fileprivate var _loaded: Bool? = nil
    @State fileprivate var _errMsg: String = ""
    
    fileprivate var _playlistDetailed: PlaylistInfoVModel
    
    init(playlistShort: SPLandingPlaylist) {
        var title = playlistShort.name
        var subtitle = playlistShort.subtitle
        if (playlistShort.name.isEmpty) {
            title = playlistShort.subtitle
            subtitle = ""
        }
        _playlistDetailed = PlaylistInfoVModel(id: playlistShort.id, name: title, desc: subtitle)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            if (_loaded == nil) {
                LoadingView()
            } else if (_loaded == false) {
                ErrorView(title: R.string.localizable.playlistTracksLoadError(), subtitle: _errMsg) {
                    _loaded = nil
                    _errMsg = ""
                    Task {
                        _loaded = await loadData()
                    }
                }
            } else {
                ScrollView(.vertical, showsIndicators: true) {
                    LazyVStack(alignment: .leading, spacing: 12, content: {
                        PlaylistHeaderView(title: _playlistDetailed.name, desc: _playlistDetailed.desc, img: nil, tracksCount: _playlistDetailed.tracks.orderedUris.count)
                            
                        Divider()
                        ForEach(0..._playlistDetailed.tracks.orderedUris.count - 1, id: \.self) { index in
                            
                            let uri = _playlistDetailed.tracks.orderedUris[index]
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
                                let vmodelHash = _playlistDetailed.orderedUrisSeqHash
                                let playbackHash = playController.playSeqHash
                                if (vmodelHash == playbackHash && !playController.shuffle) {
                                    _ = playController.setPlayingTrackByIndex(index, play: true)
                                    return
                                }
                                _ = playController.setPlaybackSeq(_playlistDetailed.orderedPlaybackSeq, playIndex: index, playNow: true)
                            }
                            if let safeTrack = _playlistDetailed.tracks.details[uri] {
                                let artists: [String] = safeTrack.artists.map({ artist in
                                    return artist.name
                                })
                                TrackView(trackUri: uri, title: safeTrack.name, img: nil, artists: artists, onPress: onPress, playUri: playController.playingTrackUri)
                            } else {
                                TrackView(trackUri: uri, title: "N/A", img: nil, artists: [], onPress: onPress, playUri: playController.playingTrackUri)
                            }
                        }
                    })
                    .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
                }
            }
        }
        .navigationTitle(_playlistDetailed.name)
        .navigationBarTitleDisplayMode(.inline)
        .onAppear {
            if let safePlaylistInfo = api.client.playlistsMetaStorage.find(uri: _playlistDetailed.uri) {
                _playlistDetailed.tracks.setUris(safePlaylistInfo.tracks.map({ track in
                    return track.uri
                }))
                _playlistDetailed.tracks.updateDetails(api.client.tracksMetaStorage.findAsDict(uris: Set(safePlaylistInfo.tracks.map({ trackMeta in
                    return trackMeta.uri
                }))))
                if (_playlistDetailed.tracks.noInfoUris.isEmpty) {
                    _loaded = true
                    return
                }
            }
#if DEBUG
            if (ProcessInfo.processInfo.previewMode) {
                //Disable real API requests
                DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                    _playlistDetailed.tracks.setUris([
                        "sp:t:123",
                        "sp:t:1234",
                        "sp:t:12345",
                        "sp:t:123456",
                        "sp:t:1234567",
                        "sp:t:12345678",
                    ])
                    _playlistDetailed.tracks.updateDetails([
                        "sp:t:123": SPMetadataTrack(gid: [], name: "Some track name"),
                        "sp:t:1234": SPMetadataTrack(gid: [], name: "Some track name 2"),
                        "sp:t:12345": SPMetadataTrack(gid: [], name: "Some track name 3"),
                        "sp:t:123456": SPMetadataTrack(gid: [], name: "Some track name 4"),
                        "sp:t:1234567": SPMetadataTrack(gid: [], name: "Some track name 5"),
                        "sp:t:12345678": SPMetadataTrack(gid: [], name: "Some track name 6")
                    ])
                    _loaded = true
                }
                return
            }
#endif
            Task {
                _loaded = await loadData()
            }
        }
    }
    
    fileprivate func loadData() async -> Bool {
        if (_playlistDetailed.tracks.orderedUris.isEmpty) {
            let playlistTracks = await withCheckedContinuation { continuation in
                api.client.getPlaylistInfo(id: _playlistDetailed.id) { result in
                    switch(result) {
                    case .success(let playlistInfo):
                        continuation.resume(returning: playlistInfo.tracks)
                        break
                    case .failure(let error):
                        _errMsg = error.errorDescription
                        continuation.resume(returning: [])
                        break
                    }
                }
            }
            if (playlistTracks.isEmpty) {
                return false
            }
            _playlistDetailed.tracks.setUris(playlistTracks.map({ track in
                return track.uri
            }))
        }
        return await withCheckedContinuation { continuation in
            api.client.getTracksDetails(trackUris: [String].init(_playlistDetailed.tracks.noInfoUris)) { result in
                switch (result) {
                case .success(let info):
                    _playlistDetailed.tracks.updateDetails(info)
                    continuation.resume(returning: true)
                    return
                case .failure(let error):
                    _errMsg = error.errorDescription
                    continuation.resume(returning: false)
                    return
                }
            }
        }
    }
}

#Preview(body: {
    @StateObject var api = ApiController(previewApiClient)
    let landingPlaylist = SPLandingPlaylist(name: "Playlist name", subtitle: "Playlist subtitle", uri: "sp:1234", image: "")
    return NavigationView(content: {
        PlaylistScreen(playlistShort: landingPlaylist)
    })
    .environmentObject(api)
    .environmentObject(previewPlayController)
})
