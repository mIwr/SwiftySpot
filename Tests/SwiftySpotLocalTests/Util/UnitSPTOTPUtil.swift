//
//  UnitTOTPUtil.swift
//  SwiftySpot
//
//  Created by developer on 18.04.2025.
//

import XCTest
@testable import SwiftySpot

class UnitSPTOTPUtil: XCTestCase {
    
    fileprivate static let _testVector: [UInt8] = [0x35, 0x35, 0x30, 0x37, 0x31, 0x34, 0x35, 0x38, 0x35, 0x33, 0x34, 0x38, 0x37, 0x34, 0x39, 0x39, 0x35, 0x39, 0x32, 0x32, 0x34, 0x38, 0x36, 0x33, 0x30, 0x33, 0x32, 0x39, 0x33, 0x34, 0x37]
    
    func testSecretRetrieve() {
        let secret = SPTOTPUtil.retrieveSecret()
        XCTAssertEqual(secret, UnitSPTOTPUtil._testVector, "Incorrect secret retriever")
    }
    
    func testGenerateTOTP() {
        let code = SPTOTPUtil.generate(serverTs: 1744963947, digits: 6, timerInterval: 30)
        XCTAssertEqual(code, "383081", "Invalid TOTP generator")
    }
}
