//
//  SPWdvLicUrl.swift
//  SwiftySpot
//
//  Created by developer on 27.08.2024.
//

import Foundation

class SPWDVLicUrl: Decodable {
    
    enum CodingKeys: String, CodingKey {
      case uri
      case expiresTsUTC = "expires"
    }
    
    let uri: String
    let expiresTsUTC: Int64
    var expiryDtUTC: Date {
        get {
            let dt = Date(timeIntervalSince1970: TimeInterval(expiresTsUTC))
            return dt
        }
    }
    var expiryDtLocal: Date {
        get {
            let nowDt = Date()
            let timezoneSecs = TimeZone.current.secondsFromGMT(for: nowDt)
            let expiryTs = expiresTsUTC + Int64(timezoneSecs)
            let dt = Date(timeIntervalSince1970: TimeInterval(expiryTs))
            
            return dt
        }
    }
    var expired: Bool {
        get {
            let nowTs = Int64(Date().timeIntervalSince1970)
            return nowTs >= expiresTsUTC
        }
    }
    
    init(licUrl: String, expiresTsUTC: Int64) {
        uri = licUrl
        self.expiresTsUTC = expiresTsUTC
    }
    
    func generateReqUri(apHost: String) -> URL? {
        if (apHost.isEmpty) {
            return nil
        }
        let uri = URL.init(string: apHost + uri)
        return uri
    }
}
