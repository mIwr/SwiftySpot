//
//  TestCredentialsTemplate.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

import SwiftySpot

final class TestCredentialsTemplate {
    
    static let clToken = ""
    static let clExpires: Int32 = 1216800
    static let clRefresh: Int32 = 1209600
    static let clCreated: Int64 = 1729865200
    
    static let login = ""
    static let password = ""
    
    static let username = ""
    static let storedCredential = ""
    
    ///Spotify API client with guest authorization
    static let guestClient = SPClient(device: TestConstants.device, clToken: clToken, clTokenExpires: clExpires, clTokenRefreshAfter: clRefresh, clTokenCreateTsUTC: clCreated)
    ///Authorized Spotify API client
    static let client = SPClient(device: TestConstants.device, clToken: clToken, clTokenExpires: clExpires, clTokenRefreshAfter: clRefresh, clTokenCreateTsUTC: clCreated, authToken: "", authExpiresInS: 1, username: username, storedCred: [UInt8].init(storedCredential.data(using: .utf8) ?? Data()), authTokenCreateTsUTC: 1)
    
    static let dummyPlayIntentToken: [UInt8] = []
    
    static let dummyRegisterMail = ""
    static let dummyRegisterPassword = ""
    
    fileprivate init() {}
}
