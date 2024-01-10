//
//  TabBarScreen.swift
//  RhythmRider
//
//  Created by Developer on 16.10.2023.
//

import SwiftUI
import SwiftySpot

struct TabBarScreen: View {
    
    @EnvironmentObject var api: ApiController
    
    @State fileprivate var _loaded: Bool? = nil
    
    var body: some View {
        GeometryReader(content: { geometry in
            ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
                TabView {
                    NavigationView(content: {
                        HomeScreen()
                    })
                    .padding(EdgeInsets(top: 0, leading: 0, bottom:  NowPlayingView.totalContainerFrameHeight, trailing: 0))
                    .tabItem {
                        TabItemView(title: R.string.localizable.tabHome(), img: Image(R.image.icRadar))
                    }
                    .tag(0)
                    NavigationView(content: {
                        FavScreen()
                    })
                    .padding(EdgeInsets(top: 0, leading: 0, bottom:  NowPlayingView.totalContainerFrameHeight, trailing: 0))
                    .tabItem {
                        TabItemView(title: R.string.localizable.tabFav(), img: Image(R.image.icHeart))
                    }
                    .tag(1)
                    NavigationView(content: {
                        SearchScreen()
                    })
                    .padding(EdgeInsets(top: 0, leading: 0, bottom:  NowPlayingView.totalContainerFrameHeight, trailing: 0))
                    .tabItem {
                        TabItemView(title: R.string.localizable.tabSearch(), img: Image(R.image.icSearch))
                    }
                    .tag(2)
                    .ignoresSafeArea(.keyboard, edges: .bottom)
                }
                NowPlayingView()
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 48, trailing: 0))
                Divider()
                    .padding(EdgeInsets(top: 0, leading: 0, bottom: 48, trailing: 0))
            })
        })
        .onAppear(perform: {
            UITabBar.appearance().shadowImage = UIImage()
            UITabBar.appearance().backgroundImage = UIImage()
            UITabBar.appearance().isTranslucent = true
            UITabBar.appearance().unselectedItemTintColor = UIColor(resource: R.color.secondary)
            UITabBar.appearance().backgroundColor = UIColor(resource: R.color.bgSecondary)
            if (_loaded != nil) {
                return
            }
#if DEBUG
            if (ProcessInfo.processInfo.previewMode) {
                //Disable real API requests
                _loaded = true
                return
            }
#endif
            Task {
                _loaded = await loadData()
            }
        })
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
    
    fileprivate func loadData() async -> Bool {
        await withCheckedContinuation { continuation in
            api.client.getLikedTracks(pageLimit: SPCollectionController.defaultPageSize * 10, pageToken: nil) { _ in
                continuation.resume()
            }
        }
        await withCheckedContinuation { continuation in
            api.client.getDislikedTracks(pageLimit: SPCollectionController.defaultPageSize * 10, pageToken: nil) { _ in
                continuation.resume()
            }
        }
        await withCheckedContinuation { continuation in
            api.client.getLikedArtists(pageLimit: SPCollectionController.defaultPageSize * 10, pageToken: nil) { _ in
                continuation.resume()
            }
        }
        await withCheckedContinuation { continuation in
            api.client.getDislikedArtists(pageLimit: SPCollectionController.defaultPageSize * 10, pageToken: nil) { _ in
                continuation.resume()
            }
        }
        return true
    }
}

#Preview {
    @StateObject var api = ApiController(previewApiClient)
    return TabBarScreen()
        .environmentObject(previewProperties)
        .environmentObject(api)
        .environmentObject(previewPlayController)//for nowPlayingView and playlistScreen
}
