//
//  UnitSPBase32.swift
//  SwiftySpot
//
//  Created by developer on 17.04.2025.
//

import Foundation
import XCTest
@testable import SwiftySpot

final class UnitSPBase32: XCTestCase {
    
    func testEncodeBase32() {
        let testVector: (String, String, String) = ("foobar", "MZXW6YTBOI", "MZXW6YTBOI======")
        guard let safeData = testVector.0.data(using: .utf8) else {
            XCTAssertTrue(false, "Unable get data from string")
            return
        }
        let inputBuff = [UInt8].init(safeData)
        var base32 = SPBase32.encode(inputBuff, padding: false)
        XCTAssertEqual(testVector.1, base32, "Incorrect Base32 encode without padding process")
        base32 = SPBase32.encode(inputBuff, padding: true)
        XCTAssertEqual(testVector.2, base32, "Incorrect Base32 encode with padding process")
    }
}
