//
//  UnitSPSHA1.swift
//  SwiftySpot
//
//  Created by developer on 29.10.2023.
//

import Foundation

import XCTest
@testable import SwiftySpot

class UnitSPSHA1: XCTestCase {
    
    func testStandaloneSHA1Impl() {
        let stock = "01234567890abcdf"
        guard let data = stock.data(using: .utf8) else {
            XCTAssertNotNil(nil, "Data from stock string is nil")
            return
        }
        let bytes = [UInt8].init(data)
        let digestHexStr = CryptoUtil.sha1String(buffer: bytes)
        XCTAssert(digestHexStr == "3b9548ccf57fe8e8451bbb793040c61719f22f5a", "Reference digest isn't equal calculated")
    }
}
