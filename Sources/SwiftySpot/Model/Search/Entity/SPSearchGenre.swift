//
//  SPSearchGenre.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Genre search match
public class SPSearchGenre {
    
    static func from(protobuf: Com_Spotify_Searchview_Proto_Genre) -> SPSearchGenre {
        return SPSearchGenre()
    }
}
