//
//  PlaybackProgressView.swift
//  RhythmRider
//
//  Created by developer on 17.11.2023.
//

import SwiftUI
import SwiftySpot

struct PlaybackProgressView: View {
    @EnvironmentObject var playController: PlaybackController
    
    @State var durationInMs: TimeInterval
    @State var dragginSlider: Bool
    @State var playbackPositionInS: TimeInterval
    
    init() {
        _durationInMs = State(initialValue: 0.0)
        _dragginSlider = State(initialValue: false)
        _playbackPositionInS = State(initialValue: 0)
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
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
                Text(SPDateUtil.formattedTrackTime(playbackPositionInS))
                    .font(.caption).fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundColor(Color(R.color.secondary))
                Spacer(minLength: 16)
                Text(SPDateUtil.formattedTrackTime(durationInMs / 1000))
                    .font(.caption).fontWeight(.semibold)
                    .lineLimit(1)
                    .foregroundColor(Color(R.color.secondary))
            })
        }
        .onAppear(perform: {
            playbackPositionInS = playController.playbackPositionInS
            guard let safePlayingTrack = playController.playingTrack else {return}
            durationInMs = TimeInterval(safePlayingTrack.trackMeta.durationInMs)
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
            durationInMs = newDurationInMs
            playbackPositionInS = 0
        })
    }
}

#Preview {
    PlaybackProgressView()
        .environmentObject(previewPlayController)
}
