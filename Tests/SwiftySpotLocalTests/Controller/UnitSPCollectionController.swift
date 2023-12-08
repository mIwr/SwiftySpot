//
//  UnitSPCollectionController.swift
//  Sptf-Tests
//
//  Created by developer on 08.12.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitSPCollectionController: XCTestCase {

    var controller = SPCollectionController(name: "")
    var notifierFired = false
    
    override func setUp() {
        controller = SPCollectionController(name: SPCollectionController.likedTracksAndAlbumsCollectionName, notificationChannel: .SPTrackLikeUpdate)
        notifierFired = false
    }
    
    func testUpdatePage() {
        let page = SPCollectionPage(syncToken: "someToken", nextPageToken: "tk", items: [
            SPCollectionItem(uri: SPNavigateUriUtil.generateTrackUri(id: TestConstants.trackId), addedTs: Int64(Date().timeIntervalSince1970), removed: false),
            SPCollectionItem(uri: SPNavigateUriUtil.generateTrackUri(id: "trackBase62ID"), addedTs: Int64(Date().timeIntervalSince1970), removed: false),
        ], pageSise: 2)
        controller.updateFromPage(page)
        XCTAssertEqual(controller.itemsCount, page.items.count, "Controller items not updated")
        XCTAssertEqual(controller.syncToken, page.syncToken, "Controller sync token not updated")
        XCTAssertEqual(controller.nextPageToken, page.nextPageToken, "Controller next page token not updated")
    }
    
    func testUpdatePageWithDeletedItems() {
        let page = SPCollectionPage(syncToken: "someToken", nextPageToken: "tk", items: [
            SPCollectionItem(uri: SPNavigateUriUtil.generateTrackUri(id: TestConstants.trackId), addedTs: Int64(Date().timeIntervalSince1970), removed: false),
            SPCollectionItem(uri: SPNavigateUriUtil.generateTrackUri(id: "trackBase62ID"), addedTs: Int64(Date().timeIntervalSince1970), removed: true),
        ], pageSise: 2)
        controller.updateFromPage(page)
        XCTAssertEqual(controller.itemsCount, page.items.count - 1, "Controller items not updated")
        XCTAssertEqual(controller.syncToken, page.syncToken, "Controller sync token not updated")
        XCTAssertEqual(controller.nextPageToken, page.nextPageToken, "Controller next page token not updated")
    }
    
    func testDelta() {
        let page = SPCollectionPage(syncToken: "someToken", nextPageToken: "tk", items: [
            SPCollectionItem(uri: SPNavigateUriUtil.generateTrackUri(id: TestConstants.trackId), addedTs: Int64(Date().timeIntervalSince1970), removed: false),
            SPCollectionItem(uri: SPNavigateUriUtil.generateTrackUri(id: "trackBase62ID"), addedTs: Int64(Date().timeIntervalSince1970), removed: false),
        ], pageSise: 2)
        controller.updateFromPage(page)
        let delta = SPCollectionDelta(updatePossible: false, syncToken: "syncTk", items: [
            SPCollectionItem(uri: SPNavigateUriUtil.generateTrackUri(id: "trackID"), addedTs: Int64(Date().timeIntervalSince1970), removed: false),
        ])
        controller.updateFromDelta(delta)
        XCTAssertEqual(controller.itemsCount, page.items.count + delta.items.count, "Controller items not updated")
        XCTAssertEqual(controller.syncToken, delta.syncToken, "Controller sync token not updated")
        XCTAssertEqual(controller.nextPageToken, page.nextPageToken, "Controller next page token not updated")
    }
    
    func testUpdateNotify() {
        let page = SPCollectionPage(syncToken: "someToken", nextPageToken: "tk", items: [
            SPCollectionItem(uri: SPNavigateUriUtil.generateTrackUri(id: TestConstants.trackId), addedTs: Int64(Date().timeIntervalSince1970), removed: false),
            SPCollectionItem(uri: SPNavigateUriUtil.generateTrackUri(id: "trackBase62ID"), addedTs: Int64(Date().timeIntervalSince1970), removed: false),
        ], pageSise: 2)
        NotificationCenter.default.addObserver(self, selector: #selector(onControllerItemUpdate), name: .SPTrackLikeUpdate, object: nil)
        controller.updateFromPage(page)
        let exp = self.expectation(description: "Request time-out expectation")
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            XCTAssertTrue(self.notifierFired, "Controller collection item update notifier not fired")
            NotificationCenter.default.removeObserver(self, name: .SPTrackLikeUpdate, object: nil)
            exp.fulfill()
        }
        waitForExpectations(timeout: 2) { error in
            if let g_error = error
            {
                NotificationCenter.default.removeObserver(self, name: .SPTrackLikeUpdate, object: nil)
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    @objc fileprivate func onControllerItemUpdate(_ notification: Notification) {
        notifierFired = true
    }
}
