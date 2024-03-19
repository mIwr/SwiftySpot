//
//  PlaybackSeqScreen.swift
//  RhythmRider
//
//  Created by developer on 27.10.2023.
//

import SwiftUI

struct PlaybackSeqScreen: View {
    
    @EnvironmentObject var playController: PlaybackController
    
    @State var playbackSeq: [PlaybackTrack]
    @Binding var presented: Bool
    
    fileprivate let _initPlayingTrackUri: String
    
    init(presented: Binding<Bool>, playingTrackUri:String) {
        _playbackSeq = State(initialValue: [])
        _presented = presented
        _initPlayingTrackUri = playingTrackUri
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom), content: {
            if (playbackSeq.isEmpty) {
                VStack(alignment: .center, spacing: 16) {
                    Image(R.image.icAlertTriangle)
                        .resizable()
                        .frame(width: 80, height: 80, alignment: .center)
                        .foregroundColor(Color(R.color.primary))
                    Text(R.string.localizable.playlistNoTracks)
                        .font(.headline).fontWeight(.semibold)
                        .lineLimit(3)
                        .multilineTextAlignment(.center)
                        .foregroundColor(Color(R.color.primary))
                }
                .frame(maxHeight: .infinity)
            } else {
                ScrollViewReader(content: { proxy in
                    ScrollView(.vertical, showsIndicators: false) {
                        VStack(alignment: .center, spacing: 12) {
                            ForEach(0...playbackSeq.count - 1, id: \.self) { index in
                                let uri = playbackSeq[index].uri
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
                                    _ = playController.setPlayingTrackByIndex(index, play: true)
                                }
                                let track = playbackSeq[index].trackMeta
                                let artists: [(uri: String, name: String)] = track.artists.map({ artist in
                                    return (uri: artist.uri, name: artist.name)
                                })
                                TrackView(trackUri: uri, title: track.name, img: nil, artists: artists, onPress: onPress, playUri: playController.playingTrackUri)
                                    .id(uri)
                            }
                        }
                        .padding(EdgeInsets(top: 16, leading: 0, bottom: Constants.defaultButtonHeight + 16 + 12, trailing: 0))
                        .onAppear(perform: {
                            if (_initPlayingTrackUri.isEmpty) {
                                return
                            }
                            proxy.scrollTo(_initPlayingTrackUri, anchor: .center)
                        })
                    }
                })
            }
            Button(action: {
                presented = false
            }, label: {
                Text(R.string.localizable.generalClose())
                    .font(.headline)
                    .foregroundColor(Color(R.color.primary))
            })
            .buttonStyle(AccentWideButtonStyle())
            .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
        })
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .onAppear(perform: {
            playbackSeq = playController.playItemsSeq
        })
        .onReceive(NotificationCenter.default.publisher(for: .SPPlaybackSeqUpdate), perform: { notification in
            let parseRes = notification.tryParsePlaybackSeqUpdate()
            guard let seq = parseRes.1, parseRes.0 else {return}
            playbackSeq = seq
        })
    }
}

#Preview {
    @State var presented = true
    return PlaybackSeqScreen(presented: $presented, playingTrackUri: "")
        .environmentObject(previewPlayController)
}
