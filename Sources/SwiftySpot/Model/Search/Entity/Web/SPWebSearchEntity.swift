//
//  SPWebSearchEntity.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2024.
//

import Foundation

public class SPWebSearchEntity: SPTypedObj {
    
    ///Entity name
    public let name: String
    ///Entity cover image navigation uri
    public let imgUrl: String
    ///Entity as artist info
    public let artist: SPWebSearchArtist?
    ///Entity as track info
    public let track: SPWebSearchTrack?
    ///Entity as album info
    public let album: SPWebSearchAlbum?
    ///Entity as playlist info
    public let playlist: SPWebSearchPlaylist?
    ///Entity as audio show info
    public let show: SPWebSearchAudioShow?
    ///Entity as profile info
    public let profile: SPWebSearchProfile?
    
    public init(uri: String, name: String, imgUrl: String, artist: SPWebSearchArtist?, track: SPWebSearchTrack?, album: SPWebSearchAlbum?, playlist: SPWebSearchPlaylist?, show: SPWebSearchAudioShow?, profile: SPWebSearchProfile?) {
        self.name = name
        self.imgUrl = imgUrl
        self.artist = artist
        self.track = track
        self.album = album
        self.playlist = playlist
        self.show = show
        self.profile = profile
        super.init(uri: uri)
    }
}
