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
    var orderedTrackUris: [String]
    var orderedUrisSeqHash: Int {
        get {
            return PlaybackController.calculatePlaySeqHash(orderedTrackUris)
        }
    }
    var tracksDetails: [String: SPMetadataTrack]
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
    
    init(id: String, name: String, desc: String, orderedTrackUris: [String], tracksDetails: [String: SPMetadataTrack]) {
        self.id = id
        self.name = name
        self.desc = desc
        self.orderedTrackUris = orderedTrackUris
        self.tracksDetails = tracksDetails
    }
}
