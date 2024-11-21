//
//  UnitApiArtist.swift
//  SwiftySpot
//
//  Created by Developer on 22.09.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitRemoteApiArtist: XCTestCase {

    var guestClient: SPClient {
        get { return TestCredentials.guestClient }
    }
    var client: SPClient {
        get { return TestCredentials.client }
    }
    
    func testGetArtistInfo() {
        _getArtistInfo(client: client)
    }
    
    func testGetArtistInfoByGuest() {
        _getArtistInfo(client: guestClient)
    }
    
    fileprivate func _getArtistInfo(client: SPClient) {
        let exp = self.expectation(description: "Request time-out expectation")
        let uri = SPNavigateUriUtil.generateArtistUri(id: TestConstants.artistId)
        _ = client.getArtistInfo(uri: uri, imgSize: "large") { result in
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
