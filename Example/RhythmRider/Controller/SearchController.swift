//
//  SearchController.swift
//  RhythmRider
//
//  Created by developer on 02.11.2023.
//

import Foundation
import SwiftySpot

class SearchController: ObservableObject {
    
    fileprivate let _pageLimit: UInt
    fileprivate var _pageToken: String?
    fileprivate(set) var searchQuery: String
    fileprivate(set) var searchEntityTypes: [SPSearchEntityType]
    @Published fileprivate(set) var suggestions: [SPSearchAutocompleteQuery]
    @Published fileprivate(set) var results: [SPSearchEntity]
    @Published fileprivate(set) var playSeq: [PlaybackTrack]
    fileprivate(set) var playSeqHash: Int
    fileprivate(set) var seqPlayable: Bool
    
    var orderedPlaySeqUris: [String] {
        get {
            var uris: [String] = []
            for hit in results {
                guard let _ = hit.track else {continue}
                uris.append(hit.uri)
            }
            return uris
        }
    }
    
    init(pageLimit: UInt) {
        _pageLimit = pageLimit
        searchQuery = ""
        _pageToken = nil
        searchEntityTypes = []
        _pageToken = nil
        suggestions = []
        results = []
        playSeq = []
        playSeqHash = 0
        seqPlayable = false
    }
    
    func search(query: String, searchTypes: [SPSearchEntityType], pageToken: String?, api: SPClient) async -> SPSearchResult? {
        if (searchQuery == query && searchTypes == searchEntityTypes && (pageToken == nil || pageToken?.isEmpty == true)) {
            return nil
        }
        searchQuery = query
        searchEntityTypes = searchTypes
        return await withCheckedContinuation { continuation in
            api.search(query: searchQuery, entityTypes: searchTypes, limit: _pageLimit, pageToken: _pageToken) { result in
                do {
                    let searchRes = try result.get()
                    DispatchQueue.main.async {
                        if (self.searchQuery != query || self.searchEntityTypes != searchTypes) {
                            self.results = searchRes.hits
                            self.suggestions = searchRes.autocomplete
                            self.playSeq = self.generatePlaySeq(from: searchRes.hits)
                            self.seqPlayable = false
                        } else {
                            self.results.append(contentsOf: searchRes.hits)
                            self.suggestions.append(contentsOf: searchRes.autocomplete)
                            self.playSeq.append(contentsOf: self.generatePlaySeq(from: searchRes.hits))
                        }
                        self.playSeqHash = PlaybackController.calculatePlaySeqHash(self.orderedPlaySeqUris)
                        if (pageToken != nil && pageToken?.isEmpty == false) {
                            self.seqPlayable = false
                            Task {
                                await self.makeSeqPlayable(api: api)
                            }
                        }
                        self._pageToken = searchRes.nextPageToken
                    }
                    continuation.resume(returning: searchRes)
                } catch {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    func searchSuggestion(query: String, searchTypes: [SPSearchEntityType], api: SPClient) async -> SPSearchSuggestionResult? {
        if (searchQuery == query && searchTypes == searchEntityTypes) {
            return nil
        }
        _pageToken = nil
        searchQuery = query
        searchEntityTypes = searchTypes
        return await withCheckedContinuation { continuation in
            api.searchSuggestion(query: searchQuery, entityTypes: searchTypes, limit: _pageLimit) { result in
                do {
                    let searchRes = try result.get()
                    //No page tokens -> always new collection
                    DispatchQueue.main.async {
                        self.results = searchRes.hits
                        self.suggestions = searchRes.autocomplete
                        self.playSeq = self.generatePlaySeq(from: searchRes.hits)
                        self.playSeqHash = PlaybackController.calculatePlaySeqHash(self.orderedPlaySeqUris)
                        continuation.resume(returning: searchRes)
                    }
                    self.seqPlayable = false
                } catch {
                    continuation.resume(returning: nil)
                }
            }
        }
    }
    
    #if DEBUG
    func update(query: String, hits: [SPSearchEntity], suggestions: [SPSearchAutocompleteQuery]) {
        searchQuery = query
        results = hits
        self.suggestions = suggestions
        playSeq = generatePlaySeq(from: hits)
        seqPlayable = false
        playSeqHash = PlaybackController.calculatePlaySeqHash(self.orderedPlaySeqUris)
        _pageToken = nil
    }
    #endif
    
    ///Sync generated play seq with local and remote meta storage
    func makeSeqPlayable(api: SPClient) async {
        if (seqPlayable) {
            return
        }
        let ordered = orderedPlaySeqUris
        let urisSet = Set<String>(ordered)
        let playable = api.metaStorage.findTracks(uris: urisSet)
        var notFoundUris: [String] = []
        for uri in ordered {
            if (playable.contains(where: { (k,v) in
                return k == uri
            })) {
                continue
            }
            notFoundUris.append(uri)
        }
        if (notFoundUris.isEmpty) {
            var res: [PlaybackTrack] = []
            for uri in ordered {
                guard let safeMeta = playable[uri] else {continue}
                res.append(PlaybackTrack(uri: uri, trackMeta: safeMeta))
            }
            let seq = res//Swift 6 syntax complying
            DispatchQueue.main.async {
                self.playSeq = seq
            }
            seqPlayable = true
            return
        }
        //Load meta
        await withCheckedContinuation { continuation in
            api.getTracksDetails(trackUris: notFoundUris) { result in
                do {
                    let metaRes = try result.get()
                    var res: [PlaybackTrack] = []
                    for uri in ordered {
                        if let safeLocalMeta = playable[uri] {
                            res.append(PlaybackTrack(uri: uri, trackMeta: safeLocalMeta))
                            continue
                        }
                        if let safeRemoteMeta = metaRes[uri] {
                            res.append(PlaybackTrack(uri: uri, trackMeta: safeRemoteMeta))
                        }
                    }
                    let seq = res//Swift 6 syntax complying
                    DispatchQueue.main.async {
                        self.playSeq = seq
                    }
                } catch {}
                continuation.resume()
            }
        }
        seqPlayable = true
    }
    
    func reset() {
        searchQuery = ""
        searchEntityTypes = []
        _pageToken = nil
        suggestions.removeAll()
        results.removeAll()
        playSeq = []
        playSeqHash = 0
        seqPlayable = false
    }
    
    ///Generates not playable (no info about files and duration) seq only for displaying track results
    fileprivate func generatePlaySeq(from hits: [SPSearchEntity]) -> [PlaybackTrack] {
        var res: [PlaybackTrack] = []
        for hit in hits {
            guard let safeTrackMeta = hit.generatedTrackMeta else {continue}
            res.append(PlaybackTrack(uri: hit.uri, trackMeta: safeTrackMeta))
        }
        return res
    }
}
