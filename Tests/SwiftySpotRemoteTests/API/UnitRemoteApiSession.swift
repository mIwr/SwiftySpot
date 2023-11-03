//
//  UnitApiSessionTest.swift
//  SwiftySpot
//
//  Created by Developer on 11.09.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitRemoteApiSession: XCTestCase {
    
    var client = SPClient(device: TestConstants.device)
    
    func testRefreshClientToken() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.refreshClientToken { result in
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
}
