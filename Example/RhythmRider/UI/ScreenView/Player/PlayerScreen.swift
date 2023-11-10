//
//  PlayerScreen.swift
//  RhythmRider
//
//  Created by developer on 26.10.2023.
//

import SwiftUI
import SwiftySpot

struct PlayerScreen: View {
    
    @EnvironmentObject var api: ApiController
    @EnvironmentObject var playController: PlaybackController
    
    @Binding var trackName: String
    @Binding var artists: [String]
    @Binding var playing: Bool
    @State var shuffle: Bool
    @State var repeatMode: PlaybackController.PlayRepeatMode
    @State var playbackPositionInS: TimeInterval
    @State var dragginSlider: Bool
    @State var durationInMs: TimeInterval
    @State var like: Bool
    @State var dislike: Bool
    
    @State var showPlaybackSeqSheet: Bool
    @State var showShareActivityVC: Bool
    @State var showTrackFullInfoSheet: Bool
    
    init(trackName: Binding<String>, artists: Binding<[String]>, playing: Binding<Bool>) {
        _trackName = trackName
        _artists = artists
        _playing = playing
        
        _shuffle = State(initialValue: false)
        _repeatMode = State(initialValue: .noRepeat)
        _playbackPositionInS = State(initialValue: 0)
        _durationInMs = State(initialValue: 0.0)
        _dragginSlider = State(initialValue: false)
        _like = State(initialValue: false)
        _dislike = State(initialValue: false)
        _showPlaybackSeqSheet = State(initialValue: false)
        _showShareActivityVC = State(initialValue: false)
        _showTrackFullInfoSheet = State(initialValue: false)
    }
    
