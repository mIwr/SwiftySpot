//
//  PlaylistArrVModel.swift
//  RhythmRider
//
//  Created by Developer on 16.10.2023.
//

import Foundation
import SwiftySpot

class LandingPlaylistArrVModel {
    
    fileprivate(set) var userMixes: [SPLandingPlaylist]
    fileprivate(set) var radioMixes: [SPLandingPlaylist]
    fileprivate(set) var otherPlaylists: [SPLandingPlaylist]
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
        userMixes = []
        radioMixes = []
        otherPlaylists = []
        updSeqTsUTC = 0
    }
    
    func setLanding(_ landing: SPLandingData) {
        userMixes = landing.userMixes
        radioMixes = landing.radioMixes
        otherPlaylists = landing.playlists
        updSeqTsUTC = Int64(Date().timeIntervalSince1970)
    }
    
    func reset() {
        userMixes.removeAll()
        radioMixes.removeAll()
        otherPlaylists.removeAll()
        updSeqTsUTC = 0
    }
}
