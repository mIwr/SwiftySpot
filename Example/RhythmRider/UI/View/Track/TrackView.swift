//
//  TrackView.swift
//  RhythmRider
//
//  Created by Developer on 09.10.2023.
//

import SwiftUI
import SwiftySpot

struct TrackView: View {
    
    @EnvironmentObject var api: ApiController
    
    let trackUri: String
    @State var title: String
    let img: UIImage?
    @State var artists: [(uri: String, name: String)]
    let onPress: () -> Void
    @State var like: Bool
    @State var dislike: Bool
    @State var playing: Bool
    
    @State var generatedPlaylistUri: String
    
    @State fileprivate var _showTrackInfoSheet: Bool
    @State fileprivate var _showArtistInfoSheet: Bool
    @State fileprivate var _showGeneratedPlaylistSheet: Bool
    
    fileprivate var _trackId: String {
        get {
            let typedObj = SPTypedObj(uri: trackUri, globalID: [])
            return typedObj.id
        }
    }
    
    fileprivate var _artistString: String {
        get {
            if (artists.isEmpty) {
                return "N/A"
            }
            var res = artists[0].name
            if (artists.count > 1) {
                for i in 1 ... artists.count - 1 {
                    res += " • " + artists[i].name
                }
            }
            return res
        }
    }
    
    init(trackUri: String, title: String, img: UIImage?, artists: [(uri: String, name: String)], onPress: @escaping () -> Void, playUri: String) {
        self.trackUri = trackUri
        _title = State(initialValue: title)
        self.img = img
        _artists = State(initialValue: artists)
        self.onPress = onPress
        _generatedPlaylistUri = State(initialValue: "")
        _like = State(initialValue: false)
        _dislike = State(initialValue: false)
        _playing = State(initialValue: playUri == trackUri)
        __showTrackInfoSheet = State(initialValue: false)
        __showArtistInfoSheet = State(initialValue: false)
        __showGeneratedPlaylistSheet = State(initialValue: false)
    }
    
