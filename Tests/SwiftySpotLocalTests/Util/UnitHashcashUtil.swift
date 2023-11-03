//
//  UnitHashcashUtil.swift
//  SwiftySpot
//
//  Created by Developer on 11.09.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitHashcashUtil: XCTestCase {
    
    func testClTokenHashcashSolve() {
        let exp = self.expectation(description: "Request time-out expectation")
        HashCashUtil.solveClTokenChallengeAsync(prefix: TestConstants.clTokenHashcashPrefix, length: TestConstants.clTokenHashcashLength) { hashcash in
            XCTAssertNotNil(hashcash, "Hashcash solution is nil")
            XCTAssertEqual(hashcash?.uppercased(), TestConstants.clTokenHashcashAnswer, "Incorrect client token hashcash solve process")
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testHardClTokenHashcashSolve() {
        let exp = self.expectation(description: "Request time-out expectation")
        HashCashUtil.solveClTokenChallengeAsync(prefix: TestConstants.hardClTokenHashcashPrefix, length: TestConstants.hardClTokenHashcashLength) { hashcash in
            XCTAssertNotNil(hashcash, "Hashcash solution is nil")
            XCTAssertEqual(hashcash?.uppercased(), TestConstants.hardClTokenHashcashAnswer, "Incorrect client token hashcash solve process")
            exp.fulfill()
        }
        waitForExpectations(timeout: 10) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testAuthHashcashSolve() {
        let contextBytes = StringUtil.hexStringToBytes(TestConstants.authContextHex)
        let context = Data(contextBytes)
        let prefixBytes = StringUtil.hexStringToBytes(TestConstants.authHashcashPrefixHex)
        let prefix = Data(prefixBytes)
        
        guard let solution = HashCashUtil.solveAuthChallenge(context: context, prefix: prefix, length: TestConstants.authHashcashLength) else {
            XCTAssertNotNil(nil, "Hashcash solution is nil")
            return
        }
        let solutionHex = StringUtil.bytesToHexString(solution).uppercased()
        let expected = TestConstants.authHashcashAnswerHex.uppercased()
        XCTAssertEqual(solutionHex, expected, "Incorrect auth hashcash solve process")
    }
}
