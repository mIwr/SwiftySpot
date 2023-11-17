//
//  UnitRemoteApiLyrics.swift
//  Sptf-Tests
//
//  Created by developer on 15.11.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitRemoteApiLyrics: XCTestCase {

    var client = SPClient(device: TestConstants.device)
    
    override func setUp() {
        let data = TestCredentials.storedCredential.data(using: .utf8) ?? Data()
        let storedCred = [UInt8].init(data)
        client = SPClient(device: TestConstants.device, clToken: TestCredentials.clToken, clTokenExpires: TestCredentials.clExpires, clTokenRefreshAfter: TestCredentials.clRefresh, clTokenCreateTsUTC: TestCredentials.clCreated, authToken: "", authExpiresInS: 1, username: TestCredentials.username, storedCred: storedCred, authTokenCreateTsUTC: 1)
    }

    func testGetTrackLyricsInfo() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getTrackLyrics(TestConstants.trackIdWithLyrics) { result in
            do {
                let lyrics = try result.get()
                XCTAssertNotNil(lyrics, "Lyrics not found for track")
                XCTAssertNotEqual(lyrics?.content.count, 0, "Lyrics lines seq is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty lyrics object: " + error.localizedDescription)
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
    
    func testGetTrackReserveLyricsInfo() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getLyricsReserve(obj: SPTypedObj(id: TestConstants.trackIdWithLyrics, entityType: .track)) { result in
            do {
                let lyrics = try result.get()
                XCTAssertNotNil(lyrics, "Lyrics not found for track")
                XCTAssertNotEqual(lyrics?.content.count, 0, "Lyrics lines seq is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty lyrics object: " + error.localizedDescription)
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
