//
//  SPClientSession.swift
//  SwiftySpot
//
//  Created by Developer on 08.10.2023.
//

import Foundation

///Spotify client session
public class SPClientSession {
    ///Client token
    public let token: String
    ///Client session create unixepoch timestamp (UTC+0)
    public let createTsUTC: Int64
    ///Client session lifetime duration
    public let expiresInS: Int32
    ///Cleint session refresh duration
    public let refreshInS: Int32
    
    ///Client token expiry datetime (UTC+0)
    public var expiryDtUTC: Date {
        get {
            let expiryTs = createTsUTC + Int64(expiresInS)
            let dt = Date(timeIntervalSince1970: TimeInterval(expiryTs))
            
            return dt
        }
    }
    ///Client token expiry local datetime
    public var expiryDtLocal: Date {
        get {
            let nowDt = Date()
            let timezoneSecs = TimeZone.current.secondsFromGMT(for: nowDt)
            let expiryTs = createTsUTC + Int64(expiresInS) + Int64(timezoneSecs)
            let dt = Date(timeIntervalSince1970: TimeInterval(expiryTs))
            
            return dt
        }
    }
    ///Client token expired flag
    public var expired: Bool {
        get {
            let nowTs = Int64(Date().timeIntervalSince1970)
            let expiryTs = createTsUTC + Int64(expiresInS)
            return nowTs >= expiryTs
        }
    }
    ///Client token refresh datetime (UTC+0)
    public var refreshTsUTC: Date {
        get {
            let expiryTs = createTsUTC + Int64(refreshInS)
            let dt = Date(timeIntervalSince1970: TimeInterval(expiryTs))
            
            return dt
        }
    }
    ///Client token refresh local datetime
    public var refreshDtLocal: Date {
        get {
            let nowDt = Date()
            let timezoneSecs = TimeZone.current.secondsFromGMT(for: nowDt)
            let expiryTs = createTsUTC + Int64(refreshInS) + Int64(timezoneSecs)
            let dt = Date(timeIntervalSince1970: TimeInterval(expiryTs))
            
            return dt
        }
    }
    
    public init(token: String, createTsUTC: Int64, expiresInS: Int32, refreshInS: Int32) {
        self.token = token
        self.createTsUTC = createTsUTC
        self.expiresInS = expiresInS
        self.refreshInS = refreshInS
    }
}
