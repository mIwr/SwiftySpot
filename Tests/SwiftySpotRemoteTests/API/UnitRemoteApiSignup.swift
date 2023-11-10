//
//  UnitRemoteApiSignup.swift
//  Sptf-Tests
//
//  Created by developer on 10.11.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitRemoteApiSignup: XCTestCase {
    
    var client = SPClient(device: TestConstants.device)
    
    override func setUp() {
        client = SPClient(device: TestConstants.device, clToken: TestCredentials.clToken, clTokenExpires: TestCredentials.clExpires, clTokenRefreshAfter: TestCredentials.clRefresh, clTokenCreateTsUTC: TestCredentials.clCreated)
    }

    func testSignupValidate() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.signupValidate { result in
            do {
                let valdiation = try result.get()
                XCTAssertNotEqual(valdiation.countryCode, "", "Parsing error: country code is empty")
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

    func testSignupValidatePass() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.signupValidatePass(TestCredentials.dummyRegisterPassword) { result in
            do {
                let valdiation = try result.get()
                XCTAssertNotEqual(valdiation.countryCode, "", "Parsing error: country code is empty")
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
    
    func testSignup() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.signup(mail: TestCredentials.dummyRegisterMail, password: TestCredentials.dummyRegisterPassword, displayName: "justT@ste", bDate: Date(timeIntervalSince1970: 0), gender: .nonBinary) { result in
            do {
                let signupSession = try result.get()
                XCTAssertNotNil(signupSession.username, "Parsing error: username is empty")
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
