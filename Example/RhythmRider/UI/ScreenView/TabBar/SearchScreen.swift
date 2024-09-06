//
//  SearchScreen.swift
//  RhythmRider
//
//  Created by developer on 31.10.2023.
//

import SwiftUI
import SwiftySpot

struct SearchScreen: View {
    
    fileprivate static let _defaultSearchLimit: UInt = SPCollectionController.defaultPageSize
    
    @EnvironmentObject var api: ApiController
    @EnvironmentObject var playController: PlaybackController
    
    @State fileprivate var _loaded: Bool?
    @State fileprivate var _errMsg: String
    @State fileprivate var _inputQuery: String
    
    @State fileprivate var _searchDelayTimer: Timer?
    @StateObject fileprivate var _searchController: SearchController
    
    init() {
        __loaded = State(initialValue: true)
        __errMsg = State(initialValue: "")
        __inputQuery = State(initialValue: "")
        __searchDelayTimer = State(initialValue: nil)
        __searchController = StateObject(wrappedValue: SearchController(pageLimit: SearchScreen._defaultSearchLimit))
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 8) {
            HStack {
                Image(R.image.icSearch)
                    .resizable()
                    .frame(width: 20, height: 20, alignment: .center)
                    .foregroundColor(Color(R.color.secondary))
                TextField(R.string.localizable.searchQueryHint(), text: Binding(get: {
                    return _inputQuery
                }, set: { newVal in
                    if (_inputQuery == newVal) {
                        return
                    }
                    if (newVal == "") {
                        _inputQuery = ""
                        _searchController.reset()
                        return
                    }
                    _searchDelayTimer?.invalidate()
                    _inputQuery = newVal
                    _searchDelayTimer = Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { _ in
                        if (_loaded != nil) {
                            _loaded = nil
                        }
                        Task {
                            await self.refreshApiSuggestionSearch()
                        }
                    })
                }))
                .keyboardType(.default)
                .frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading)
                Button(action: {
                    if (_inputQuery == "") {
                        return
                    }
                    _inputQuery = ""
                    _searchController.reset()
                }, label: {
                    Image(R.image.icClose)
                        .resizable()
                        .frame(width: 20, height: 20, alignment: .center)
                        .foregroundColor(Color(R.color.error))
                })
            }
            .padding(EdgeInsets(top: 4, leading: 4, bottom: 4, trailing: 4))
            .overlay(RoundedRectangle(cornerRadius: 6)
                .stroke(Color.gray, lineWidth: 1))
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
            if (_loaded == nil || _loaded == false) {
                LoadingView()
            } else {
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(alignment: .center, spacing: 12, content: {
                        ForEach(_searchController.suggestions, id: \.uri) { suggestion in
                            let query = suggestion.query
                            Button(action: {
                                _loaded = nil
                                _inputQuery = query
                                Task {
                                    await refreshApiSuggestionSearch()
                                }
                            }, label: {
                                Text(query)
                                    .font(.headline).fontWeight(.semibold)
                                    .lineLimit(1)
                                    .foregroundColor(Color(R.color.primary))
                            })
                            .padding(EdgeInsets(top: 4, leading: 12, bottom: 4, trailing: 12))
                            .background(Color(R.color.bgSecondary))
                            .cornerRadius(16)
                        }
                    })
                    .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
                }
                .padding(EdgeInsets(top: 8, leading: 0, bottom: 0, trailing: 0))
                OffsetObservingScrollView(.vertical, showsIndicators: true) { offset, maxExtent in
                    if (offset.y < 50.0) {
                        return
                    }
                    UIApplication.shared.endEditing()
                } content: {
                    if (!_searchController.orderedPlaySeqUris.isEmpty) {
                        VStack(alignment: .center, spacing: 12) {
                            ForEach(0..._searchController.orderedPlaySeqUris.count - 1, id: \.self) {
                                index in
                                let uri = _searchController.orderedPlaySeqUris[index]
                                let onPress: () -> Void = {
    #if DEBUG
                                    print("Track TAP")
                                    if (ProcessInfo.processInfo.previewMode) {
                                        //Disable real play track in preview
                                        return
                                    }
    #endif
                                    UIApplication.shared.endEditing()
                                    let playOp = {
                                        if (playController.playingTrackUri == uri) {
                                            return
                                        }
                                        let playbackHash = playController.playSeqHash
                                        if (_searchController.playSeqHash == playbackHash && !playController.shuffle) {
                                            _ = playController.setPlayingTrackByIndex(index, play: true)
                                            return
                                        }
                                        _ = playController.setPlaybackSeq(_searchController.playSeq, playIndex: index, playNow: true)
                                    }
                                    if (!_searchController.seqPlayable) {
                                        //Loading tracks meta
                                        Task {
                                            await _searchController.makeSeqPlayable(api: api.client)
                                            DispatchQueue.main.async {
                                                playOp()
                                            }
                                        }
                                        return
                                    }
                                    playOp()
                                }
                                let track = _searchController.playSeq[index].trackMeta
                                let artists: [(uri: String, name: String)] = track.artists.map({ artist in
                                    return (uri: artist.uri, name: artist.name)
                                })
                                TrackView(trackUri: uri, title: track.name, img: nil, artists: artists, onPress: onPress, playUri: playController.playingTrackUri)
                                    .id(uri)
                            }
                        }
                        .padding(EdgeInsets(top: 8, leading: 16, bottom: 0, trailing: 16))
                    }
                }
                .onTapGesture {
                    UIApplication.shared.endEditing()
                }
            }
            
        }
        .frame(maxHeight: .infinity, alignment: .top)
    }
    
    fileprivate func refreshApiSuggestionSearch() async {
        if (_inputQuery.isEmpty) {
            DispatchQueue.main.async {
                self._loaded = true
                self._searchController.reset()
            }
            return
        }
#if DEBUG
        //Disable real API requests
        if (ProcessInfo.processInfo.previewMode) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                _searchController.update(query: "autoco", hits: [
                    SPSearchEntity(uri: "sp:123", name: "Track name", imgUri: "", artist: nil, track: SPSearchTrack(explicit: true, windowed: true, album: SPRelatedEntity(uri: "sp:0", name: "Album name"), artists: [
                        SPRelatedEntity(uri: "sp:ar:1", name: "Artist 1"),
                        SPRelatedEntity(uri: "sp:ar:2", name: "Artist 2")
                    ], mogef19: false, lyricsMatch: false, onDemand: nil), album: nil, playlist: nil, genre: nil, show: nil, profile: nil, audiobook: nil, autocomplete: nil, serpMeta: "")
                ], suggestions: [
                    SPSearchAutocompleteQuery(uri: "sp:ato:1", snippet: SPSearchSnippet(segments: [SPSearchSegment(segVal: "autocomplete text 1", match: true)]), chipText: ""),
                    SPSearchAutocompleteQuery(uri: "sp:ato:2", snippet: SPSearchSnippet(segments: [SPSearchSegment(segVal: "autocomplete text 2", match: true)]), chipText: "")
                ])
                _loaded = true
            }
            return
        }
#endif
        let res = await _searchController.searchSuggestion(query: _inputQuery, searchTypes: [.track], api: api.client)
        DispatchQueue.main.async {
            _loaded = res != nil
        }
    }
}

#Preview {
    @StateObject var api: ApiController = ApiController(previewApiClient)
    return SearchScreen()
        .environmentObject(api)
        .environmentObject(previewPlayController)
}
