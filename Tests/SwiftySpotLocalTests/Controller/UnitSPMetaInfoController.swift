//
//  UnitSPMetaInfoController.swift
//  Sptf-Tests
//
//  Created by developer on 08.12.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitSPMetaInfoController: XCTestCase {
    
    var controller = SPMetaInfoController<SPTypedObj>(initItems: [:], keyValidator: {uri in return true}, updateItemNotificationBuilder: {item in return Notification(name: .SPTrackMetaUpdate)})
    var notifierFired = false

    override func setUp() {
        controller = SPMetaInfoController<SPTypedObj>(initItems: [:], keyValidator: {uri in return SPNavigateUriUtil.validateTrackUri(uri)}, updateItemNotificationBuilder: {item in return Notification(name: .SPTrackMetaUpdate)})
        notifierFired = false
    }
    
    func testUpdateBySingle() {
        let updItem = SPTypedObj(uri: SPNavigateUriUtil.generateTrackUri(id: TestConstants.trackId), globalID: [])
        controller.update([
            updItem.uri: updItem
        ])
        XCTAssertEqual(controller.items.count, 1, "Controller collection not updated")
    }
    
    func testUpdateByMultiple() {
        let updItems = [
            SPTypedObj(uri: SPNavigateUriUtil.generateTrackUri(id: TestConstants.trackId), globalID: []),
            SPTypedObj(uri: SPNavigateUriUtil.generateTrackUri(id: "someBase62ID"), globalID: [])
        ]
        controller.update([
            updItems[0].uri: updItems[0],
            updItems[1].uri: updItems[1],
        ])
        XCTAssertEqual(controller.items.count, 2, "Controller collection not updated")
    }
    
    func testUpdateByDuplicates() {
        let updItem = SPTypedObj(uri: SPNavigateUriUtil.generateTrackUri(id: TestConstants.trackId), globalID: [])
        controller.update([
            updItem.uri: updItem
        ])
        XCTAssertEqual(controller.items.count, 1, "Controller collection not updated")
        controller.update([
            updItem.uri: updItem
        ])
        XCTAssertEqual(controller.items.count, 1, "Controller collection not updated")
    }
    
    func testUpdateNotify() {
        let updItem = SPTypedObj(uri: SPNavigateUriUtil.generateTrackUri(id: TestConstants.trackId), globalID: [])
        NotificationCenter.default.addObserver(self, selector: #selector(onControllerItemUpdate), name: .SPTrackMetaUpdate, object: nil)
        let exp = self.expectation(description: "Request time-out expectation")
        controller.update([
            updItem.uri: updItem
        ])
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.notifierFired, "Controller collection item update notifier not fired")
            NotificationCenter.default.removeObserver(self, name: .SPTrackMetaUpdate, object: nil)
            exp.fulfill()
        }
        waitForExpectations(timeout: 2) { error in
            if let g_error = error
            {
                NotificationCenter.default.removeObserver(self, name: .SPTrackMetaUpdate, object: nil)
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    @objc fileprivate func onControllerItemUpdate(_ notification: Notification) {
        notifierFired = true
    }
}
