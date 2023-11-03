//
//  FavStorageVModel.swift
//  RhythmRider
//
//  Created by developer on 02.11.2023.
//

import Foundation
import SwiftySpot

class FavStorageVModel: ObservableObject {
    
    @Published fileprivate(set) var orderedPlayUris: [String]
    fileprivate(set) var details: [String: SPMetadataTrack]
    var playSeq: [PlaybackTrack] {
        get {
            var res: [PlaybackTrack] = []
            for uri in orderedPlayUris {
                guard let meta = details[uri] else {continue}
                res.append(PlaybackTrack(uri: uri, trackMeta: meta))
            }
            return res
        }
    }
    var playSeqHash: Int {
        get {
            return PlaybackController.calculatePlaySeqHash(orderedPlayUris)
        }
    }
    
    var noDetailsUris: Set<String> {
        get {
            var set = Set<String>()
            for uri in orderedPlayUris {
                if (details.contains(where: { (k,v) in
                    return uri == k
                })) {
                    continue
                }
                set.insert(uri)
            }
            return set
        }
    }
    
    var orderedNoDetailsUris: [String] {
        var res: [String] = []
        for uri in orderedPlayUris {
            if (details.contains(where: { (k,v) in
                uri == k
            })) {
                continue
            }
            res.append(uri)
        }
        return res
    }
    
    init() {
        orderedPlayUris = []
        details = [:]
    }
    
    func setLikesData(orderedLikedUris: [String]) {
        orderedPlayUris = orderedLikedUris
    }
    
    func updateMeta(_ meta: [String: SPMetadataTrack]) {
        for entry in meta {
            details[entry.key] = entry.value
        }
    }
    
    func applyOnTrackLikeUpdate(collectionItem: SPCollectionItem, meta: SPMetadataTrack?) {
        if (collectionItem.removed) {
            if (orderedPlayUris.isEmpty) {
                return
            }
            //Remove item from collection
            for i in 0...orderedPlayUris.count - 1 {
                if (orderedPlayUris[i] != collectionItem.uri) {
                    continue
                }
                orderedPlayUris.remove(at: i)
                return
            }
            return
        }
        if let safeMeta = meta {
            details[collectionItem.uri] = safeMeta
        }
        if (orderedPlayUris.isEmpty) {
            orderedPlayUris.insert(collectionItem.uri, at: 0)
            return
        }
        var found = false
        for i in 0...orderedPlayUris.count - 1 {
            if (orderedPlayUris[i] != collectionItem.uri) {
                continue
            }
            found = true
            break
        }
        if (found) {
            return
        }
        orderedPlayUris.insert(collectionItem.uri, at: 0)
    }
    
    func reset() {
        orderedPlayUris.removeAll()
    }
}
