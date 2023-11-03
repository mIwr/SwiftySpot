//
//  UnitApiProfile.swift
//  SwiftySpot
//
//  Created by Developer on 21.09.2023.
//

import XCTest
@testable import SwiftySpot


final class UnitApiProfile: XCTestCase {
    
    func testLocalResponseDataParse() {
        let data = (try? JSONSerialization.data(withJSONObject: TestConstants.dummyApiProfileInfo)) ?? Data()
        let info = try? JSONDecoder().decode(SPProfile.self, from: data)
        XCTAssertNotNil(info, "Profile model parsing error: decode result is nil")
    }
}
