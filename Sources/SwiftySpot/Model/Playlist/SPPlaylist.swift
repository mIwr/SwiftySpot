//
//  SPPlaylist.swift
//  SwiftySpot
//
//  Created by Developer on 18.09.2023.
//

import Foundation

///Playlist full info
public class SPPlaylist: SPTypedObj {
    ///Playlist title
    public let name: String
    ///Playlist subtitle
    public let desc: String
    ///Tracks short info
    public let tracks: [SPPlaylistTrack]
    ///Playlist cover images by sizes
    public let images: [String: String]
    ///Playlist small cover. Usually 160x160 px
    public var smallImg: String? {
        return images["small"]
    }
    ///Playlist default cover. Usually 320x320 px
    public var defaultImg: String? {
        return images["default"]
    }
    ///Playlist default cover. Usually 640x640 px
    public var largeImg: String? {
        return images["large"]
    }
    ///Playlist default cover. Usually 1280x1280 px
    public var xlargeImg: String? {
        return images["xlarge"]
    }
    public let additional: [String: String]
    
    public init(id: String, name: String, desc: String, tracks: [SPPlaylistTrack], images: [String : String] = [:], additional: [String : String] = [:]) {
        self.name = name
        self.desc = desc
        self.tracks = tracks
        self.images = images
        self.additional = additional
        super.init(id: id, entityType: .playlist)
    }
}
