//
//  UnitSPClientNotifier.swift
//  Sptf-Tests
//
//  Created by Developer on 08.10.2023.
//

import XCTest
@testable import SwiftySpot


class UnitSPClientNotifier: XCTestCase {
    
    var client = SPClient(device: TestConstants.device)
    var clSession: SPClientSession?
    
    override func setUp() {
        client = SPClient(device: TestConstants.device)
        #if _runtime(_ObjC)
        NotificationCenter.default.addObserver(self, selector: #selector(onSessionUpdate), name: .SPSessionUpdate, object: nil)
        #endif
    }
    
    override func tearDown() {
        NotificationCenter.default.removeObserver(self, name: .SPSessionUpdate, object: nil)
        clSession = nil
    }
    
    #if _runtime(_ObjC)
    @objc
    #endif
    fileprivate func onSessionUpdate(_ notification: Notification) {
        let parseRes = notification.tryParseClientSessionUpdate()
        clSession = parseRes.1
    }
    
    func testDummySessionUpdate() {
        let exp = self.expectation(description: "Request time-out expectation")
        let session = SPClientSession(token: "123", createTsUTC: 123, expiresInS: 123, refreshInS: 125)
        client.notifyClSessionUpdate(session)
        #if !_runtime(_ObjC)
        clSession = session
        #endif
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertNotNil(self.clSession, "Client session is nil")
            exp.fulfill()
        }
        waitForExpectations(timeout: 2) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
}