    var artistString: String {
        get {
            if (artists.isEmpty) {
                return ""
            }
            var res = artists[0]
            if (artists.count > 1) {
                for i in 1 ... artists.count - 1 {
                    res += " • " + artists[i]
                }
            }
            return res
        }
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0, content: {
            Rectangle()
                .frame(width: 48, height: 4)
                .background(Color(R.color.bgTertiary))
                .cornerRadius(8)
            Spacer(minLength: 16)
            Image(R.image.cover)
                .resizable()
                .frame(minWidth: 120, minHeight: 120, alignment: .center)
                .aspectRatio(1.0, contentMode: .fit)
                .cornerRadius(24)
            Spacer(minLength: 24)
            HStack(alignment: .center, spacing: 0, content: {
                VStack(alignment: .leading, spacing: 2, content: {
                    Text(trackName)
                        .font(.headline).fontWeight(.semibold)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color(R.color.primary))
                    Text(artistString)
                        .font(.subheadline).fontWeight(.regular)
                        .lineLimit(2)
                        .multilineTextAlignment(.leading)
                        .foregroundColor(Color(R.color.secondary))
                })
                Spacer(minLength: 8)
                Button(action: {
#if DEBUG
                    if (ProcessInfo.processInfo.previewMode) {
                        //Disable real API request and override validation
                        like = !like
                        return
                    }
#endif
                    if (playController.playingTrackUri.isEmpty || !SPNavigateUriUtil.validateTrackUri(playController.playingTrackUri)) {
                        return
                    }
                    like = !like
                    if (!like) {
                        //liked before toggle -> remove like
                        api.client.removeTrackLike(uri: playController.playingTrackUri) { _ in
                            //If fails, the reset update will be received through notification center
                        }
                    } else {
                        //liked after toggle -> like cmd
                        api.client.likeTrack(uri: playController.playingTrackUri) { _ in
                            //If fails, the reset update will be received through notification center
                        }
                        if (api.client.dislikedTracksStorage.find(uri: playController.playingTrackUri) != nil) {
                            api.client.removeTrackDislike(uri: playController.playingTrackUri) { _ in
                            }
                        }
                    }
                }, label: {
                    Image(like
                          ? R.image.icHeartFill
                          : R.image.icHeart)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(R.color.error))
                })
                .frame(width: 32, height: 32, alignment: .center)
            })
            .frame(maxWidth: .infinity, alignment: .leading)
            Slider(value: $playbackPositionInS, in: 0...durationInMs / 1000) { editing in
                if (dragginSlider != editing) {
                    dragginSlider = editing
                }
                if (editing) {
                    return
                }
                _ = playController.setPlaybackPosition(playbackPositionInS)
            }
            .foregroundColor(Color(R.color.accent))
            HStack(alignment: .center, spacing: 0, content: {
                Text(DateUtil.formattedTrackTime(playbackPositionInS))
                    .font(.caption).fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundColor(Color(R.color.secondary))
                Spacer(minLength: 16)
                Text(DateUtil.formattedTrackTime(durationInMs / 1000))
                    .font(.caption).fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundColor(Color(R.color.secondary))
            })
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
            HStack(alignment: .center, spacing: 0, content: {
                Button(action: {
                    shuffle = !shuffle
                    playController.setShuffleMode(enabled: shuffle)
                }, label: {
                    Image(shuffle
                          ? R.image.icShuffleFill
                          : R.image.icShuffle)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(R.color.primary))
                })
                .frame(width: 32, height: 32, alignment: .center)
                Spacer(minLength: 16)
                HStack(alignment: .center, spacing: 32, content: {
                    Button(action: {
                        _ = playController.playPreviousTrack()
                    }, label: {
                        Image(R.image.icFastRewind)
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(Color(R.color.primary))
                    })
                    .frame(width: 40, height: 40, alignment: .center)
                    Button(action: {
                        if (playController.playing) {
                            _ = playController.pause()
                            return
                        }
                        _ = playController.play()
                    }, label: {
                        Image(playing
                              ? R.image.icPause
                              : R.image.icPlay)
                            .resizable()
                            .frame(width: 28, height: 28)
                            .foregroundColor(Color(R.color.primary))
                    })
                    .frame(width: 48, height: 48, alignment: .center)
                    .padding(EdgeInsets(top: 8, leading: 8, bottom: 8, trailing: 8))
                    .background(Color(R.color.bgSecondary))
                    .cornerRadius(56)
                    Button(action: {
                        _ = playController.playNextTrack()
                    }, label: {
                        Image(R.image.icFastForward)
                            .resizable()
                            .frame(width: 32, height: 32)
                            .foregroundColor(Color(R.color.primary))
                    })
                    .frame(width: 40, height: 40, alignment: .center)
                })
                Spacer(minLength: 16)
                Button(action: {
                    toggleRepeatMode()
                    playController.setRepeatMode(repeatMode)
                }, label: {
                    getRepeatModeIco()
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(R.color.primary))
                })
                .frame(width: 32, height: 32, alignment: .center)
            })
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 16, trailing: 0))
            HStack(alignment: .center, spacing: 0, content: {
                Button(action: {
#if DEBUG
                    if (ProcessInfo.processInfo.previewMode) {
                        //Disable real API request and override validation
                        dislike = !dislike
                        return
                    }
#endif
                    if (playController.playingTrackUri.isEmpty || !SPNavigateUriUtil.validateTrackUri(playController.playingTrackUri)) {
                        return
                    }
                    dislike = !dislike
                    if (!dislike) {
                        //disliked before toggle -> remove dislike
                        api.client.removeTrackDislike(uri: playController.playingTrackUri) { _ in
                            //If fails, the reset update will be received through notification center
                        }
                    } else {
                        //disliked after toggle -> dislike cmd
                        api.client.dislikeTrack(uri: playController.playingTrackUri) { dislikeRes in
                            //If fails, the reset update will be received through notification center
                            do {
                                let status = try dislikeRes.get()
                                if (!status) {
                                    return
                                }
                                _ = self.playController.playNextTrack()
                            } catch {
                                
                            }
                        }
                        if (api.client.likedTracksStorage.find(uri: playController.playingTrackUri) != nil) {
                            api.client.removeTrackLike(uri: playController.playingTrackUri) { _ in
                                
                            }
                        }
                    }
                }, label: {
                    Image(dislike
                          ? R.image.icHeartOffFill
                          : R.image.icHeartOff)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color(R.color.primary))
                }).frame(width: 24, height: 24, alignment: .center)
                Spacer(minLength: 16)
                HStack(alignment: .center, spacing: 16, content: {
                    Button(action: {
                        showShareActivityVC = !showShareActivityVC
                        if (playController.playingTrackUri.isEmpty || !SPNavigateUriUtil.validateTrackUri(playController.playingTrackUri)) {
                            return
                        }
                    }, label: {
                        Image(R.image.icShare)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(R.color.primary))
                    })
                    .frame(width: 24, height: 24, alignment: .center)
                    .sheet(isPresented: $showShareActivityVC, onDismiss: {
                        showShareActivityVC = false
                    }, content: {
                        let item = artistString + " - " + trackName + "\n" + playController.playingTrackUri
                        ActivityVC(presented: $showShareActivityVC, activityItems: [item])
                            .ignoresSafeArea(.all, edges: .bottom)
                    })
                    Button(action: {
                        showTrackFullInfoSheet = !showTrackFullInfoSheet
                    }, label: {
                        Image(R.image.icInfo)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(R.color.primary))
                    })
                    .frame(width: 24, height: 24, alignment: .center)
                    .sheet(isPresented: $showTrackFullInfoSheet, onDismiss: {
                        showShareActivityVC = false
                    }, content: {
                        let trackMeta = playController.playingTrack?.trackMeta ?? SPMetadataTrack(gid: [], name: trackName, uri: playController.playingTrackUri, album: nil, artists: artists.map({ artistName in
                            return SPMetadataArtist(gid: [], name: artistName)
                        }))
                        TrackFullInfoScreen(_trackInfo: trackMeta, presented: $showTrackFullInfoSheet)
                    })
                    Button(action: {
                        showPlaybackSeqSheet = !showPlaybackSeqSheet
                    }, label: {
                        Image(R.image.icPlaylist)
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(Color(R.color.primary))
                    })
                    .frame(width: 24, height: 24, alignment: .center)
                    .sheet(isPresented: $showPlaybackSeqSheet, onDismiss: {
                        showPlaybackSeqSheet = false
                    }, content: {
                        return PlaybackSeqScreen(presented: $showPlaybackSeqSheet, playingTrackUri: playController.playingTrackUri)
                    })
                })
            })
        })
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 12, trailing: 16))
        .onAppear(perform: {
            shuffle = playController.shuffle
            repeatMode = playController.repeatMode
            guard let safePlayingTrack = playController.playingTrack else {return}
            var collectionItem = api.client.likedTracksStorage.find(uri: safePlayingTrack.uri)
            like = collectionItem != nil ? true : false
            collectionItem = api.client.dislikedTracksStorage.find(uri: safePlayingTrack.uri)
            dislike = collectionItem != nil ? true : false
            durationInMs = TimeInterval(safePlayingTrack.trackMeta.durationInMs)
            playbackPositionInS = playController.playbackPositionInS
        })
        .onReceive(NotificationCenter.default.publisher(for: .SPPlaybackPositionUpdate), perform: { notification in
            if (dragginSlider) {
                return
            }
            let parseRes = notification.tryParsePlaybackPositionUpdate()
            guard let safeNewVal = parseRes.1, parseRes.0 else {return}
            if (safeNewVal < durationInMs / 1000) {
                playbackPositionInS = safeNewVal
                return
            }
            playbackPositionInS = safeNewVal
        })
        .onReceive(NotificationCenter.default.publisher(for: .SPPlayItemUpdate), perform: { notification in
            let parseRes = notification.tryParsePlayItemUpdate()
            guard let safeTrack = parseRes.1, parseRes.0 else {return}
            let newDurationInMs = TimeInterval(safeTrack.trackMeta.durationInMs)
            playbackPositionInS = 0
            durationInMs = newDurationInMs
            var collectionItem = api.client.likedTracksStorage.find(uri: safeTrack.uri)
            like = collectionItem != nil && collectionItem?.removed == false
            collectionItem = api.client.dislikedTracksStorage.find(uri: safeTrack.uri)
            dislike = collectionItem != nil && collectionItem?.removed == false
        })
        .onReceive(NotificationCenter.default.publisher(for: .SPTrackLikeUpdate), perform: { notification in
            let parsed = notification.tryParseTrackLikeUpdate()
            guard let item = parsed.1, parsed.0 else {return}
            if (item.uri != playController.playingTrackUri) {
                return
            }
            like = !item.removed && item.addedTs > 0
        })
        .onReceive(NotificationCenter.default.publisher(for: .SPTrackDislikeUpdate), perform: { notification in
            let parsed = notification.tryParseTrackDislikeUpdate()
            guard let item = parsed.1, parsed.0 else {return}
            if (item.uri != playController.playingTrackUri) {
                return
            }
            dislike = !item.removed && item.addedTs > 0
        })
    }
    
    fileprivate func toggleRepeatMode() {
        switch (repeatMode) {
        case .noRepeat:
            repeatMode = .repeatSequence
            return
        case .repeatSequence:
            repeatMode = .repeatItem
            return
        case .repeatItem:
            repeatMode = .noRepeat
            return
        }
    }
    fileprivate func getRepeatModeIco() -> Image {
        switch (repeatMode) {
        case .noRepeat:
            return Image(R.image.icRepeat)
        case .repeatSequence:
            return Image(R.image.icRepeatFill)
        case .repeatItem:
            return Image(R.image.icRepeatOneFill)
        }
    }
}

#Preview {
    @StateObject var api: ApiController = ApiController(previewApiClient)
    @State var trackName = "Track name"
    @State var artists = ["Artist 1", "Artist 2"]
    @State var playing = true
    return PlayerScreen(trackName: $trackName, artists: $artists, playing: $playing)
        .environmentObject(api)
        .environmentObject(previewPlayController)
}
