//
//  File.swift
//  SwiftySpot
//
//  Created by Developer on 18.09.2023.
//

import Foundation

///Playlist track short info
public class SPPlaylistTrack: SPTypedObj {
    
    ///Track publish timestamp
    public let createTsMsUTC: Int64?
    ///Track properties
    public let props: [String: String]
    ///Artist navigation uri
    public var artistUri: String? {
        return props["reason_artist"]
    }
    ///Artist ID
    public var artistId: SPTypedObj? {
        guard let safeUri = artistUri else {return nil}
        let obj = SPTypedObj(uri: safeUri)
        if (obj.entityType != .artist) {
            return nil
        }
        return obj
    }
    
    public init(uri: String, createTsMsUTC: Int64? = nil, props: [String : String]) {
        self.createTsMsUTC = createTsMsUTC
        self.props = props
        super.init(uri: uri)
    }
}
