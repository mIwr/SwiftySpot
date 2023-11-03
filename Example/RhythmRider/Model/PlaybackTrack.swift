//
//  PlaybackTrack.swift
//  RhythmRider
//
//  Created by developer on 25.10.2023.
//

import SwiftySpot

class PlaybackTrack {
    let uri: String
    let trackMeta: SPMetadataTrack
    
    init(uri: String, trackMeta: SPMetadataTrack) {
        self.uri = uri
        self.trackMeta = trackMeta
    }
}
