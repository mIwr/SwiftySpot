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
        let landing = (try? SPDacResponse(serializedBytes: data)) ?? SPDacResponse()
        let recognized = client.extractPlaylistsFromDac(landing)
        XCTAssertNotEqual(recognized.userMixes.count, 0, "Incorrect landing user playlists parse")
        XCTAssertNotEqual(recognized.radio.count, 0, "Incorrect landing radio playlists parse")
        XCTAssertNotEqual(recognized.playlists.count, 0, "Incorrect landing playlists parse")
    }
}
