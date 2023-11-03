//
//  UnitSPClient.swift
//  SwiftySpot
//
//  Created by Developer on 13.09.2023.
//

import XCTest
@testable import SwiftySpot


class UnitSPClient: XCTestCase {
    
    var client = SPClient(device: TestConstants.device)
    
    override func setUp() {
        client = SPClient(device: TestConstants.device)
    }
    
    func testNoClTokenExpirationCheck() {
        let expiryStatus = client.clientTokenExpired
        XCTAssertEqual(expiryStatus, true, "Incorrect client token expiration check")
    }
    
    func testOldClTokenExpirationCheck() {
        let nowTsUTC = Int64(Date.timeIntervalBetween1970AndReferenceDate + Date.timeIntervalSinceReferenceDate)
        client = SPClient(device: TestConstants.device, clToken: "123", clTokenExpires: 180, clTokenRefreshAfter: 240, clTokenCreateTsUTC: nowTsUTC - 500)
        let expiryStatus = client.clientTokenExpired
        XCTAssertEqual(expiryStatus, true, "Incorrect client token expiration check")
    }
    
    func testActualClTokenExpirationCheck() {
        let nowTsUTC = Int64(Date.timeIntervalBetween1970AndReferenceDate + Date.timeIntervalSinceReferenceDate)
        client = SPClient(device: TestConstants.device, clToken: "123", clTokenExpires: 180, clTokenRefreshAfter: 240, clTokenCreateTsUTC: nowTsUTC - 120)
        let expiryStatus = client.clientTokenExpired
        XCTAssertEqual(expiryStatus, false, "Incorrect client token expiration check")
    }
    
    func testNoAuthTokenExpirationCheck() {
        let expiryStatus = client.authTokenExpired
        XCTAssertEqual(expiryStatus, true, "Incorrect auth token expiration check")
    }
    
    func testOldAuthTokenExpirationCheck() {
        let nowTsUTC = Int64(Date.timeIntervalBetween1970AndReferenceDate + Date.timeIntervalSinceReferenceDate)
        client = SPClient(device: TestConstants.device, clToken: "123", clTokenExpires: 180, clTokenRefreshAfter: 240, clTokenCreateTsUTC: nowTsUTC - 500, authToken: "123", authExpiresInS: 120, username: "user", storedCred: [], authTokenCreateTsUTC: nowTsUTC - 360)
        let expiryStatus = client.authTokenExpired
        XCTAssertEqual(expiryStatus, true, "Incorrect auth token expiration check")
    }
    
    func testActualAuthTokenExpirationCheck() {
        let nowTsUTC = Int64(Date.timeIntervalBetween1970AndReferenceDate + Date.timeIntervalSinceReferenceDate)
        client = SPClient(device: TestConstants.device, clToken: "123", clTokenExpires: 180, clTokenRefreshAfter: 240, clTokenCreateTsUTC: nowTsUTC - 120, authToken: "123", authExpiresInS: 120, username: "user", storedCred: [], authTokenCreateTsUTC: nowTsUTC - 60)
        let expiryStatus = client.authTokenExpired
        XCTAssertEqual(expiryStatus, false, "Incorrect auth token expiration check")
    }
}
