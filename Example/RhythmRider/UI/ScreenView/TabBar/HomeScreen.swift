//
//  HomeScreen.swift
//  RhythmRider
//
//  Created by Developer on 16.10.2023.
//

import SwiftUI
import SwiftySpot

struct HomeScreen: View {
    
    @EnvironmentObject fileprivate var api: ApiController
    
    @State fileprivate var _loaded: Bool? = nil
    @State fileprivate var _errMsg: String = ""
    fileprivate var _playlists: LandingPlaylistArrVModel = LandingPlaylistArrVModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if (_loaded == nil) {
                LoadingView()
            } else if (_loaded == false) {
                ErrorView(title: R.string.localizable.homeLoadError(), subtitle: _errMsg) {
                    _loaded = nil
                    _errMsg = ""
                    Task {
                        _loaded = await loadData()
                    }
                }
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            } else {
                Text(R.string.localizable.homePlaylistSet())
                    .font(.title3)
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 16))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 12.0) {
                        ForEach(_playlists.orderedValues, id: \.uri) { playlist in
                            NavigationLink {
                                PlaylistScreen(playlistShort: playlist)
                            } label: {
                                PlaylistCardView(uri: playlist.uri, title: playlist.name, subtitle: playlist.subtitle, img: nil)
                            }
                        }
                    }
                }
            }
        }
        .frame(maxHeight: .infinity, alignment: .top)
        .onAppear {
            if (_loaded != nil) {
                if (!_playlists.mayRefresh) {
                    return
                }
                if (_loaded != nil) {
                    _loaded = nil
                }
            }
            #if DEBUG
            if (ProcessInfo.processInfo.previewMode) {
                //Disable real API requests
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    _playlists.setLandingPlaylists([
                        SPLandingPlaylist(name: "Preview playlist", subtitle: "sub", uri: "sp:123", image: ""),
                        SPLandingPlaylist(name: "Preview playlist 2", subtitle: "sub", uri: "sp:1234", image: ""),
                        SPLandingPlaylist(name: "Preview playlist 3", subtitle: "sub", uri: "sp:12345", image: "")
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
        return await withCheckedContinuation { continuation in
            api.client.getLandingData { result in
                do {
                    let info = try result.get()
                    if (_playlists.mayRefresh && _playlists.updSeqTsUTC != 0) {
                        //Remove outdated playlist data from meta repository
                        api.client.metaStorage.removeOutdatedPlaylists(info.playlists.map({ playlist in
                            return playlist.uri
                        }))
                    }
                    _playlists.setLandingPlaylists(info.playlists)
                    continuation.resume(returning: true)
                } catch {
                    _errMsg = error.localizedDescription
                    continuation.resume(returning: false)
                }
            }
        }
    }
}

#Preview {
    @StateObject var api = ApiController(previewApiClient)
    return HomeScreen().environmentObject(api)
}
