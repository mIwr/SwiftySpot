//
//  SPPlaylistDto.swift
//  SwiftySpot
//
//  Created by Developer on 16.09.2023.
//

///Landing playlist object
public class SPLandingPlaylist: SPBaseObj {
    
    ///Playlist title
    public let name: String
    ///Playlist subtitle
    public let subtitle: String
    ///Playlist navigation uri
    public let uri: String
    ///Playlist navigation ID
    public var id: String {
        get {
            let split = uri.split(separator: ":")
            return String(split[split.count - 1])
        }
    }
    ///Playlist image cover
    public let image: String

    public init(name: String, subtitle: String, uri: String, image: String) {
        self.name = name
        self.subtitle = subtitle
        self.uri = uri
        self.image = image
    }
}
