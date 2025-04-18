//
//  ApiBaseUrl.swift
//  SwiftySpot
//
//  Created by Developer on 06.09.2023.
//
extension ApiTarget {
    
    fileprivate static let _clientTokenBaseUrl = "https://clienttoken.spotify.com/"
    fileprivate static let _apBaseUrl = "https://apresolve.spotify.com/"
    fileprivate static let _guestAuthBaseUrl = "https://open.spotify.com/"
    fileprivate static let _authBaseUrl = "https://login5.spotify.com/"
    fileprivate static let _spClientWgBaseUrl = "https://spclient.wg.spotify.com/"
    fileprivate static let _publicApiBaseUrl = "https://api.spotify.com/"
    fileprivate static let _webApiBaseUrl = "https://api-partner.spotify.com/"
    fileprivate static let _seektableApiBaseUrl = "https://seektables.scdn.co/"
    
    var baseURL: String {
        switch self {
        case .download(_, let path): return path
        case .wdvSeektable: return ApiTarget._seektableApiBaseUrl
        case .serverTime: return ApiTarget._guestAuthBaseUrl
        case .clToken: return ApiTarget._clientTokenBaseUrl
        case .webClToken: return ApiTarget._clientTokenBaseUrl
        case .acessPoints: return ApiTarget._apBaseUrl
        case .wdvCert: return ApiTarget._spClientWgBaseUrl
        case .guestAuth: return ApiTarget._guestAuthBaseUrl
        case .initAuthMagicLink: return ApiTarget._spClientWgBaseUrl
        case .auth: return ApiTarget._authBaseUrl
        case .signupValidate: return ApiTarget._spClientWgBaseUrl
        case .signup: return ApiTarget._spClientWgBaseUrl
        case .webProfile: return ApiTarget._webApiBaseUrl
        case .webProfileCustom: return ApiTarget._spClientWgBaseUrl
        case .webProfileCustom2: return ApiTarget._spClientWgBaseUrl
        case .profile: return ApiTarget._publicApiBaseUrl
        case .landing: return ApiTarget._spClientWgBaseUrl
        case .artist: return ApiTarget._spClientWgBaseUrl
        case .artistUI: return ApiTarget._spClientWgBaseUrl
        case .playlist(let apHost, _, _, _, _, _, _, _): return normalizeBaseUrl(apHost)
        case .metadata(let apHost, _, _, _, _, _, _): return normalizeBaseUrl(apHost)
        case .lyrics: return ApiTarget._spClientWgBaseUrl
        case .collection: return ApiTarget._spClientWgBaseUrl
        case .collectionDelta(let apHost, _, _, _, _, _, _): return normalizeBaseUrl(apHost)
        case .collectionWrite(let apHost, _, _, _, _, _, _): return normalizeBaseUrl(apHost)
        case .searchSuggestion: return ApiTarget._spClientWgBaseUrl
        case .webSearch: return ApiTarget._webApiBaseUrl
        case .search: return ApiTarget._spClientWgBaseUrl
        case .playIntent(let apHost, _, _, _, _, _, _, _): return normalizeBaseUrl(apHost)
        case .wdvIntentUrl(let apHost, _, _, _, _, _, _): return normalizeBaseUrl(apHost)
        case .wdvIntent(let apHost, _, _, _, _, _, _, _): return normalizeBaseUrl(apHost)
        case .downloadInfo(let apHost, _, _, _, _, _, _, _): return normalizeBaseUrl(apHost)
        case .playlistFromSeed: return ApiTarget._spClientWgBaseUrl
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
