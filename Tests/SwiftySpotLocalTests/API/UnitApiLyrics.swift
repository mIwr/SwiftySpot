//
//  UnitApiLyrics.swift
//  Sptf-Tests
//
//  Created by developer on 15.11.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitApiLyrics: XCTestCase {

    func testLocalProtobufResponseParse() {
        guard let url = TestConstants.testBundle.url(forResource: "trackLyricsResponse", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let lyrics = try? Com_Spotify_Lyrics_Endpointretrofit_Proto_ColorLyricsResponse(serializedData: data)
        XCTAssertNotNil(lyrics, "Lyrics is nil")
        XCTAssertNotEqual(lyrics?.lyrics.lines.count, 0, "Incorrect lyrics proto parsing")
    }
    
    func testLocalSyncedJsonResponseParse() {
        let info = SPLyrics.from(json: TestConstants.dummySyncedLyricsInfo, target: SPTypedObj(uri: "uri:123", globalID: []))
        XCTAssertNotNil(info, "Lyrics model parsing error: decode result is nil")
    }
    
    func testLocalUnsyncedJsonResponseParse() {
        let info = SPLyrics.from(json: TestConstants.dummyUnsyncedLyricsInfo, target: SPTypedObj(uri: "uri:123", globalID: []))
        XCTAssertNotNil(info, "Lyrics model parsing error: decode result is nil")
        XCTAssertNotEqual(info?.content.count, 0, "Lyrics lines content array is empty")
    }
}
