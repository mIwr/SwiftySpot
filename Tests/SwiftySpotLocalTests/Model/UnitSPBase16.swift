//
//  UnitStringUtilTest.swift
//  SwiftySpot
//
//  Created by Developer on 11.09.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitSPBase16: XCTestCase {
    
    func testBytesToHexString() {
        let buff:[UInt8] = [0x7, 0xdf, 0x23, 0xa0, 0xC, 0x56]
        let str = SPBase16.encode(buff)
        XCTAssertEqual(str, "07df23a00c56", "Incorrect bytes to hex convert")
    }
    
    func testHexStringToBytes() {
        let str = "7df23a00c56"
        let buff = SPBase16.decode(str)
        let expected:[UInt8] = [0x7, 0xdf, 0x23, 0xa0, 0xC, 0x56]
        XCTAssertEqual(expected, buff, "Incorrect hex to bytes convert")
    }
}
