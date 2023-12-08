//
//  UnitApiCollection.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitRemoteApiCollection: XCTestCase {

    var client = SPClient(device: TestConstants.device)
    
    override func setUp() {
        let data = TestCredentials.storedCredential.data(using: .utf8) ?? Data()
        let storedCred = [UInt8].init(data)
        client = SPClient(device: TestConstants.device, clToken: TestCredentials.clToken, clTokenExpires: TestCredentials.clExpires, clTokenRefreshAfter: TestCredentials.clRefresh, clTokenCreateTsUTC: TestCredentials.clCreated, authToken: "", authExpiresInS: 1, username: TestCredentials.username, storedCred: storedCred, authTokenCreateTsUTC: 1)
    }
    
    //ARTISTS
    
    func testLikedArtistsCollection() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.getLikedArtists(pageLimit: 100, pageToken: nil) {
            result in
            do {
                let collection = try result.get()
                XCTAssertTrue(collection.pageSize != 0, "Collection page size 0")
                XCTAssertTrue(!collection.syncToken.isEmpty, "Collection sync token is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty collection object: " + error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 15) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testDislikedArtistsCollection() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.getDislikedArtists(pageLimit: 100, pageToken: nil) {
            result in
            do {
                let collection = try result.get()
                XCTAssertTrue(collection.pageSize != 0, "Collection page size 0")
                XCTAssertTrue(!collection.syncToken.isEmpty, "Collection sync token is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty collection object: " + error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 15) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    //TRACKS
    
    func testLikedTracksCollection() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.getLikedTracks(pageLimit: 100, pageToken: nil) {
            result in
            do {
                let collection = try result.get()
                XCTAssertTrue(collection.pageSize != 0, "Collection page size 0")
                XCTAssertTrue(!collection.syncToken.isEmpty, "Collection sync token is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty collection object: " + error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 15) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testDislikedTracksCollection() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.getDislikedTracks(pageLimit: 100, pageToken: nil) {
            result in
            do {
                let collection = try result.get()
                XCTAssertTrue(collection.pageSize != 0, "Collection page size 0")
                XCTAssertTrue(!collection.syncToken.isEmpty, "Collection sync token is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty collection object: " + error.localizedDescription)
            }
            exp.fulfill()
        }
        waitForExpectations(timeout: 15) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
}
