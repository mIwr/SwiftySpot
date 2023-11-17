//
//  TrackLyricsScreen.swift
//  RhythmRider
//
//  Created by developer on 16.11.2023.
//

import SwiftUI
import SwiftySpot

struct TrackLyricsScreen: View {
    
    @EnvironmentObject var api: ApiController
    
    fileprivate var _trackLyrics: TrackLyricsVModel
    
    @State fileprivate var _loaded: Bool? = nil
    @State fileprivate var _errMsg: String = ""
    @Binding var presented: Bool
    
    init(track: SPMetadataTrack, presented: Binding<Bool>) {
        self._trackLyrics = TrackLyricsVModel(track: track)
        _presented = presented
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            if (_loaded == nil) {
                LoadingView()
            } else if (_loaded == false) {
                ErrorView(title: R.string.localizable.trackLyricsLoadError(), subtitle: _errMsg, refreshAction: nil)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            } else {
                ScrollView(.vertical, showsIndicators: false) {
                    LazyVStack(alignment: .leading, spacing: 8) {
                        ForEach(_trackLyrics.lyrics?.content ?? [], id: \.startTimeMs) { lyricsLine in
                            Text(lyricsLine.syncedFormattedText)
                                .font(.body)
                                .foregroundColor(Color(R.color.primary))
                        }
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(EdgeInsets(top: 16, leading: 0, bottom: Constants.defaultButtonHeight + 16, trailing: 0))
                }
            }
            Button(action: {
                presented = false
            }, label: {
                Text(R.string.localizable.generalClose())
                    .font(.headline)
                    .foregroundColor(Color(R.color.primary))
            })
            .buttonStyle(AccentWideButtonStyle())
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
        .onAppear(perform: {
            if let safeLyrics = api.client.lyricsStorage.find(uri: _trackLyrics.track.uri) {
                _trackLyrics.lyrics = safeLyrics
                _loaded = true
                return
            }
            
            #if DEBUG
            if (ProcessInfo.processInfo.previewMode) {
                //Disable real API requests
                DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                    let dummyLyrics = SPLyrics(target: _trackLyrics.track, colorData: SPLyricsColorData(bg: 0, text: 0, highlightText: 0), vocalRemoval: false, vocalRemovalColorData: nil, syncType: .lineSynced, content: [
                        SPLyricsLine(startTimeMs: 0, text: "Some text", syllables: []),
                        SPLyricsLine(startTimeMs: 561, text: "Some text line 2", syllables: []),
                        SPLyricsLine(startTimeMs: 1245, text: "Some text line 3", syllables: []),
                        SPLyricsLine(startTimeMs: 3245, text: "Some text line 4", syllables: []),
                        SPLyricsLine(startTimeMs: 123789, text: "Some text line 5", syllables: []),
                    ], provider: "", providerID: "", providerDisplayName: "", syncLyricsUri: "", alternatives: [], lang: "", rtlLang: false, showUpsell: false)
                    _trackLyrics.lyrics = dummyLyrics
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
        return await withCheckedContinuation { continuation in
            api.client.getTrackLyrics(_trackLyrics.track.id) { result in
                switch result {
                    case .success(let lyrics):
                    guard let safeLyrics = lyrics else {
                        continuation.resume(returning: false)
                        return
                    }
                    _trackLyrics.lyrics = safeLyrics
                    continuation.resume(returning: true)
                    return
                    case .failure(let err):
                    _errMsg = err.errorDescription
                    continuation.resume(returning: false)
                    return
                }
            }
        }
    }
}

#Preview {
    @StateObject var api = ApiController(previewApiClient)
    @State var shown = true
    let trackInfo = SPMetadataTrack(gid: [], name: "Track name")
    return TrackLyricsScreen(track: trackInfo, presented: $shown)
        .environmentObject(api)
}
