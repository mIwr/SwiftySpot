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
    
    func testLocalProtobufResponseParse() {
        guard let url = TestConstants.testBundle.url(forResource: "playlistResponse", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let playlist = try? PlaylistInfo(serializedData: data)
        XCTAssertNotNil(playlist, "Playlist is nil")
        XCTAssertNotEqual(playlist?.payload.tracks.count, 0, "Incorrect playlist proto parsing")
    }
}
