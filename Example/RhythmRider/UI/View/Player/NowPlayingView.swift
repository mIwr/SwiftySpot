//
//  NowPlayingView.swift
//  RhythmRider
//
//  Created by developer on 26.10.2023.
//

import SwiftUI

struct NowPlayingView: View {
    
    static let imgSizeVal: Double = 40.0
    static let imgPaddingVal: Double = 4.0
    static let containerVPaddingVal: Double = 6.0
    static let totalContainerFrameHeight: Double = imgSizeVal + (imgPaddingVal * 2) + (containerVPaddingVal * 2)
    
    @EnvironmentObject var playbackController: PlaybackController
    
    @State var trackName: String
    @State var artists: [String]
    @State var playing: Bool
    
    @State fileprivate var _sheetShow: Bool
    
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
    
    init() {
        self.trackName = ""
        self.artists = []
        self.playing = false
        self._sheetShow = false
    }
    
    var body: some View {
        var name = trackName
        if (name.isEmpty) {
            name = playing
            ? R.string.localizable.playerUnknownTrackTitle()
            : R.string.localizable.playerNotPlaying()
        }
        var sub = artistString
        if (sub.isEmpty && playing) {
            sub = R.string.localizable.playerUnknownArtist()
        }
        
        return Button(action: {
            if (playbackController.playSeqIndicies.isEmpty) {
                return
            }
            _sheetShow = true
        }, label: {
            HStack(alignment: .center, spacing: 0, content: {
                Image(R.image.icMusic)
                    .resizable()
                    .frame(width: NowPlayingView.imgSizeVal, height: NowPlayingView.imgSizeVal)
                    .padding(EdgeInsets(top: NowPlayingView.imgPaddingVal, leading: NowPlayingView.imgPaddingVal, bottom: NowPlayingView.imgPaddingVal, trailing: NowPlayingView.imgPaddingVal))
                    .foregroundColor(Color(R.color.accent))
                    .background(Color(R.color.bgPrimary))
                    .cornerRadius(8.0)
                VStack(alignment: .leading, spacing: 0, content: {
                    Text(name)
                        .font(.headline).fontWeight(.semibold)
                        .lineLimit(1)
                        .foregroundColor(Color(R.color.primary))
                    if (!sub.isEmpty) {
                        Text(sub)
                            .font(.body).fontWeight(.regular)
                            .lineLimit(1)
                            .foregroundColor(Color(R.color.secondary))
                    }
                })
                .padding(EdgeInsets(top: 0, leading: 8, bottom: 0, trailing: 0))
                Spacer(minLength: 8)
                Button(action: {
                    if (playbackController.playingTrack == nil) {
                        return
                    }
                    if (playbackController.playing) {
                        _ = playbackController.pause()
                        return
                    }
                    _ = playbackController.play()
                }, label: {
                    Image(playing
                          ? R.image.icPause
                          : R.image.icPlay)
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .foregroundColor(Color(R.color.primary))
                })
                .frame(width: 40, height: 48, alignment: .center)
                .contentShape(Rectangle())
                Button(action: {
                    if (playbackController.playingTrack == nil) {
                        return
                    }
                    _ = playbackController.playNextTrack()
                }, label: {
                    Image(R.image.icFastForward)
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .foregroundColor(Color(R.color.primary))
                })
                .frame(width: 44, height: 48, alignment: .center)
                .contentShape(Rectangle())
            })
            .padding(EdgeInsets(top: NowPlayingView.containerVPaddingVal, leading: NowPlayingView.containerVPaddingVal * 2, bottom: NowPlayingView.containerVPaddingVal, trailing: 0))
            .background(Color(R.color.bgSecondary))
            .onReceive(NotificationCenter.default.publisher(for: .SPPlayItemUpdate), perform: { notification in
                let parseRes = notification.tryParsePlayItemUpdate()
                if (!parseRes.0) {
                    return
                }
                trackName = parseRes.1?.trackMeta.name ?? ""
                artists = parseRes.1?.trackMeta.artists.map({ artist in
                    return artist.name
                }) ?? []
            })
            .onReceive(NotificationCenter.default.publisher(for: .SPPlayStateUpdate), perform: { notification in
                let parseRes = notification.tryParsePlayStateUpdate()
                guard let safeStateVal = parseRes.1, parseRes.0 else {return}
                playing = safeStateVal
            })
        })
        .sheet(isPresented: $_sheetShow, onDismiss: {
            _sheetShow = false
        }, content: {
            PlayerScreen(trackName: $trackName, artists: $artists, playing: $playing)
        })
    }
}

#Preview {
    NowPlayingView()
        .environmentObject(previewPlayController)
}
