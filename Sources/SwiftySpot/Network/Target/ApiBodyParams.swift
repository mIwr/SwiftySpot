//
//  ApiFuncParams.swift
//  SwiftySpot
//
//  Created by Developer on 06.09.2023.
//
extension ApiTarget {
    
    fileprivate static let _emptyDict: [String: Any] = [:]
    
    var parameters: [String: Any] {
        switch self {
        case .download: return ApiTarget._emptyDict
        case .clToken: return ApiTarget._emptyDict
        case .acessPoints: return ApiTarget._emptyDict
        case .auth: return ApiTarget._emptyDict
        case .profile: return ApiTarget._emptyDict
        case .landing: return ApiTarget._emptyDict
        case .artist: return ApiTarget._emptyDict
        case .artistUI: return ApiTarget._emptyDict
        case .playlist: return ApiTarget._emptyDict
        case .metadata: return ApiTarget._emptyDict
        case .collection: return ApiTarget._emptyDict
        case .collectionDelta: return ApiTarget._emptyDict
        case .collectionWrite: return ApiTarget._emptyDict
        case .searchSuggestion: return ApiTarget._emptyDict
        case .search: return ApiTarget._emptyDict
        case .playIntent: return ApiTarget._emptyDict
        case .downloadInfo: return ApiTarget._emptyDict
        }
    }
}
