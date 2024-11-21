//
//  UnitApiLandingTest.swift
//  SwiftySpot
//
//  Created by Developer on 16.09.2023.
//

import XCTest
@testable import SwiftySpot
import SwiftProtobuf

final class UnitRemoteApiLanding: XCTestCase {
    
    var guestClient: SPClient {
        get { return TestCredentials.guestClient }
    }
    var client: SPClient {
        get { return TestCredentials.client }
    }
    
    func testDacLanding() {
        _getDacLanding(client: client)
    }
    
    func testDacLandingByGuest() {
        _getDacLanding(client: guestClient)
    }
    
    fileprivate func _getDacLanding(client: SPClient) {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.getLandingData { result in
            do {
                let landing = try result.get()
                XCTAssertTrue(!landing.playlists.isEmpty, "Landing playlists array is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty landing object: " + error.localizedDescription)
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
