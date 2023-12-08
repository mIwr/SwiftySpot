//
//  UnitApiMetadata.swift
//  SwiftySpot
//
//  Created by Developer on 21.09.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitRemoteApiMetadata: XCTestCase {
    
    var client = SPClient(device: TestConstants.device)
    
    override func setUp() {
        let data = TestCredentials.storedCredential.data(using: .utf8) ?? Data()
        let storedCred = [UInt8].init(data)
        client = SPClient(device: TestConstants.device, clToken: TestCredentials.clToken, clTokenExpires: TestCredentials.clExpires, clTokenRefreshAfter: TestCredentials.clRefresh, clTokenCreateTsUTC: TestCredentials.clCreated, authToken: "", authExpiresInS: 1, username: TestCredentials.username, storedCred: storedCred, authTokenCreateTsUTC: 1)
    }
    
    func testGetTrackMetadata() {
        let exp = self.expectation(description: "Request time-out expectation")
        let uri = SPNavigateUriUtil.generateTrackUri(id: TestConstants.trackId)
        _ = client.getTracksDetails(trackUris: [uri]) { result in
            do {
                let meta = try result.get()
                XCTAssertTrue(!meta.isEmpty, "Meta is empty")
                XCTAssertTrue(meta.contains(where: { (key: String, value: SPMetadataTrack) in
                    return key == uri
                }), "No target meta object found")
            } catch {
                print(error)
                XCTAssert(false, "Empty metadata object: " + error.localizedDescription)
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
    
    func testGetAlbumMetadata() {
        let exp = self.expectation(description: "Request time-out expectation")
        let uri = SPNavigateUriUtil.generateAlbumUri(id: TestConstants.albumId)
        _ = client.getAlbumsDetails(albumUris: [uri]) { result in
            do {
                let meta = try result.get()
                XCTAssertTrue(!meta.isEmpty, "Meta is empty")
                XCTAssertTrue(meta.contains(where: { (key: String, value: SPMetadataAlbum) in
                    return key == uri
                }), "No target meta object found")
            } catch {
                print(error)
                XCTAssert(false, "Empty metadata object: " + error.localizedDescription)
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
    
    func testGetArtistMetadata() {
        let exp = self.expectation(description: "Request time-out expectation")
        let uri = SPNavigateUriUtil.generateArtistUri(id: TestConstants.artistId)
        _ = client.getArtistsDetails(artistUris: [uri]) { result in
            do {
                let meta = try result.get()
                XCTAssertTrue(!meta.isEmpty, "Meta is empty")
                XCTAssertTrue(meta.contains(where: { (key: String, value: SPMetadataArtist) in
                    return key == uri
                }), "No target meta object found")
            } catch {
                print(error)
                XCTAssert(false, "Empty metadata object: " + error.localizedDescription)
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
