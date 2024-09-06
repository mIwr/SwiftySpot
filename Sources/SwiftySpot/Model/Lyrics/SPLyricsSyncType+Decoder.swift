//
//  SPLyricsSyncType.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2023.
//

extension SPLyricsSyncType {
    
    fileprivate static let _unsyncedJsonKey = "UNSYNCED"
    fileprivate static let _lineSyncedJsonKey = "LINE_SYNCED"
    fileprivate static let _syllableSyncedJsonKey = "SYLLABLE_SYNCED"
    
    static func from(jsonKey: String) -> SPLyricsSyncType? {
        switch(jsonKey) {
        case _unsyncedJsonKey: return .unsynced
        case _lineSyncedJsonKey: return .lineSynced
        case _syllableSyncedJsonKey: return .syllableSynced
        default: return nil
        }
    }
}
