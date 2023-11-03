//
//  UnitApiLandingTest.swift
//  SwiftySpot
//
//  Created by Developer on 16.09.2023.
//

import XCTest
@testable import SwiftySpot
import SwiftProtobuf

final class UnitApiLanding: XCTestCase {
    
    let client = SPClient(device: TestConstants.device)
    
    func testLocalProtobufParse() {
        guard let url = TestConstants.testBundle.url(forResource: "landingResponse", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let landing = (try? Com_Spotify_Dac_Api_V1_Proto_DacResponse(serializedData: data)) ?? Com_Spotify_Dac_Api_V1_Proto_DacResponse()
        let playlists = client.extractPlaylistsFromDac(landing)
        XCTAssertNotEqual(playlists.count, 0, "Incorrect landing playlist parse")
    }
}
