//
//  UnitApiDownload.swift
//  Sptf-Tests
//
//  Created by developer on 04.06.2024.
//

import XCTest
@testable import SwiftySpot

final class UnitApiDownload: XCTestCase {

    func testLocalResponseDataParse() {
        let data = (try? JSONSerialization.data(withJSONObject: TestConstants.dummySeektableResult)) ?? Data()
        let seektable = try? JSONDecoder().decode(SPWDVSeektable.self, from: data)
        XCTAssertNotNil(seektable, "Seektable model parsing error: decode result is nil")
    }
}
