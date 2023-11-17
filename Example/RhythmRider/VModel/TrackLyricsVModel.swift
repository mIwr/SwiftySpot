//
//  TrackLyricsVModel.swift
//  RhythmRider
//
//  Created by developer on 16.11.2023.
//

import SwiftySpot

class TrackLyricsVModel {
    
    let track: SPMetadataTrack
    var lyrics: SPLyrics?
    
    init(track: SPMetadataTrack, lyrics: SPLyrics? = nil) {
        self.track = track
        self.lyrics = lyrics
    }
}
