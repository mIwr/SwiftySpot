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
    
    var guestClient: SPClient {
        get { return TestCredentials.guestClient }
    }
    var client: SPClient {
        get { return TestCredentials.client }
    }
    
    func testGetPlaylistInfo() {
        _getPlaylistInfo(client: client)
    }
    
    func testGetPlaylistInfoByGuest() {
        _getPlaylistInfo(client: guestClient)
    }
    
    func testGetPlaylistFromTrack() {
        _getPlaylistFromTrack(client: client)
    }
    
    func testGetPlaylistFromTrackByGuest() {
        _getPlaylistFromTrack(client: guestClient)
    }
    
    fileprivate func _getPlaylistInfo(client: SPClient) {
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
    
    fileprivate func _getPlaylistFromTrack(client: SPClient) {
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.getPlaylistFromTrack(trackId: TestConstants.trackId) { result in
            do {
                let playlists = try result.get()
                XCTAssertNotEqual(playlists.count, 0, "Playlist uri array is empty")
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
