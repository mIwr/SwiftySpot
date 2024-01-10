//
//  UnitSPID.swift
//  Sptf-Tests
//
//  Created by developer on 21.12.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitSPID: XCTestCase {
    
    func testIDConversion() {
        let encIdBased = SPID(id: TestConstants.realBase62GID)
        let rawIdBased = SPID(globalID: TestConstants.realGID)
        XCTAssertEqual(encIdBased.globalID, rawIdBased.globalID, "Incorrect Base62 ID -> GID conversion process")
        XCTAssertEqual(rawIdBased.id, encIdBased.id, "Incorrect GID -> Base62 ID conversion process")
    }
    
    func testIDCircleConversion() {
        let encIdBased = SPID(id: TestConstants.realBase62GID)
        let rawIdBased = SPID(globalID: TestConstants.realGID)
        let encIdBasedCircle = SPID(globalID: encIdBased.globalID)
        let rawIdBasedBasedCircle = SPID(id: rawIdBased.id)
        XCTAssertEqual(encIdBasedCircle.id, TestConstants.realBase62GID, "Incorrect Base62 ID - GID -> Base62 ID conversion process")
        XCTAssertEqual(rawIdBasedBasedCircle.globalID, TestConstants.realGID, "Incorrect GID - Base62 ID -> GID conversion process")
    }
}
