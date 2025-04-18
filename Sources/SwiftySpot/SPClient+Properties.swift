//
//  SPClientPropExt.swift
//  SwiftySpot
//
//  Created by Developer on 08.09.2023.
//

import Foundation

extension SPClient {
    ///Generated client user agent
    public var userAgent: String {
        get {
            var osVer = String(device.osVersionNumber)
            if (device.iOS) {
                osVer = device.osVersionCode
            }
            let userAgent = "Spotify/" + appVersionCode + " " + device.os + "/" + osVer + " (" + device.model + ")"
            return userAgent
        }
    }
    
    ///Generated web client user agent
    public var webUserAgent: String {
        get {
            return "Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/123.0.0.0 Safari/537.36"
        }
    }
    
    ///Client token
    public var clientToken: String? {
        get {
            if (clToken.val.isEmpty || clientTokenExpired) {
                return nil
            }
            return clToken.val;
        }
    }
    ///Client token lifetime duration
    public var clienTokenExpiresInS: Int32 {
        get {
            return clToken.expiresInS
        }
    }
    ///Client token expiry datetime (UTC+0)
    public var clientTokenExpiryUTC: Date {
        get {
            let expiryTs = clTokenCreateTsUTC + Int64(clToken.expiresInS)
            let dt = Date(timeIntervalSince1970: TimeInterval(expiryTs))
            
            return dt
        }
    }
    ///Client token expiry local datetime
    public var clientTokenExpiryLocal: Date {
        get {
            let nowDt = Date()
            let timezoneSecs = TimeZone.current.secondsFromGMT(for: nowDt)
            let expiryTs = clTokenCreateTsUTC + Int64(clToken.expiresInS) + Int64(timezoneSecs)
            let dt = Date(timeIntervalSince1970: TimeInterval(expiryTs))
            
            return dt
        }
    }
    ///Client token expired flag
    public var clientTokenExpired: Bool {
        get {
            let nowTs = Int64(Date().timeIntervalSince1970)
            let expiryTs = clTokenCreateTsUTC + Int64(clToken.expiresInS)
            return nowTs >= expiryTs
        }
    }
    ///Client token 'need to be refreshed after'
    public var clienTokenRefreshAfterInS: Int32 {
        get {
            return clToken.refreshAfterS
        }
    }
    ///Client token refresh datetime (UTC+0)
    public var clientTokenRefreshUTC: Date {
        get {
            let expiryTs = clTokenCreateTsUTC + Int64(clToken.refreshAfterS)
            let dt = Date(timeIntervalSince1970: TimeInterval(expiryTs))
            
            return dt
        }
    }
    ///Client token refresh local datetime
    public var clientTokenRefreshLocal: Date {
        get {
            let nowDt = Date()
            let timezoneSecs = TimeZone.current.secondsFromGMT(for: nowDt)
            let expiryTs = clTokenCreateTsUTC + Int64(clToken.refreshAfterS) + Int64(timezoneSecs)
            let dt = Date(timeIntervalSince1970: TimeInterval(expiryTs))
            
            return dt
        }
    }
    
    #if DEBUG
    public var storedCredHex: String? {
        get {
            if (authSession.storedCredential.isEmpty) {
                return nil
            }
            let bytes = [UInt8].init(authSession.storedCredential)
            let hex = SPBase16.encode(bytes)
            return hex
        }
    }
    #endif
    
    ///Authorization refresh credential
    public var authStoredCred: String? {
        get {
            if authSession.storedCredential.isEmpty {
                return nil
            }
            let storedCredStr = String(bytes: authSession.storedCredential, encoding: .utf8)
            return storedCredStr
        }
    }
    
    ///Guest authorization token
    public var guestAuthToken: String? {
        get {
            if (guestAuthSession.token.isEmpty || guestAuthSession.expired) {
                return nil
            }
            return guestAuthSession.token
        }
    }
    ///Authorization token
    public var authToken: String? {
        get {
            if (authSession.token.isEmpty || authTokenExpired) {
                return nil
            }
            return authSession.token
        }
    }
    ///Authorization token lifetime duration
    public var authTokenExpiresInS: Int32 {
        get {
            return authSession.expiresInS
        }
    }
    ///Authorization expiry datetime (UTC+0)
    public var authTokenExpiryUTC: Date {
        get {
            let expiryTs = authTokenCreateTsUTC + Int64(authSession.expiresInS)
            let dt = Date(timeIntervalSince1970: TimeInterval(expiryTs))
            
            return dt
        }
    }
    ///Authorization expiry local datetime
    public var authTokenExpiryLocal: Date {
        get {
            let nowDt = Date()
            let timezoneSecs = TimeZone.current.secondsFromGMT(for: nowDt)
            let expiryTs = authTokenCreateTsUTC + Int64(authSession.expiresInS) + Int64(timezoneSecs)
            let dt = Date(timeIntervalSince1970: TimeInterval(expiryTs))
            
            return dt
        }
    }
    ///Has stable authorization (stored credentials exist) flag
    public var authorized: Bool {
        return !authSession.storedCredential.isEmpty
    }
    ///Authorization token expired flag
    public var authTokenExpired: Bool {
        get {
            let nowTs = Int64(Date().timeIntervalSince1970)
            let expiryTs = authTokenCreateTsUTC + Int64(authSession.expiresInS)
            return nowTs >= expiryTs
        }
    }
    ///Can refresh auth token by stored credential flag
    var canRefreshAuthToken: Bool {
        get {
            return !authSession.storedCredential.isEmpty
        }
    }
    ///Private back-end API access point
    var spclientAp: String? {
        get {
            if (spclientHosts.isEmpty) {
                return nil
            }
            for item in spclientHosts {
                if (item.isEmpty) {
                    continue
                }
                return item
            }
            return nil
        }
    }
    ///Wideveine application privacy cert
    public var wdvAppCert: Data? {
        get {
            return wdvCert
        }
    }
    ///Authorized session profile info
    public var me: SPProfile? {
        get {
            return profile
        }
    }
    ///Liked artists storage
    public var likedArtistsStorage: SPCollectionController {
        get {
            return likedDislikedArtistsStorage.liked
        }
    }
    ///Disliked artists storage
    public var dislikedArtistsStorage: SPCollectionController {
        get {
            return likedDislikedArtistsStorage.disliked
        }
    }
    ///Liked albums storage
    public var likedAlbumsStorage: SPCollectionController {
        get {
            return likedDislikedAlbumsStorage.liked
        }
    }
    ///Disliked albums storage
    public var dislikedAlbumsStorage: SPCollectionController {
        get {
            return likedDislikedAlbumsStorage.disliked
        }
    }
    ///Liked tracks storage
    public var likedTracksStorage: SPCollectionController {
        get {
            return likedDislikedTracksStorage.liked
        }
    }
    ///Disliked tracks storage
    public var dislikedTracksStorage: SPCollectionController {
        get {
            return likedDislikedTracksStorage.disliked
        }
    }
}