    var body: some View {
        let safeImg = img ?? R.image.cover() ?? UIImage()
        let bgColorRes = playing ? R.color.bgTertiary : R.color.bgSecondary
        let titleFgColor = dislike ? R.color.tertiary: R.color.primary
        let artistFgColor = dislike ? R.color.tertiary: R.color.secondary
        Button(action: onPress, label: {
            HStack(alignment: .center, spacing: 12.0) {
                Image(uiImage: safeImg)
                    .resizable()
                    .frame(width: 80, height: 80)
                    .cornerRadius(8)
                VStack(alignment: .leading, spacing: 4.0) {
                    Text(title)
                        .font(.headline).lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color(titleFgColor))
                    Text(_artistString)
                        .font(.body).lineLimit(1)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color(artistFgColor))
                }.frame(maxWidth: .infinity, alignment: .leading)
            }
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
        })
        .background(Color(bgColorRes))
        .cornerRadius(8.0)
        .contextMenu(ContextMenu(menuItems: {
            _likeMenuAction
            if (artists.count == 1) {
                _goToArtistMenuAction
            }
            _generatePlaylistFromTrackSeedMenuAction
            _trackInfoMenuAction
            _shareMenuAction
            _dislikeMenuAction
        }))
        .sheet(isPresented: $_showArtistInfoSheet, onDismiss: {
            _showArtistInfoSheet = false
        }, content: {
            let safePair = artists.first ?? (uri: "", name: "N/A")
            let safeArtistMeta = api.client.artistsMetaStorage.find(uri: safePair.uri) ?? SPMetadataArtist(gid: [], name: safePair.name, uri: safePair.uri)
            ArtistScreen(artistShort: safeArtistMeta)
        })
        .sheet(isPresented: Binding<Bool>(get: {
            return !generatedPlaylistUri.isEmpty && _showGeneratedPlaylistSheet
        }, set: { boolVal in
            _showGeneratedPlaylistSheet = boolVal
        }), onDismiss: {
            _showGeneratedPlaylistSheet = false
        }, content: {
            let playlist = SPLandingPlaylist(name: "", subtitle: "", uri: generatedPlaylistUri, image: "")
            PlaylistScreen(playlistShort: playlist)
        })
        .sheet(isPresented: $_showTrackInfoSheet, onDismiss: {
            _showTrackInfoSheet = false
        }, content: {
            let safeTrackMeta = api.client.tracksMetaStorage.find(uri: trackUri) ?? SPMetadataTrack(gid: [], name: title, uri: trackUri, artists: artists.map({ pair in
                return SPMetadataArtist(gid: [], name: pair.name)
            }))
            TrackFullInfoScreen(safeTrackMeta, presented: $_showTrackInfoSheet)
        })
        .onAppear(perform: {
            let liked = api.client.likedTracksStorage.find(uri: trackUri)
            let disliked = api.client.dislikedTracksStorage.find(uri: trackUri)
            like = liked != nil ? true : false
            dislike = disliked != nil ? true : false
        })
        .onReceive(NotificationCenter.default.publisher(for: .SPTrackMetaUpdate), perform: { notification in
            let parseRes = notification.tryParseTrackMetaUpdate()
            let success = parseRes.0
            if (!success) {
                return
            }
            guard let trackObj = parseRes.1 else {return}
            if (trackUri != trackObj.uri) {
                return
            }
            title = trackObj.name
            artists = trackObj.artists.map({ artist in
                return (uri: artist.uri, name: artist.name)
            })
        })
        .onReceive(NotificationCenter.default.publisher(for: .SPPlayItemUpdate), perform: { notification in
            let parseRes = notification.tryParsePlayItemUpdate()
            let success = parseRes.0
            if (!success) {
                return
            }
            guard let trackObj = parseRes.1 else {return}
            let newPlayingStatus = trackObj.uri == trackUri
            if (newPlayingStatus == playing) {
                return
            }
            playing = newPlayingStatus
        })
        .onReceive(NotificationCenter.default.publisher(for: .SPTrackLikeUpdate), perform: { notification in
            let parsed = notification.tryParseTrackLikeUpdate()
            guard let item = parsed.1, parsed.0 else {return}
            if (item.uri != trackUri) {
                return
            }
            like = !item.removed && item.addedTs > 0
        })
        .onReceive(NotificationCenter.default.publisher(for: .SPTrackDislikeUpdate), perform: { notification in
            let parsed = notification.tryParseTrackDislikeUpdate()
            guard let item = parsed.1, parsed.0 else {return}
            if (item.uri != trackUri) {
                return
            }
            dislike = !item.removed && item.addedTs > 0
        })
    }
    
    fileprivate var _likeMenuAction: Button<Label<Text, some View>> {
        var menuItemTitle = R.string.localizable.itemContextLike()
        var imgRes = R.image.icHeart
        if (like) {
            menuItemTitle = R.string.localizable.itemContextRemoveLike()
            imgRes = R.image.icHeartFill
        }
        return Button(action: {
            like = !like
#if DEBUG
            if (ProcessInfo.processInfo.previewMode) {
                //Disable real API request
                return
            }
#endif
            if (!like) {
                //liked before toggle -> remove like
                api.client.removeTrackLike(uri: trackUri) { _ in
                    //If fails, the reset update will be received through notification center
                }
            } else {
                //liked after toggle -> like cmd
                api.client.likeTrack(uri: trackUri) { _ in
                    //If fails, the reset update will be received through notification center
                }
                if (api.client.dislikedTracksStorage.find(uri: trackUri) != nil) {
                    api.client.removeTrackDislike(uri: trackUri) { _ in
                    }
                }
            }
        }, label: {
            Label(
                title: { Text(menuItemTitle) },
                icon: {
                    Image(imgRes)
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                        .foregroundColor(Color(R.color.error))
                }
            )
        })
    }
    
    fileprivate var _goToArtistMenuAction: some View {
        return Button(action: {
            _showArtistInfoSheet = !_showArtistInfoSheet
        }, label: {
            Label(
                title: { Text(R.string.localizable.itemContextGoToArtist()) },
                icon: {
                    Image(R.image.icUser)
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                        .foregroundColor(Color(R.color.primary))
                }
            )
        })
    }
    
    fileprivate var _generatePlaylistFromTrackSeedMenuAction: some View {
        return Button(action: {
            if (!generatedPlaylistUri.isEmpty) {
                _showGeneratedPlaylistSheet = true
                return
            }
            api.client.getPlaylistFromTrack(trackId: _trackId) { result in
                do {
                    let playlistId = try result.get()
                    guard let safePlaylistId = playlistId.first, safePlaylistId.entityType == .playlist else {
                        return
                    }
                    generatedPlaylistUri = safePlaylistId.uri
                    _showGeneratedPlaylistSheet = true
                } catch {
                    #if DEBUG
                    print(error)
                    #endif
                }
            }
        }, label: {
            Label(
                title: { Text(R.string.localizable.itemContextPlaylistFromTrack()) },
                icon: {
                    Image(R.image.icAudio)
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                        .foregroundColor(Color(R.color.primary))
                }
            )
        })
    }
    
    fileprivate var _trackInfoMenuAction: some View {
        return Button(action: {
            _showTrackInfoSheet = !_showTrackInfoSheet
        }, label: {
            Label(
                title: { Text(R.string.localizable.itemContextTrackInfo()) },
                icon: {
                    Image(R.image.icInfo)
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                        .foregroundColor(Color(R.color.primary))
                }
            )
        })
    }
    
    fileprivate var _shareMenuAction: Button<Label<Text, some View>> {
        return Button(action: {
            guard let vc = UIApplication.shared.connectedScenes.compactMap({$0 as? UIWindowScene}).first?.windows.first?.rootViewController else { return }
            let item = _artistString + " - " + title + "\n" + SPConstants.defaultShareHost + "track/" + _trackId
            let shareActivity = UIActivityViewController(activityItems: [item], applicationActivities: nil)
            shareActivity.popoverPresentationController?.sourceView = vc.view
            shareActivity.popoverPresentationController?.sourceRect = CGRect(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height, width: 0, height: 0)
            shareActivity.popoverPresentationController?.permittedArrowDirections = UIPopoverArrowDirection.down
            vc.present(shareActivity, animated: true, completion: nil)
        }, label: {
            Label(
                title: { Text(R.string.localizable.itemContextShare()) },
                icon: {
                    Image(R.image.icShare)
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                        .foregroundColor(Color(R.color.primary))
                }
            )
        })
    }
    
    fileprivate var _dislikeMenuAction: Button<Label<Text, some View>> {
        var menuItemTitle = R.string.localizable.itemContextDislike()
        var imgRes = R.image.icHeartOff
        if (dislike) {
            menuItemTitle = R.string.localizable.itemContextRemoveDislike()
            imgRes = R.image.icHeartOffFill
        }
        return Button(action: {
            dislike = !dislike
#if DEBUG
                if (ProcessInfo.processInfo.previewMode) {
                    //Disable real API request
                    return
                }
#endif
            if (!dislike) {
                //disliked before toggle -> remove dislike
                api.client.removeTrackDislike(uri: trackUri) { _ in
                    //If fails, the reset update will be received through notification center
                }
            } else {
                //disliked after toggle -> dislike cmd
                api.client.dislikeTrack(uri: trackUri) { _ in
                    //If fails, the reset update will be received through notification center
                }
                if (api.client.likedTracksStorage.find(uri: trackUri) != nil) {
                    api.client.removeTrackLike(uri: trackUri) { _ in
                        
                    }
                }
            }
        }, label: {
            Label(
                title: { Text(menuItemTitle) },
                icon: {
                    Image(imgRes)
                        .resizable()
                        .frame(width: 24, height: 24, alignment: .center)
                        .foregroundColor(Color(R.color.primary))
                }
            )
        })
    }
}

#Preview {
    let playUri = "spotify:track:123"
    @StateObject var api = ApiController(previewApiClient)
    let onPress: () -> Void = {}
    return VStack {
        TrackView(trackUri: "234", title: "NOT-PLAYING long-long-long-long-long track name", img: R.image.previewCover(), artists: [(uri: "spotify:123", name: "Artist1"),(uri: "spotify:1234", name: "Artist2"),(uri: "spotify:12345", name: "Artist3")], onPress: onPress, playUri: playUri)
      Divider()
        TrackView(trackUri: playUri, title: "PLAYING long-long-long-long-long track name", img: R.image.previewCover(), artists: [(uri: "spotify:123", name: "Artist1"),(uri: "spotify:1234", name: "Artist2"),(uri: "spotify:12345", name: "Artist3")], onPress: onPress, playUri: playUri)
    }
    .environmentObject(api)
}
