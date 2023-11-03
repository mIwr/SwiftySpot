//
//  UnitApiAuthTest.swift
//  SwiftySpot
//
//  Created by Developer on 13.09.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitRemoteApiAuth: XCTestCase {
    
    var client = SPClient(device: TestConstants.device)
    
    override func setUp() {
        client = SPClient(device: TestConstants.device, clToken: TestCredentials.clToken, clTokenExpires: TestCredentials.clExpires, clTokenRefreshAfter: TestCredentials.clRefresh, clTokenCreateTsUTC: TestCredentials.clCreated)
    }
    
    func testAuth() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.auth(login: TestCredentials.login, password: TestCredentials.password) { result in
            do {
                let authToken = try result.get()
                XCTAssertTrue(!authToken.token.isEmpty, "Auth token is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty auth token object: " + error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 120) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
}
