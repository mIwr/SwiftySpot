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
    
    public init(username: String, token: String, storedCred: Data, createTsUTC: Int64, expiresInS: Int32) {
        self.username = username
        self.token = token
        self.storedCred = storedCred
        self.createTsUTC = createTsUTC
        self.expiresInS = expiresInS
    }
}
