//
//  SPCollectionEntry.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

import Foundation

///Universal collection item
public class SPCollectionItem: SPTypedObj {
    
    ///Item create timestamp
    public let addedTs: Int64
    ///Item create date
    public var addedDt: Date {
        get {
            let dt = Date(timeIntervalSince1970: TimeInterval(addedTs))
            return dt
        }
    }
    ///Item was removed from collection flag
    public let removed: Bool
    
    public init(uri: String, addedTs: Int64, removed: Bool) {
        self.addedTs = addedTs
        self.removed = removed
        super.init(uri: uri)
    }
    
    static func from(protobuf: Com_Spotify_Collection2_V2_Proto_CollectionItem) -> SPCollectionItem {
        return SPCollectionItem(uri: protobuf.uri, addedTs: protobuf.addedAtTs, removed: protobuf.isRemoved)
    }
}

public func ==(lhs: SPCollectionItem, rhs: SPCollectionItem) -> Bool {
    return lhs.uri == rhs.uri
}
