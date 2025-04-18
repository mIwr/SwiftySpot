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
        case .wdvSeektable: return ApiTarget._getMethod
        case .serverTime: return ApiTarget._getMethod
        case .clToken: return ApiTarget._postMethod
        case .webClToken: return ApiTarget._postMethod
        case .acessPoints: return ApiTarget._getMethod
        case .wdvCert: return ApiTarget._getMethod
        case .guestAuth: return ApiTarget._getMethod
        case .initAuthMagicLink: return ApiTarget._postMethod
        case .auth: return ApiTarget._postMethod
        case .signupValidate: return ApiTarget._getMethod
        case .signup: return ApiTarget._postMethod
        case .webProfile: return ApiTarget._getMethod
        case .webProfileCustom: return ApiTarget._getMethod
        case .webProfileCustom2: return ApiTarget._getMethod
        case .profile: return ApiTarget._getMethod
        case .landing: return ApiTarget._postMethod
        case .artist: return ApiTarget._getMethod
        case .artistUI: return ApiTarget._getMethod
        case .playlist: return ApiTarget._getMethod
        case .metadata: return ApiTarget._postMethod
        case .lyrics: return ApiTarget._getMethod
        case .collection: return ApiTarget._postMethod
        case .collectionDelta: return ApiTarget._postMethod
        case .collectionWrite: return ApiTarget._postMethod
        case .searchSuggestion: return ApiTarget._getMethod
        case .webSearch: return ApiTarget._getMethod
        case .search: return ApiTarget._getMethod
        case .playIntent: return ApiTarget._postMethod
        case .wdvIntentUrl: return ApiTarget._getMethod
        case .wdvIntent: return ApiTarget._postMethod
        case .downloadInfo: return ApiTarget._getMethod
        case .playlistFromSeed: return ApiTarget._getMethod
        }
    }
}
