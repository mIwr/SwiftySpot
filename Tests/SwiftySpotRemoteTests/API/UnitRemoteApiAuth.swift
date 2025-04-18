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
    
    func testGetServerTime() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = getServerTimeByApi(completion: { result in
            do {
                let ts = try result.get()
                XCTAssertTrue(ts > 0, "Invalid server time")
            } catch {
                print(error)
                XCTAssert(false, "Empty server time object: " + error.localizedDescription)
            }
            exp.fulfill()
        })
        waitForExpectations(timeout: 10) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testGuestAuth() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.refreshGuestAuth(completion: { result in
            do {
                let authToken = try result.get()
                XCTAssertTrue(!authToken.token.isEmpty, "Auth token is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty auth token object: " + error.localizedDescription)
            }
            exp.fulfill()
        })
        waitForExpectations(timeout: 10) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testInitAuthWithMagicLink() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.initAuth(login: TestCredentials.login, password: nil, completion: { result in
            do {
                let authInitMeta = try result.get()
                XCTAssertNil(authInitMeta.captcha, "Auth captcha challenge isn't nil")
                XCTAssertFalse(authInitMeta.nonce.isEmpty, "Auth flow nonce is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty auth init meta object: " + error.localizedDescription)
            }
            exp.fulfill()
        })
        waitForExpectations(timeout: 120) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    /*func testAuthWithMagicLink() {
        let exp = self.expectation(description: "Request time-out expectation")
        let magicLink = "https://accounts.spotify.com/login/ott/music#token=one_time_token&passwordToken=another_token&username=account_username&continue=https%3A%2F%2Faccounts.spotify.com%2Fpassword-reset%2Fcomplete%23another_token"
        _ = client.authWithMagicLink(magicLink, authInitMeta: SPAuthInitMeta(nonce: UUID().uuidString.lowercased(), callbackUrl: "https://auth-callback.spotify.com/r/android/music/login", captcha: nil), completion: { result in
            do {
                let auth = try result.get()
                XCTAssertTrue(!auth.token.isEmpty, "Auth token is empty")
                XCTAssertTrue(!auth.storedCred.isEmpty, "Stored credential data is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty auth session object: " + error.localizedDescription)
            }
            exp.fulfill()
        })
        waitForExpectations(timeout: 20) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }*/
    
    func testInitAuthWithPassword() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.initAuth(login: TestCredentials.login, password: TestCredentials.password) { result in
            do {
                let authInitMeta = try result.get()
                XCTAssertNotNil(authInitMeta.captcha, "Auth captcha challenge is nil")
                XCTAssertTrue(authInitMeta.captcha?.url.isEmpty == false, "Auth captcha challenge url is nil or empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty captcha challenge object: " + error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 30) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testAuthWithMailAndStoredCredential() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.auth(login: TestCredentials.login, storedCredential: TestCredentials.storedCredential) { result in
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
    
    func testAuthWithUsernameAndStoredCredential() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.auth(login: TestCredentials.username, storedCredential: TestCredentials.storedCredential) { result in
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
