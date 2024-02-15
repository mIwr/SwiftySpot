//
//  SPLandingDto.swift
//  SwiftySpot
//
//  Created by Developer on 16.09.2023.
//

///Parsed landing data
public class SPLandingData {
    
    ///Recognized generated playlists for user-only (Daily mixes, Release Radar)
    public let userMixes: [SPLandingPlaylist]
    
    ///Recognized 'radio' playlists
    public let radioMixes: [SPLandingPlaylist]
    
    ///Recognized other playlsits
    public let playlists: [SPLandingPlaylist]
    
    public init(userMixes: [SPLandingPlaylist], radioMixes: [SPLandingPlaylist], playlists: [SPLandingPlaylist]) {
        self.userMixes = userMixes
        self.radioMixes = radioMixes
        self.playlists = playlists
    }
}
