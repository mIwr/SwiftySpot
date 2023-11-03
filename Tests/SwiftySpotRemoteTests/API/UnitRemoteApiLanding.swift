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
    
    var client = SPClient(device: TestConstants.device)
    
    override func setUp() {
        let data = TestCredentials.storedCredential.data(using: .utf8) ?? Data()
        let storedCred = [UInt8].init(data)
        client = SPClient(device: TestConstants.device, clToken: TestCredentials.clToken, clTokenExpires: TestCredentials.clExpires, clTokenRefreshAfter: TestCredentials.clRefresh, clTokenCreateTsUTC: TestCredentials.clCreated, authToken: "", authExpiresInS: 1, username: TestCredentials.username, storedCred: storedCred, authTokenCreateTsUTC: 1)
    }
    
    func testLandingApi() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.getLandingData { result in
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
