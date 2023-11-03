//
//  UnitApiSearch.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitRemoteApiSearch: XCTestCase {
    
    var client = SPClient(device: TestConstants.device)
    
    override func setUp() {
        let data = TestCredentials.storedCredential.data(using: .utf8) ?? Data()
        let storedCred = [UInt8].init(data)
        client = SPClient(device: TestConstants.device, clToken: TestCredentials.clToken, clTokenExpires: TestCredentials.clExpires, clTokenRefreshAfter: TestCredentials.clRefresh, clTokenCreateTsUTC: TestCredentials.clCreated, authToken: "", authExpiresInS: 1, username: TestCredentials.username, storedCred: storedCred, authTokenCreateTsUTC: 1)
    }
    
    func testSearch() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.search(query: "vita", entityTypes: [.artist, .track, .album], limit: 10, pageToken: nil) { result in
            do {
                let searchRes = try result.get()
                XCTAssertTrue(!searchRes.hits.isEmpty, "Search results is empty")
                XCTAssertNotEqual(searchRes.nextPageToken, "", "Next page token is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty search result object: " + error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 20) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testSearchSuggestion() {
        let exp = self.expectation(description: "Request time-out expectation")
        client.searchSuggestion(query: "vita", entityTypes: [.artist, .track, .album], limit: 20) { result in
            do {
                let suggestionRes = try result.get()
                XCTAssertTrue(!suggestionRes.hits.isEmpty, "Search results is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty search result object: " + error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 20) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
}
