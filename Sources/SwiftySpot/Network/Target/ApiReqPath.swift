//
//  ApiFuncPath.swift
//  SwiftySpot
//
//  Created by Developer on 06.09.2023.
//

import Foundation

extension ApiTarget {
    
    fileprivate static let _clientTokenPath = "v1/clienttoken"
    fileprivate static let _authPath = "v3/login"
    fileprivate static let _signupValidatePathPrefix = "signup/public/v1/account/"
    fileprivate static let _signupPath = "signup/public/v2/account/create"
    fileprivate static let _profileInfoPath = "v1/me"
    fileprivate static let _dacLandingPath = "home-dac-viewservice/v1/view"
    fileprivate static let _playlistInfoPathPrefix = "playlist/v2/playlist/"
    fileprivate static let _artistUIInfoPathPrefix = "artistview/v1/artist/"
    fileprivate static let _artistInfoPathPrefix = "artist-identity-view/v2/profile/"
    fileprivate static let _metadataPath = "extended-metadata/v0/extended-metadata/"
    fileprivate static let _lyricsPathPerfix = "/color-lyrics/v2/"
    fileprivate static let _lyricsReservePathPart = "https://open.spotify.com/"
    fileprivate static let _collectionPathPerfix = "collection/v2/"
    fileprivate static let _collectionInfoPath = _collectionPathPerfix + "paging"
    fileprivate static let _collectionDeltaPath = _collectionPathPerfix + "delta"
    fileprivate static let _collectionWritePath = _collectionPathPerfix + "write"
    fileprivate static let _searchPrefixPath = "searchview/v3/"
    fileprivate static let _searchSuggestionPath = _searchPrefixPath + "autocomplete"
    fileprivate static let _searchPath = _searchPrefixPath + "search"
    fileprivate static let _searchPodcastPath = _searchPath + "/podcasts"
    fileprivate static let _searchDrillDownPath = _searchPath + "/drilldowns"
    fileprivate static let _playIntentPathPrefix = "playplay/v1/key/"
    fileprivate static let _downloadInfoPathPrefix = "storage-resolve/v2/files/audio/interactive/"
    
    var path: String {
        switch self {
        case .download: return ""
        case .clToken: return ApiTarget._clientTokenPath
        case .acessPoints:
            let nowTsUtc = Int64(Date().timeIntervalSince1970)
            return "?time=" + String(nowTsUtc) + "&type=accesspoint&type=spclient&type=dealer" 
        case .auth: return ApiTarget._authPath
        case .signupValidate(_, _, _, _, let validatorKey, let password):
            var path = ApiTarget._signupValidatePathPrefix + "?validate=1&key=" + validatorKey
            if let safePass = password, !safePass.isEmpty {
                let encodedPass = safePass.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? safePass
                path += "&suggest=1&password=" + encodedPass
            }
            return path
        case .signup: return ApiTarget._signupPath
        case .profile: return ApiTarget._profileInfoPath
        case .landing: return ApiTarget._dacLandingPath
        case .artist(_, _, _, _, _, _, let uri, let fields, let imgSize):
            var path = ApiTarget._artistInfoPathPrefix + uri
            if (!fields.isEmpty || !imgSize.isEmpty) {
                path += "?"
                if (!fields.isEmpty) {
                    path += "?fields=" + fields[0]
                    if (fields.count > 1) {
                        for i in 1...fields.count - 1 {
                            path += "," + fields[i]
                        }
                    }                    
                }
                if (!imgSize.isEmpty) {
                    path += "imgSize=" + imgSize
                }
            }
            return path
        case .artistUI(_, _, _, let os, _, _, let id, let locale, let application, let video, let podcast, let deviceId, let timezone, let timeFormat, let signal):
            return ApiTarget._artistUIInfoPathPrefix + id + "?locale=" + locale + "&application=" + application + "&platform=" + os.lowercased() + "&video=" + String(video).lowercased() + "&podcast=" + String(podcast).lowercased() + "&checkDeviceCapability=false&device_id=" + deviceId + "&purchase_allowed=false&timezone=" + timezone + "&timeFormat=" + timeFormat + "&signal=" + signal
        case .playlist(_, _, _, _, let id, _, _, _): return ApiTarget._playlistInfoPathPrefix + id
        case .metadata: return ApiTarget._metadataPath
        case .lyrics(_, _, _, _, _, _, let type, let id, let vocalRemove, let syllableSync, let clientLangCode):
            return ApiTarget._lyricsPathPerfix + type + "/" + id + "?vocalRemoval=" + String(vocalRemove) + "&syllableSync=" + String(syllableSync) + "&clientLanguage=" + clientLangCode
        case .lyricsReserve(let type, let id): return "?url=" + ApiTarget._lyricsReservePathPart + type + "/" + id + "?autoplay=true"
        case .collection: return ApiTarget._collectionInfoPath
        case .collectionDelta: return ApiTarget._collectionDeltaPath
        case .collectionWrite: return ApiTarget._collectionWritePath
        case .searchSuggestion(_, _, _, _, _, _, let reqId, let query, let catalogue, let locale, let entityTypes, let ts, let onDemandSets, let limit):
            var types = ""
            for type in entityTypes {
                types += type + ","
            }
            if (!entityTypes.isEmpty) {
                types.removeLast()
            }
            return ApiTarget._searchSuggestionPath + "?request_id=" + reqId.uuidString.lowercased() + "&query=" + query + "&catalogue=" + catalogue + "&locale=" + locale + "&entity_types=" + types + "&timestamp=" + String(ts) + "&on_demand_sets_enabled=" + String(onDemandSets) + "&limit=" + String(limit)
            //&album_states=live%2Cprerelease
        case .search(_, _, _, _, _, _, let reqId, let query, let catalogue, let locale, let entityTypes, let ts, let onDemandSets, let limit, let pageToken):
            var types = ""
            for type in entityTypes {
                types += type + ","
            }
            if (!entityTypes.isEmpty) {
                types.removeLast()
            }
            return ApiTarget._searchPath + "?request_id=" + reqId.uuidString.lowercased() + "&query=" + query + "&catalogue=" + catalogue + "&locale=" + locale + "&entity_types=" + types + "&timestamp=" + String(ts) + "&on_demand_sets_enabled=" + String(onDemandSets) + "&limit=" + String(limit) + "&page_token=" + pageToken
            //&album_states=live%2Cprerelease
        case .playIntent(_, _, _, _, _, _, let audioFileHexId, _): return ApiTarget._playIntentPathPrefix + audioFileHexId
        case .downloadInfo(_, _, _, _, _, _, let audioFileHexId, let productType): return ApiTarget._downloadInfoPathPrefix + String(productType) + "/" + audioFileHexId + "?product=" + String(productType)
        }
    }
}
