//
//  UnitApiPlaylist.swift
//  SwiftySpot
//
//  Created by Developer on 18.09.2023.
//

import XCTest
@testable import SwiftySpot
import SwiftProtobuf

final class UnitApiPlaylist: XCTestCase {
    
    func testLocalPlaylistInfoProtobufResponseParse() {
        guard let url = TestConstants.testBundle.url(forResource: "playlistResponse", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let playlist = try? SPPlaylistInfo(serializedBytes: data)
        XCTAssertNotNil(playlist, "Playlist is nil")
        XCTAssertNotEqual(playlist?.payload.tracks.count, 0, "Incorrect playlist proto parsing")
    }
    
    func testLocalPlaylistFromTrackResponseParse() {
        guard let url = TestConstants.testBundle.url(forResource: "playlistFromTrackResponse", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let playlists = try? SPPlaylistFromSeed(serializedBytes: data)
        XCTAssertNotNil(playlists, "Playlist is nil")
        XCTAssertNotEqual(playlists?.playlists.count, 0, "Incorrect playlist proto parsing")
    }
}
