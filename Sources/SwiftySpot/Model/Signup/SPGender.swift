//
//  SPGender.swift
//  SwiftySpot
//
//  Created by developer on 10.11.2023.
//

public enum SPGender: UInt8 {
    case unknown = 0
    case male = 1
    case female = 2
    case nonBinary = 3
}

extension SPGender {
    var protoEnum: Com_Spotify_Signup_V2_Proto_UserGender {
        switch(self) {
        case .unknown: return .unknownUserGender
        case .male: return .male
        case .female: return .female
        case .nonBinary: return .nonBinary
        }
    }
    
    static func from(protobuf: Com_Spotify_Signup_V2_Proto_UserGender) -> SPGender {
        switch (protobuf) {
        case .unknownUserGender: return .unknown
        case .male: return .male
        case .female: return .female
        case .nonBinary: return .nonBinary
        
        case .UNRECOGNIZED:
            #if DEBUG
            print("Unknown user gender " + String(protobuf.rawValue))
            #endif
            return .unknown
        }
    }
}
