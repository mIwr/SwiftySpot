//
//  UnitApiSearch.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitRemoteApiSearch: XCTestCase {
    
    var guestClient: SPClient {
        get { return TestCredentials.guestClient }
    }
    var client: SPClient {
        get { return TestCredentials.client }
    }
    
    func testSearch() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.search(query: "vita", entityTypes: [.artist, .track, .album], limit: 10, pageToken: nil) { result in
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
    
    func testWebSearch() {
        _webSearch(client: client)
    }
    
    func testWebSearchByGuest() {
        _webSearch(client: guestClient)
    }
    
    func testSearchSuggestion() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.searchSuggestion(query: "vita", entityTypes: [.artist, .track, .album], limit: 20) { result in
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
    
    fileprivate func _webSearch(client: SPClient) {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.webSearch(query: "vita", entityTypes: [.artist, .track, .album], limit: 10, offset: nil) { result in
            do {
                let searchRes = try result.get()
                XCTAssertTrue(!searchRes.tracks.isEmpty || !searchRes.albums.isEmpty || !searchRes.artists.isEmpty, "Search results is empty")
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
