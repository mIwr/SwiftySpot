//
//  ISPID.swift
//  SwiftySpot
//
//  Created by developer on 08.08.2024.
//

///Spotify ID object protocol
public protocol ISPID: Equatable, Hashable, ISPObj {
    
    ///Spotify global ID (gid) - UInt128 number (16 bytes)
    var globalID: [UInt8] {get}
    ///Spotify navigate uri ID - Base62(gid) (22 chars)
    var id: String {get}
    ///Spotify global ID (gid) hex string (Base16)
    var hexGlobalID: String {get}
}
