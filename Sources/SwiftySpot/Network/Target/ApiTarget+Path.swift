//
//  ApiFuncPath.swift
//  SwiftySpot
//
//  Created by Developer on 06.09.2023.
//

import Foundation

extension ApiTarget {
    
    fileprivate static let _serverTimePath = "server-time"
    fileprivate static let _clientTokenPath = "v1/clienttoken"
    fileprivate static let _guestAuthPath = "get_access_token"
    fileprivate static let _webApiPathPrefix = "pathfinder/v1/query"
    fileprivate static let _initAuthMagicLinkPath = "accountrecovery/v3/magiclink";
    fileprivate static let _authPath = "v4/login"
    fileprivate static let _signupValidatePathPrefix = "signup/public/v1/account/"
    fileprivate static let _signupPath = "signup/public/v2/account/create"
    fileprivate static let _profileInfoPath = "v1/me"
    fileprivate static let _webProfileCustomInfoPathPrefix = "user-profile-view/v3/profile/"
    fileprivate static let _webProfileCustomInfo2PathPrefix = "identity/v3/user/username/"
    fileprivate static let _dacLandingPath = "home-dac-viewservice/v1/view"
    fileprivate static let _playlistInfoPathPrefix = "playlist/v2/playlist/"
    fileprivate static let _artistUIInfoPathPrefix = "artistview/v1/artist/"
    fileprivate static let _artistInfoPathPrefix = "artist-identity-view/v2/profile/"
    fileprivate static let _metadataPath = "extended-metadata/v0/extended-metadata/"
    fileprivate static let _lyricsPathPerfix = "color-lyrics/v2/"
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
    fileprivate static let _wdvPathPrefix = "widevine-license/v1/"
    fileprivate static let _wdvCertPath = _wdvPathPrefix + "application-certificate"
    fileprivate static let _wdvIntentPermissionPath = "melody/v1/license_url"
    fileprivate static let _wdvIntentPathSuffix = "/license"
    fileprivate static let _wdvSeektablePathPrefix = "seektable/"
    fileprivate static let _downloadInfoPathPrefix = "storage-resolve/v2/files/audio/interactive/"
    fileprivate static let _playlistFromSeedPathPrefix = "inspiredby-mix/v2/seed_to_playlist/"
    
    var path: String {
        switch self {
        case .download: return ""
        case .wdvSeektable(let fileHexId): return ApiTarget._wdvSeektablePathPrefix + fileHexId + ".json"
        case .serverTime: return ApiTarget._serverTimePath
        case .clToken: return ApiTarget._clientTokenPath
        case .webClToken: return ApiTarget._clientTokenPath
        case .acessPoints:
            let nowTsUtc = Int64(Date().timeIntervalSince1970)
            return "?time=" + String(nowTsUtc) + "&type=accesspoint&type=spclient&type=dealer" 
        case .wdvCert: return ApiTarget._wdvCertPath
        case .guestAuth(_, _, _, let totp, let totpVer, let timestamp):
            return ApiTarget._guestAuthPath + "?reason=transport&productType=web-player&totp=" + totp + "&totpVer=" + String(totpVer) + "&ts=" + String(timestamp)
        case .initAuthMagicLink: return ApiTarget._initAuthMagicLinkPath
        case .auth: return ApiTarget._authPath
        case .signupValidate(_, _, _, _, let validatorKey, let password):
            var path = ApiTarget._signupValidatePathPrefix + "?validate=1&key=" + validatorKey
            if let safePass = password, !safePass.isEmpty {
                let encodedPass = safePass.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? safePass
                path += "&suggest=1&password=" + encodedPass
            }
            return path
        case .signup: return ApiTarget._signupPath
        case .webProfile:
            var path = ApiTarget._webApiPathPrefix + "?operationName=profileAttributes&variables={}"
            let dict: [String: Any] = [
                "persistedQuery": [
                    "sha256Hash": "53bcb064f6cd18c23f752bc324a791194d20df612d8e1239c735144ab0399cea",
                    "version": 1
                ]
            ]
            let data = (try? JSONSerialization.data(withJSONObject: dict)) ?? Data()
            let jsonStr = String(data: data, encoding: .utf8) ?? ""
            path += "&extensions=" + jsonStr
            return path
        case .webProfileCustom(_, _, _, _, _, let username):
            return ApiTarget._webProfileCustomInfoPathPrefix + username
        case .webProfileCustom2(_, _, _, _, _, let username):
            return ApiTarget._webProfileCustomInfo2PathPrefix + username
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
        case .webSearch(_, _, _, _, _, let query, let opName, let opQueryHashHexString, let limit, let offset):
            var dict: [String: Any] = [
                "searchTerm": query,
                "limit": limit,
                "offset": offset,
                "numberOfTopResults": limit,
                "includeAudiobooks": false,
                "includePreReleases": false,
                "includeArtistHasConcertsField": false,
                "includeLocalConcertsField": false,
                "includeAuthors": false,
            ]
            var data = (try? JSONSerialization.data(withJSONObject: dict)) ?? Data()
            var jsonStr = String(data: data, encoding: .utf8) ?? ""
            var path = ApiTarget._webApiPathPrefix + "?operationName=" + opName + "&variables=" + jsonStr
            dict = [
                "persistedQuery": [
                    "version": 1,
                    "sha256Hash": opQueryHashHexString
                ]
            ]
            data = (try? JSONSerialization.data(withJSONObject: dict)) ?? Data()
            jsonStr = String(data: data, encoding: .utf8) ?? ""
            path += "&extensions=" + jsonStr
            return path
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
        case .wdvIntentUrl(_, _, _, _, _, _, let fileType): return ApiTarget._wdvIntentPermissionPath + "?keysystem=com.widevine.alpha&sdk_name=harmony&sdk_version=4.43.2&mediatype=" + fileType
        case .wdvIntent(_, _, _, _, _, _, let fileType, _): return ApiTarget._wdvPathPrefix + fileType + ApiTarget._wdvIntentPathSuffix
        case .playIntent(_, _, _, _, _, _, let audioFileHexId, _): return ApiTarget._playIntentPathPrefix + audioFileHexId
        case .downloadInfo(_, _, _, _, _, _, let audioFileHexId, let productType): return ApiTarget._downloadInfoPathPrefix + String(productType) + "/" + audioFileHexId + "?product=" + String(productType)
        case .playlistFromSeed(_, _, _, _, _, _, let uri): return ApiTarget._playlistFromSeedPathPrefix + uri
        }
    }
}
