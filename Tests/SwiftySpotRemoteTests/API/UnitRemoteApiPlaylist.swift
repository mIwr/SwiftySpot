//
//  UnitApiPlaylist.swift
//  SwiftySpot
//
//  Created by Developer on 18.09.2023.
//

import XCTest
@testable import SwiftySpot
import SwiftProtobuf

final class UnitRemoteApiPlaylist: XCTestCase {
    
    var client = SPClient(device: TestConstants.device)
    
    override func setUp() {
        let data = TestCredentials.storedCredential.data(using: .utf8) ?? Data()
        let storedCred = [UInt8].init(data)
        client = SPClient(device: TestConstants.device, clToken: TestCredentials.clToken, clTokenExpires: TestCredentials.clExpires, clTokenRefreshAfter: TestCredentials.clRefresh, clTokenCreateTsUTC: TestCredentials.clCreated, authToken: "", authExpiresInS: 1, username: TestCredentials.username, storedCred: storedCred, authTokenCreateTsUTC: 1)
    }
    
    func testGetPlaylistInfo() {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.getPlaylistInfo(id: TestConstants.playlistId) { result in
            do {
                let playlist = try result.get()
                XCTAssertNotEqual(playlist.name, "", "Playlist name is empty. Possible whole instance is empty")
            } catch {
                print(error)
                XCTAssert(false, "Empty playlist object: " + error.localizedDescription)
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
