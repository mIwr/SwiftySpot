//
//  SPLyricsSyncType.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2023.
//

public enum SPLyricsSyncType: Int8 {
    case unsynced = 0
    case lineSynced = 1
    case syllabledSynced = 2
}

extension SPLyricsSyncType {
    
    fileprivate static let _unsyncedJsonKey = "UNSYNCED"
    fileprivate static let _lineSyncedJsonKey = "LINE_SYNCED"
    fileprivate static let _syllableSyncedJsonKey = "SYLLABLE_SYNCED"
    
    static func from(protobuf: Com_Spotify_Lyrics_Endpointretrofit_Proto_SyncType) -> SPLyricsSyncType {
        switch(protobuf) {
        case .unsynced: return .unsynced
        case .lineSynced: return .lineSynced
        case .syllableSynced: return .syllabledSynced
        case .UNRECOGNIZED(let rawVal):
            #if DEBUG
            print("Unknown lyrics sync type with ID " + String(rawVal))
            #endif
            return .unsynced
        }
    }
    
    static func from(jsonKey: String) -> SPLyricsSyncType? {
        switch(jsonKey) {
        case _unsyncedJsonKey: return .unsynced
        case _lineSyncedJsonKey: return .lineSynced
        case _syllableSyncedJsonKey: return .syllabledSynced
        default: return nil
        }
    }
}
