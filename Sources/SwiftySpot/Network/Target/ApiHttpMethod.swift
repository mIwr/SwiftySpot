//
//  ApiHttpMethod.swift
//  SwiftySpot
//
//  Created by Developer on 06.09.2023.
//
extension ApiTarget {
    
    fileprivate static let _getMethod = "GET"
    fileprivate static let _postMethod = "POST"
    
    var method: String {
        switch self {
        case .download: return ApiTarget._getMethod
        case .clToken: return ApiTarget._postMethod
        case .acessPoints: return ApiTarget._getMethod
        case .auth: return ApiTarget._postMethod
        case .profile: return ApiTarget._getMethod
        case .landing: return ApiTarget._postMethod
        case .artist: return ApiTarget._getMethod
        case .artistUI: return ApiTarget._getMethod
        case .playlist: return ApiTarget._getMethod
        case .metadata: return ApiTarget._postMethod
        case .collection: return ApiTarget._postMethod
        case .collectionDelta: return ApiTarget._postMethod
        case .collectionWrite: return ApiTarget._postMethod
        case .searchSuggestion: return ApiTarget._getMethod
        case .search: return ApiTarget._getMethod
        case .playIntent: return ApiTarget._postMethod
        case .downloadInfo: return ApiTarget._getMethod
        }
    }
}
