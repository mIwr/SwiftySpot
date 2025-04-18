//
//  SPGuestWebAuthSession.swift
//  SwiftySpot
//
//  Created by developer on 11.10.2024.
//

import Foundation

///Spotify guest web auth session
public class SPGuestWebAuthSession: Decodable {
    
    enum CodingKeys: String, CodingKey {
      //case clId = "clientId"
      case token = "accessToken"
      case expirationTsMsUTC = "accessTokenExpirationTimestampMs"
    }
    
    ///Authorization token
    public let token: String
    ///Authorization token expiration timestamp in millis
    public let expirationTsMsUTC: Int64
    
    ///Authorization expiry datetime (UTC+0)
    public var expiryDtUTC: Date {
        get {
            let dt = Date(timeIntervalSince1970: TimeInterval(expirationTsMsUTC / 1000))
            
            return dt
        }
    }
    ///Authorization expiry local datetime
    public var expiryDtLocal: Date {
        get {
            let nowDt = Date()
            let timezoneSecs = TimeZone.current.secondsFromGMT(for: nowDt)
            let expiryTs = expirationTsMsUTC / 1000 + Int64(timezoneSecs)
            let dt = Date(timeIntervalSince1970: TimeInterval(expiryTs))
            
            return dt
        }
    }
    ///Authorization token expired flag
    public var expired: Bool {
        get {
            let nowTs = Int64(Date().timeIntervalSince1970)
            return nowTs >= expirationTsMsUTC / 1000
        }
    }
    
    public init(token: String, expirationTsMsUTC: Int64) {
        self.token = token
        self.expirationTsMsUTC = expirationTsMsUTC
    }
}
