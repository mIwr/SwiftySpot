//
//  UnitApiSignup.swift
//  Sptf-Tests
//
//  Created by developer on 10.11.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitApiSignup: XCTestCase {
    
    func testLocalResponseDataParse() {
        let data = (try? JSONSerialization.data(withJSONObject: TestConstants.dummyApiValidateInfo)) ?? Data()
        let info = try? JSONDecoder().decode(SPSignupValidation.self, from: data)
        XCTAssertNotNil(info, "Signup validation model parsing error: decode result is nil")
    }
    
}
