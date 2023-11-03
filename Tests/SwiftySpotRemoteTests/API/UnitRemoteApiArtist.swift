//
//  UnitApiArtist.swift
//  SwiftySpot
//
//  Created by Developer on 22.09.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitRemoteApiArtist: XCTestCase {

    var client = SPClient(device: TestConstants.device)
    
    override func setUp() {
        let data = TestCredentials.storedCredential.data(using: .utf8) ?? Data()
        let storedCred = [UInt8].init(data)
        client = SPClient(device: TestConstants.device, clToken: TestCredentials.clToken, clTokenExpires: TestCredentials.clExpires, clTokenRefreshAfter: TestCredentials.clRefresh, clTokenCreateTsUTC: TestCredentials.clCreated, authToken: "", authExpiresInS: 1, username: TestCredentials.username, storedCred: storedCred, authTokenCreateTsUTC: 1)
    }
    
    func testGetArtistInfo() {
        let exp = self.expectation(description: "Request time-out expectation")
        let uri = SPNavigateUriUtil.generateArtistUri(id: TestConstants.artistId)
        client.getArtistInfo(uri: uri, imgSize: "large") { result in
            do {
                let artist = try result.get()
                XCTAssertNotNil(artist, "Artist is null")
            } catch {
                print(error)
                XCTAssert(false, "Empty artist object: " + error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
}
