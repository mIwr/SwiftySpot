//
//  PlaylistArrVModel.swift
//  RhythmRider
//
//  Created by Developer on 16.10.2023.
//

import Foundation
import SwiftySpot

class LandingPlaylistArrVModel {
    
    fileprivate(set) var orderedValues: [SPLandingPlaylist]
    fileprivate(set) var updSeqTsUTC: Int64
    var mayRefresh: Bool {
        get {
            let nowDt = Date()
            let delta = Int64(nowDt.timeIntervalSince1970) - updSeqTsUTC
            let updDt = Date(timeIntervalSince1970: TimeInterval(updSeqTsUTC))
            let updDay = Calendar.current.dateComponents([.day], from: updDt).day ?? 1
            let nowDay = Calendar.current.dateComponents([.day], from: nowDt).day ?? 1
            return delta >= 86400 || updDay != nowDay
        }
    }
    
    init() {
        orderedValues = []
        updSeqTsUTC = 0
    }
    
    func setLandingPlaylists(_ orderedPlaylists: [SPLandingPlaylist]) {
        orderedValues = orderedPlaylists
        updSeqTsUTC = Int64(Date().timeIntervalSince1970)
    }
    
    func reset() {
        orderedValues.removeAll()
        updSeqTsUTC = 0
    }
}
