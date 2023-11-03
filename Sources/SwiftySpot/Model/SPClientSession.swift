//
//  SPClientSession.swift
//  SwiftySpot
//
//  Created by Developer on 08.10.2023.
//

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
    
    public init(token: String, createTsUTC: Int64, expiresInS: Int32, refreshInS: Int32) {
        self.token = token
        self.createTsUTC = createTsUTC
        self.expiresInS = expiresInS
        self.refreshInS = refreshInS
    }
}
