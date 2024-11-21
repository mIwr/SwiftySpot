//
//  ApiFuncHeaders.swift
//  SwiftySpot
//
//  Created by Developer on 06.09.2023.
//
extension ApiTarget {
    
    fileprivate static let _emptyDict: [String: String] = [:]
    fileprivate static let _protobufDict: [String: String] = [
        "Content-Type": "application/x-protobuf",
        "Accept": "application/x-protobuf",
        "Accept-Encoding": "gzip",
    ]
    fileprivate static let _protobufCollectionDict: [String: String] = [
        "Content-Type": "application/vnd.collection-v2.spotify.proto",
        "Accept": "application/vnd.collection-v2.spotify.proto",
        "Accept-Encoding": "gzip",
    ]
    
    var headers: [String: String] {
        switch self {
        case .download(let headers, _): return headers
        case .wdvSeektable: return ApiTarget._emptyDict
        case .clToken(let userAgent, _):
            var dict = ApiTarget._protobufDict
            dict["User-Agent"] = userAgent
            return dict
        case .webClToken(let userAgent, _, _, _, _) :
            let dict: [String: String] = [
                "Content-Type": "application/json",
                "Accept": "application/json",
                "Accept-Encoding": "gzip",
                "User-Agent": userAgent
            ]
            return dict
        case .acessPoints(let clToken):
            var dict: [String: String] = [
                "Accept-Encoding": "gzip",
            ]
            if let safeClToken = clToken {
                dict["client-token"] = safeClToken
            }
            return dict
        case .wdvCert:
            let dict: [String: String] = [
                "Accept-Encoding": "gzip",
            ]
            return dict
        case .guestAuth(let userAgent, let os, let appVer):
            let dict: [String: String] = [
                "Accept": "application/json",
                "User-Agent": userAgent,
                "App-Platform": os,
                "Spotify-App-Version": appVer,
            ]
            return dict
        case .auth(let userAgent, let clToken, _):
            var dict = ApiTarget._protobufDict
            dict["User-Agent"] = userAgent
            dict["Client-Token"] = clToken
            return dict
        case .signupValidate(let userAgent, let clToken, let os, let appVer, _, _):
            let dict: [String: String] = [
                "User-Agent": userAgent,
                "Client-Token": clToken,
                "App-Platform": os,
                "Spotify-App-Version": appVer,
            ]
            return dict
        case .signup(let userAgent, let clToken, let os, let appVer, let clId, _):
            let dict: [String: String] = [
                "User-Agent": userAgent,
                "Client-Token": clToken,
                "App-Platform": os,
                "Spotify-App-Version": appVer,
                "X-Client-Id": clId
            ]
            return dict
        case .webProfile(let userAgent, let clToken, let authToken, let os, let appVer):
            let dict: [String: String] = [
                "Accept": "application/json",
                "Accept-Encoding": "gzip",
                "User-Agent": userAgent,
                "Client-Token": clToken,
                "Authorization": "Bearer " + authToken,
                "App-Platform": os,
                "Spotify-App-Version": appVer,
            ]
            return dict
        case .webProfileCustom(let userAgent, let clToken, let authToken, let os, let appVer, _):
            let dict: [String: String] = [
                "Accept": "application/json",
                "Accept-Encoding": "gzip",
                "User-Agent": userAgent,
                "Client-Token": clToken,
                "Authorization": "Bearer " + authToken,
                "App-Platform": os,
                "Spotify-App-Version": appVer,
            ]
            return dict
        case .webProfileCustom2(let userAgent, let clToken, let authToken, let os, let appVer, _):
            let dict: [String: String] = [
                "Accept-Encoding": "gzip",
                "User-Agent": userAgent,
                "Client-Token": clToken,
                "Authorization": "Bearer " + authToken,
                "App-Platform": os,
                "Spotify-App-Version": appVer,
            ]
            return dict
        case .profile(let userAgent, let clToken, let authToken, let os, let appVer):
            let dict: [String: String] = [
                "Accept": "application/json",
                "User-Agent": userAgent,
                "Client-Token": clToken,
                "Authorization": "Bearer " + authToken,
                "App-Platform": os,
                "Spotify-App-Version": appVer,
                //"Referer": "https://open.spotify.com/"
            ]
            return dict
        case .landing(let userAgent, let clToken, let authToken, let os, let appVer, let clId, _):
            var dict = ApiTarget._protobufDict
            dict["User-Agent"] = userAgent
            dict["client-token"] = clToken
            dict["Authorization"] = "Bearer " + authToken
            dict["App-Platform"] = os
            dict["Spotify-App-Version"] = appVer
            dict["X-Client-Id"] = clId
            return dict
        case .artist(let userAgent, let clToken, let authToken, let os, let appVer, let clId, _, _, _):
            let dict: [String: String] = [
                "Accept-Encoding": "gzip",
                "User-Agent": userAgent,
                "Client-Token": clToken,
                "Authorization": "Bearer " + authToken,
                "App-Platform": os,
                "Spotify-App-Version": appVer,
                "X-Client-Id": clId
            ]
            return dict
        case .artistUI(let userAgent, let clToken, let authToken, let os, let appVer, let clId, _, _, _, _, _, _, _, _, _):
            let dict: [String: String] = [
                "Accept-Encoding": "gzip",
                "User-Agent": userAgent,
                "Client-Token": clToken,
                "Authorization": "Bearer " + authToken,
                "App-Platform": os,
                "Spotify-App-Version": appVer,
                "X-Client-Id": clId
            ]
            return dict
        case .playlist(_, let userAgent, let clToken, let authToken, _, let os, let appVer, let listItems):
            var dict = ApiTarget._protobufDict
            dict["User-Agent"] = userAgent
            dict["client-token"] = clToken
            dict["spotify-accept-geoblock"] = "dummy"
            dict["Authorization"] = "Bearer " + authToken
            dict["App-Platform"] = os
            dict["Spotify-App-Version"] = appVer
            dict["x-accept-list-items"] = listItems
            //dict["spotify-playlist-sync-reason"] = "CAYQAQ=="
            return dict
        case .metadata(_, let userAgent, let clToken, let authToken, let os, let appVer, _):
            var dict = ApiTarget._protobufDict
            dict["User-Agent"] = userAgent
            dict["client-token"] = clToken
            dict["Authorization"] = "Bearer " + authToken
            dict["App-Platform"] = os
            dict["Spotify-App-Version"] = appVer
            return dict
        case .lyrics(let userAgent, let clToken, let authToken, let os, let appVer, let clId, _, _, _, _, _):
            let dict: [String: String] = [
                "Accept-Encoding": "gzip",
                "Accept": "application/protobuf",
                "User-Agent": userAgent,
                "client-token": clToken,
                "Authorization": "Bearer " + authToken,
                "App-Platform": os,
                "Spotify-App-Version": appVer,
                "X-Client-Id": clId
            ]
            return dict
        case .collection(let userAgent, let clToken, let authToken, let os, let appVer, _):
            var dict = ApiTarget._protobufCollectionDict
            dict["User-Agent"] = userAgent
            dict["client-token"] = clToken
            dict["Authorization"] = "Bearer " + authToken
            dict["App-Platform"] = os
            dict["Spotify-App-Version"] = appVer
            return dict
        case .collectionDelta(_, let userAgent, let clToken, let authToken, let os, let appVer, _):
            var dict = ApiTarget._protobufCollectionDict
            dict["User-Agent"] = userAgent
            dict["client-token"] = clToken
            dict["Authorization"] = "Bearer " + authToken
            dict["App-Platform"] = os
            dict["Spotify-App-Version"] = appVer
            return dict
        case .collectionWrite(_, let userAgent, let clToken, let authToken, let os, let appVer, _):
            var dict = ApiTarget._protobufCollectionDict
            dict["User-Agent"] = userAgent
            dict["client-token"] = clToken
            dict["Authorization"] = "Bearer " + authToken
            dict["App-Platform"] = os
            dict["Spotify-App-Version"] = appVer
            return dict
        case .searchSuggestion(let userAgent, let clToken, let authToken, let os, let appVer, let clId, _, _, _, _, _, _, _, _):
            let dict: [String: String] = [
                "Accept-Encoding": "gzip",
                "Accept": "application/protobuf",
                "User-Agent": userAgent,
                "client-token": clToken,
                "Authorization": "Bearer " + authToken,
                "App-Platform": os,
                "Spotify-App-Version": appVer,
                "X-Client-Id": clId
            ]
            return dict
        case .webSearch(let userAgent, let clToken, let authToken, let os, let appVer, _, _, _, _, _):
            let dict: [String: String] = [
                "Accept-Encoding": "gzip",
                "Accept": "application/json",
                "User-Agent": userAgent,
                "Client-Token": clToken,
                "Authorization": "Bearer " + authToken,
                "App-Platform": os,
                "Spotify-App-Version": appVer,
            ]
            return dict
        case .search(let userAgent, let clToken, let authToken, let os, let appVer, let clId, _, _, _, _, _, _, _, _, _):
            let dict: [String: String] = [
                "Accept-Encoding": "gzip",
                "Accept": "application/protobuf",
                "User-Agent": userAgent,
                "client-token": clToken,
                "Authorization": "Bearer " + authToken,
                "App-Platform": os,
                "Spotify-App-Version": appVer,
                "X-Client-Id": clId
            ]
            return dict
        case .playIntent(_, let userAgent, let clToken, let authToken, let os, let appVer, _, _):
            let dict: [String: String] = [
                "Accept-Encoding": "gzip",
                "Content-Type": "application/protobuf",
                "User-Agent": userAgent,
                "client-token": clToken,
                "Authorization": "Bearer " + authToken,
                "App-Platform": os,
                "Spotify-App-Version": appVer,
            ]
            return dict
        case .wdvIntentUrl(_, let userAgent, let clToken, let authToken, let os, let appVer, _):
            let dict: [String: String] = [
                "User-Agent": userAgent,
                "Origin": "https://open.spotify.com/",
                "Referer": "https://open.spotify.com/",
                "sec-ch-ua": "\"Google Chrome\";v=\"123\", \"Not:A-Brand\";v=\"8\", \"Chromium\";v=\"123\"",
                "sec-ch-ua-mobile": "?0",
                "sec-ch-ua-platform": "Windows",
                "Sec-Fetch-Dest": "empty",
                "Sec-Fetch-Mode": "cors",
                "Sec-Fetch-Site": "same-site",
                "Accept-Encoding": "gzip",
                "Content-Type": "application/protobuf",
                "Accept": "application/json",
                "client-token": clToken,
                "Authorization": "Bearer " + authToken,
                "App-Platform": os,
                "Spotify-App-Version": appVer,
            ]
            return dict
        case .wdvIntent(_, let userAgent, let clToken, let authToken, let os, let appVer, _, _):
            let dict: [String: String] = [
                "sec-ch-ua": "\"Google Chrome\";v=\"123\", \"Not:A-Brand\";v=\"8\", \"Chromium\";v=\"123\"",
                "sec-ch-ua-mobile": "?0",
                "sec-ch-ua-platform": "Windows",
                "Accept-Encoding": "gzip",
                "Content-Type": "application/protobuf",
                "Accept": "application/json",
                "User-Agent": userAgent,
                "Referer": "https://open.spotify.com/",
                "client-token": clToken,
                "Authorization": "Bearer " + authToken,
                "App-Platform": os,
                "Spotify-App-Version": appVer,
            ]
            return dict
        case .downloadInfo(_, let userAgent, let clToken, let authToken, let os, let appVer, _, _):
            let dict: [String: String] = [
                "Accept-Encoding": "gzip",
                "User-Agent": userAgent,
                "client-token": clToken,
                "Authorization": "Bearer " + authToken,
                "App-Platform": os,
                "Spotify-App-Version": appVer,
            ]
            return dict
        case .playlistFromSeed(let userAgent, let clToken, let authToken, let os, let appVer, let clId, _):
            let dict: [String: String] = [
                "Accept-Encoding": "gzip",
                "User-Agent": userAgent,
                "Client-Token": clToken,
                "Authorization": "Bearer " + authToken,
                "App-Platform": os,
                "Spotify-App-Version": appVer,
                "X-Client-Id": clId
            ]
            return dict
        }
    }
}
