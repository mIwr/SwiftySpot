//
//  ApiBaseUrl.swift
//  SwiftySpot
//
//  Created by Developer on 06.09.2023.
//
extension ApiTarget {
    
    fileprivate static let _clientTokenBaseUrl = "https://clienttoken.spotify.com/"
    fileprivate static let _apBaseUrl = "https://apresolve.spotify.com/"
    fileprivate static let _authBaseUrl = "https://login5.spotify.com/"
    fileprivate static let _spClientWgBaseUrl = "https://spclient.wg.spotify.com/"
    fileprivate static let _publicApiBaseUrl = "https://api.spotify.com/"
    
    var baseURL: String {
        switch self {
        case .download(_, let path): return path
        case .clToken: return ApiTarget._clientTokenBaseUrl
        case .acessPoints: return ApiTarget._apBaseUrl
        case .auth: return ApiTarget._authBaseUrl
        case .profile: return ApiTarget._publicApiBaseUrl
        case .landing: return ApiTarget._spClientWgBaseUrl
        case .artist: return ApiTarget._spClientWgBaseUrl
        case .artistUI: return ApiTarget._spClientWgBaseUrl
        case .playlist(let apHost, _, _, _, _, _, _, _):
            return normalizeBaseUrl(apHost)
        case .metadata(let apHost, _, _, _, _, _, _):
            return normalizeBaseUrl(apHost)
        case .collection: return ApiTarget._spClientWgBaseUrl
        case .collectionDelta(let apHost, _, _, _, _, _, _):
            return normalizeBaseUrl(apHost)
        case .collectionWrite(let apHost, _, _, _, _, _, _):
            return normalizeBaseUrl(apHost)
        case .searchSuggestion: return ApiTarget._spClientWgBaseUrl
        case .search: return ApiTarget._spClientWgBaseUrl
        case .playIntent(let apHost, _, _, _, _, _, _, _):
            return normalizeBaseUrl(apHost)
        case .downloadInfo(let apHost, _, _, _, _, _, _, _):
            return normalizeBaseUrl(apHost)
        }
    }
    
    fileprivate func normalizeBaseUrl(_ url: String) -> String {
        var host = url
        if let last = host.last, last != "/" {
            host += "/"
        }
        return host
    }
}
