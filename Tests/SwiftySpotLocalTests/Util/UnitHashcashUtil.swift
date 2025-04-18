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
        SPHashCashUtil.solveClTokenChallengeAsync(prefix: TestConstants.clTokenHashcashPrefix.data(using: .utf8) ?? Data(), length: TestConstants.clTokenHashcashLength) { hashcash in
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
        SPHashCashUtil.solveClTokenChallengeAsync(prefix: TestConstants.hardClTokenHashcashPrefix.data(using: .utf8) ?? Data(), length: TestConstants.hardClTokenHashcashLength) { hashcash in
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
        let contextBytes = SPBase16.decode(TestConstants.authContextHex)
        let context = Data(contextBytes)
        let prefixBytes = SPBase16.decode(TestConstants.authHashcashPrefixHex)
        let prefix = Data(prefixBytes)
        
        guard let solution = SPHashCashUtil.solveAuthChallenge(context: context, prefix: prefix, length: TestConstants.authHashcashLength) else {
            XCTAssertNotNil(nil, "Hashcash solution is nil")
            return
        }
        let solutionHex = SPBase16.encode(solution).uppercased()
        let expected = TestConstants.authHashcashAnswerHex.uppercased()
        XCTAssertEqual(solutionHex, expected, "Incorrect auth hashcash solve process")
    }
}
