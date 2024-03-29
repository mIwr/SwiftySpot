//
//  SPTypedObj.swift
//  SwiftySpot
//
//  Created by developer on 01.11.2023.
//


///Spotify typed base object
public class SPTypedObj: SPID {
    
    ///Spotify navigation uri
    public let uri: String
    ///Spotify object type
    public let entityType: SPEntityType
    
    public init(uri: String) {
        self.uri = uri
        let pair = SPEntityType.examineUri(uri)
        self.entityType = pair.0
        super.init(id: pair.1)
    }
    
    public init(uri: String, globalID: [UInt8]) {
        self.uri = uri
        let pair = SPEntityType.examineUri(uri)
        self.entityType = pair.0
        super.init(id: pair.1, globalID: globalID)
    }
    
    public init(id: String, entityType: SPEntityType) {
        self.entityType = entityType
        self.uri = entityType.uriPrefix + id
        super.init(id: id)
    }
    
    public init(globalID: [UInt8], type: SPEntityType) {
        self.entityType = type
        let spid = SPID(globalID: globalID)
        self.uri = type.uriPrefix + spid.id
        super.init(id: spid.id, globalID: globalID)
    }
    
    public override func hash(into hasher: inout Hasher) {
        super.hash(into: &hasher)
        hasher.combine(entityType)
    }
}
