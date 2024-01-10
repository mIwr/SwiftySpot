//
//  UnitBase62Util.swift
//  Sptf-Tests
//
//  Created by developer on 30.10.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitSPBase62: XCTestCase {
    
    func testEncodeBase62() {
        let stock: UInt128 = UInt128("190726711456610392119944153982734811176", radix: 10) ?? 0
        let base62 = SPBase62.encode(num: stock)
        XCTAssertEqual(TestConstants.artistId, base62, "Incorrect Base62 decode process")
    }
    
    func testDecodeBase62() {
        let str = TestConstants.artistId
        let num = SPBase62.decode(string: str)
        let expected: UInt128 = UInt128("190726711456610392119944153982734811176", radix: 10) ?? 0
        XCTAssertEqual(expected, num, "Incorrect Base62 decode process")
    }
    
    func testFullCycleEncodeDecodeBase62() {
        let str = TestConstants.artistId
        let stock: UInt128 = UInt128("190726711456610392119944153982734811176", radix: 10) ?? 0
        let num = SPBase62.decode(string: str)
        let checkStr = SPBase62.encode(num: num)
        let checkNum = SPBase62.decode(string: str)
        XCTAssertEqual(str, checkStr, "Incorrect Base62 decode op")
        XCTAssertEqual(stock, checkNum, "Incorrect Base62 re-encode from decoded value op")
    }
}
