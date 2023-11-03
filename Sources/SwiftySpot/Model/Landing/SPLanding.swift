//
//  SPLandingDto.swift
//  SwiftySpot
//
//  Created by Developer on 16.09.2023.
//

///Parsed landing data
public class SPLandingData {
    
    ///Recognized playlsits
    public let playlists: [SPLandingPlaylist]
    
    public init(playlists: [SPLandingPlaylist]) {
        self.playlists = playlists
    }
}
