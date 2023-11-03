//
//  SPID.swift
//  SwiftySpot
//
//  Created by developer on 01.11.2023.
//

///Spotify ID object
public class SPID: SPBaseObj, Equatable, Hashable {
    
    public static let idSize: UInt8 = 22
    public static let gidSize: UInt8 = 16
    
    ///Spotify global ID (gid) - UInt128 number (16 bytes)
    public let globalID: [UInt8]
    ///Spotify navigate uri ID - Base62(gid) (22 chars)
    public let id: String
    
    public init(id: String, globalID: [UInt8]) {
        self.id = id
        self.globalID = globalID
    }
    
    public init(id: String) {
        self.id = id
        if (id.count != SPID.idSize) {
            globalID = []
            return
        }
        let num = SPBase62.decode(string: id, inversedAlphabet: true)
        var seq = BitConvertUtil.getBytes(num.high)
        seq.append(contentsOf: BitConvertUtil.getBytes(num.low))
        globalID = seq
    }
    
    public init(globalID: [UInt8]) {
        self.globalID = globalID
        if (globalID.count != SPID.gidSize) {
            id = ""
            return
        }
        guard let low: UInt64 = BitConvertUtil.getVal(globalID) else {
            id = ""
            return
        }
        guard let high: UInt64 = BitConvertUtil.getVal(globalID, offset: 8) else {
            id = ""
            return
        }
        let num = UInt128(high: high, low: low)
        let seq = SPBase62.encode(num: num, inversedAlphabet: true)
        id = seq
    }
    
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
        hasher.combine(globalID)
    }
    
    public static func ==(lhs: SPID, rhs: SPID) -> Bool {
        let cmpRes = lhs.id == rhs.id && lhs.globalID == rhs.globalID
        if let typedLhs = lhs as? SPTypedObj, let typedRhs = rhs as? SPTypedObj {
            //Weird inherited child classes work: set<SPTypedObj>.contains() sometimes produces only SPID '==' call without SPTypedObj '=='
            return cmpRes && typedLhs.entityType == typedRhs.entityType
        }
        return cmpRes
    }
}
