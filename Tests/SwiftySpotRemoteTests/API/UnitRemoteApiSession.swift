//
//  UnitApiSessionTest.swift
//  SwiftySpot
//
//  Created by Developer on 11.09.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitRemoteApiSession: XCTestCase {
    
    var guestClient: SPClient {
        get { return TestCredentials.guestClient }
    }
    var client: SPClient {
        get { return TestCredentials.client }
    }
    
    func testRefreshClientToken() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.refreshClientToken { result in
            do {
                let clToken = try result.get()
                XCTAssertTrue(!clToken.val.isEmpty, "Client token is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty client token object: " + error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 60) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testGenerateWebClientToken() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = guestClient.generateWebClientToken { result in
            do {
                let clToken = try result.get()
                XCTAssertTrue(!clToken.val.isEmpty, "Client token is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty client token object: " + error.localizedDescription)
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
