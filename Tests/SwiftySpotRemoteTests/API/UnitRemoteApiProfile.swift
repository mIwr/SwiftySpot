//
//  UnitApiProfile.swift
//  SwiftySpot
//
//  Created by Developer on 21.09.2023.
//

import XCTest
@testable import SwiftySpot


final class UnitRemoteApiProfile: XCTestCase {

    var client = SPClient(device: TestConstants.device)
    
    override func setUp() {
        let data = TestCredentials.storedCredential.data(using: .utf8) ?? Data()
        let storedCred = [UInt8].init(data)
        client = SPClient(device: TestConstants.device, clToken: TestCredentials.clToken, clTokenExpires: TestCredentials.clExpires, clTokenRefreshAfter: TestCredentials.clRefresh, clTokenCreateTsUTC: TestCredentials.clCreated, authToken: "", authExpiresInS: 1, username: TestCredentials.username, storedCred: storedCred, authTokenCreateTsUTC: 1)
    }
    
    func testGetAcessPoints() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.getAPs { result in
            do {
                let ap = try result.get()
                XCTAssertTrue(!ap.spclient.isEmpty, "spclient aps array is empty")
                XCTAssertNotNil(self.client.spclientAp, "Not saved spclient ap to client data")
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

    func testGetProfileInfo() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.getProfileInfo { result in
            do {
                let profile = try result.get()
                XCTAssertNotEqual(profile.username, "", "Parsing error: username is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty profile object: " + error.localizedDescription)
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
    
    func testGetWebProfileInfo() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.getWebProfileInfo { result in
            do {
                let profile = try result.get()
                XCTAssertNotEqual(profile.username, "", "Parsing error: username is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty profile object: " + error.localizedDescription)
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
    
    func testGetWebProfileInfoReserve() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.getWebProfileInfoReserve { result in
            do {
                let profile = try result.get()
                XCTAssertNotEqual(profile.username, "", "Parsing error: username is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty profile object: " + error.localizedDescription)
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
