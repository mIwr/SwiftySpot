//
//  SPMetadataCopyrightType.swift
//  SwiftySpot
//
//  Created by Developer on 21.09.2023.
//

///Meta copyright type
public enum SPMetadataCopyrightType: Int32 {
    case P = 0
    case C = 1
}

extension SPMetadataCopyrightType {
    static func from(protobuf: Spotify_Metadata_CopyrightType) -> SPMetadataCopyrightType {
        switch (protobuf) {
        case .p: return .P
        case .c: return .C
        
        case .UNRECOGNIZED:
            #if DEBUG
            print("Unknown copyright type " + String(protobuf.rawValue))
            #endif
            return .P
        }
    }
}
