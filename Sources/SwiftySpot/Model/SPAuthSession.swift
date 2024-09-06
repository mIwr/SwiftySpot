//
//  SPAuthSession.swift
//  SwiftySpot
//
//  Created by Developer on 11.09.2023.
//

import Foundation

///Spotify auth session
public class SPAuthSession {
    ///Account username. Used for auth token refresh
    public let username: String
    ///Authorization token
    public let token: String
    ///Account stored credentials data. Used for auth token refresh
    public let storedCred: Data
    ///Authorization create unixepoch timestamp (UTC+0)
    public let createTsUTC: Int64
    ///Authorization token lifetime duration
    public let expiresInS: Int32
    
    ///Authorization expiry datetime (UTC+0)
    public var expiryDtUTC: Date {
        get {
            let expiryTs = createTsUTC + Int64(expiresInS)
            let dt = Date(timeIntervalSince1970: TimeInterval(expiryTs))
            
            return dt
        }
    }
    ///Authorization expiry local datetime
    public var expiryDtLocal: Date {
        get {
            let nowDt = Date()
            let timezoneSecs = TimeZone.current.secondsFromGMT(for: nowDt)
            let expiryTs = createTsUTC + Int64(expiresInS) + Int64(timezoneSecs)
            let dt = Date(timeIntervalSince1970: TimeInterval(expiryTs))
            
            return dt
        }
    }
    ///Has stable authorization (stored credentials exist) flag
    public var authorized: Bool {
        return !storedCred.isEmpty
    }
    ///Authorization token expired flag
    public var expired: Bool {
        get {
            let nowTs = Int64(Date().timeIntervalSince1970)
            let expiryTs = createTsUTC + Int64(expiresInS)
            return nowTs >= expiryTs
        }
    }
    ///Can refresh auth token by stored credential flag
    var canRefreshAuthToken: Bool {
        get {
            return !storedCred.isEmpty
        }
    }
    
    public init(username: String, token: String, storedCred: Data, createTsUTC: Int64, expiresInS: Int32) {
        self.username = username
        self.token = token
        self.storedCred = storedCred
        self.createTsUTC = createTsUTC
        self.expiresInS = expiresInS
    }
}
