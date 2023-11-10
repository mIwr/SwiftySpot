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
        case .clToken(let userAgent, _):
            var dict = ApiTarget._protobufDict
            dict["User-Agent"] = userAgent
            return dict
        case .acessPoints(let clToken):
            let dict: [String: String] = [
                "Accept-Encoding": "gzip",
                "client-token": clToken
            ]
            return dict
        case .auth(let userAgent, let clToken, _):
            var dict = ApiTarget._protobufDict
            dict["User-Agent"] = userAgent
            dict["client-token"] = clToken
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
                "Content-Type": "text/plain",
                "User-Agent": userAgent,
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
        }
    }
}
