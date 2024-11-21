//
//  UnitRemoteApiLyrics.swift
//  Sptf-Tests
//
//  Created by developer on 15.11.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitRemoteApiLyrics: XCTestCase {

    var client: SPClient {
        get { return TestCredentials.client }
    }

    func testGetTrackLyricsInfo() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.getTrackLyrics(TestConstants.trackIdWithLyrics) { result in
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
