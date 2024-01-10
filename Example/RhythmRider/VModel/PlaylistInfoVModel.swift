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
    
    fileprivate(set) var tracks: ItemsVModel<SPMetadataTrack>
    
    var orderedUrisSeqHash: Int {
        get {
            return PlaybackController.calculatePlaySeqHash(tracks.orderedUris)
        }
    }
    
    var orderedPlaybackSeq: [PlaybackTrack] {
        get {
            var res: [PlaybackTrack] = []
            for uri in tracks.orderedUris {
                guard let meta = tracks.details[uri] else {continue}
                res.append(PlaybackTrack(uri: uri, trackMeta: meta))
            }
            return res
        }
    }
    
    init(id: String, name: String, desc: String, orderedTrackUris: [String] = [], tracksDetails: [String: SPMetadataTrack] = [:]) {
        self.id = id
        self.name = name
        self.desc = desc
        tracks = ItemsVModel(orderedUris: orderedTrackUris, details: tracksDetails)
    }
}
