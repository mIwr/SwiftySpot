//
//  PlaylistTracksVModel.swift
//  RhythmRider
//
//  Created by developer on 20.10.2023.
//

import Foundation
import SwiftySpot

class PlaylistInfoVModel {
    let id: String
    var uri: String {
        get {
            return SPNavigateUriUtil.generatePlaylistUri(id: id)
        }
    }
    let name: String
    let desc: String
    
    fileprivate(set) var orderedTrackUris: [String]
    var orderedUrisSeqHash: Int {
        get {
            return PlaybackController.calculatePlaySeqHash(orderedTrackUris)
        }
    }
    fileprivate(set) var tracksDetails: [String: SPMetadataTrack]
    
    var orderedPlaybackSeq: [PlaybackTrack] {
        get {
            var res: [PlaybackTrack] = []
            for uri in orderedTrackUris {
                guard let meta = tracksDetails[uri] else {continue}
                res.append(PlaybackTrack(uri: uri, trackMeta: meta))
            }
            return res
        }
    }
    
    var noInfoTracks: Set<String> {
        get {
            var set = Set<String>()
            for uri in orderedTrackUris {
                if (tracksDetails.contains(where: { (k,v) in
                    return uri == k
                })) {
                    continue
                }
                set.insert(uri)
            }
            return set
        }
    }
    
    var orderedNoInfoTracks: [String] {
        var res: [String] = []
        for uri in orderedTrackUris {
            if (tracksDetails.contains(where: { (k,v) in
                uri == k
            })) {
                continue
            }
            res.append(uri)
        }
        return res
    }
    
    init(id: String, name: String, desc: String) {
        self.id = id
        self.name = name
        self.desc = desc
        orderedTrackUris = []
        tracksDetails = [:]
    }
    
    init(id: String, name: String, desc: String, orderedTrackUris: [String], tracksDetails: [String: SPMetadataTrack]) {
        self.id = id
        self.name = name
        self.desc = desc
        self.orderedTrackUris = orderedTrackUris
        self.tracksDetails = tracksDetails
    }
    
    func setUris(_ orderedUris: [String]) {
        orderedTrackUris = orderedUris
    }
    
    func appendUris(_ orderedUris: [String]) {
        orderedTrackUris.append(contentsOf: orderedUris)
    }
    
    func updateTrackDetails(_ details: [String: SPMetadataTrack]) {
        for entry in details {
            tracksDetails[entry.key] = entry.value
        }
    }
    
    func resetTrackDetails() {
        tracksDetails.removeAll()
    }
    
    func resetSeq() {
        orderedTrackUris = []
        resetTrackDetails()
    }
}
