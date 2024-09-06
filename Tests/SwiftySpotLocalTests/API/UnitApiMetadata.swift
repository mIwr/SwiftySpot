//
//  UnitApiMetadata.swift
//  SwiftySpot
//
//  Created by Developer on 21.09.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitApiMetadata: XCTestCase {
    
    let client = SPClient(device: TestConstants.device)

    func testLocalProtobufTracksRequestParse() {
        guard let url = TestConstants.testBundle.url(forResource: "tracksMetaReq", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let batchReq = try? SPMetaBatchedEntityRequest(serializedBytes: data)
        XCTAssertNotNil(batchReq, "Tracks batched request is nil")
        XCTAssertNotEqual(batchReq?.request.count, 0, "Incorrect generated tracks batched request proto model")
    }
    
    func testLocalProtobufTracksResponseParse() {
        guard let url = TestConstants.testBundle.url(forResource: "tracksMetaResponse", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let response = try? SPMetaBatchedExtensionResponse(serializedBytes: data)
        XCTAssertNotNil(response, "Tracks meta is nil")
        XCTAssertNotEqual(response?.extendedMetadata.count, 0, "Incorrect tracks meta proto parsing")
        guard let safeResponse = response else {return}
        let items = client.parseTracksDetails(response: safeResponse)
        XCTAssertNotEqual(items.count, 0, "Incorrect tracks converting from proto")
    }
    
    func testLocalProtobufAlbumsRequestParse() {
        guard let url = TestConstants.testBundle.url(forResource: "albumsMetaReq", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let batchReq = try? SPMetaBatchedEntityRequest(serializedBytes: data)
        XCTAssertNotNil(batchReq, "Albums batched request is nil")
        XCTAssertNotEqual(batchReq?.request.count, 0, "Incorrect generated albums batched request proto model")
    }
    
    func testLocalProtobufAlbumsResponseParse() {
        guard let url = TestConstants.testBundle.url(forResource: "albumsMetaResponse", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let response = try? SPMetaBatchedExtensionResponse(serializedBytes: data)
        XCTAssertNotNil(response, "Albums meta is nil")
        XCTAssertNotEqual(response?.extendedMetadata.count, 0, "Incorrect albums meta proto parsing")
        guard let safeResponse = response else {return}
        let items = client.parseAlbumsDetails(response: safeResponse)
        XCTAssertNotEqual(items.count, 0, "Incorrect albums converting from proto")
    }
    
    func testLocalProtobufArtistsRequestParse() {
        guard let url = TestConstants.testBundle.url(forResource: "artistsMetaReq", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let batchReq = try? SPMetaBatchedEntityRequest(serializedBytes: data)
        XCTAssertNotNil(batchReq, "Artists batched request is nil")
        XCTAssertNotEqual(batchReq?.request.count, 0, "Incorrect generated artists batched request proto model")
    }
    
    func testLocalProtobufArtistsResponseParse() {
        guard let url = TestConstants.testBundle.url(forResource: "artistsMetaResponse", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let response = try? SPMetaBatchedExtensionResponse(serializedBytes: data)
        XCTAssertNotNil(response, "Artists meta is nil")
        XCTAssertNotEqual(response?.extendedMetadata.count, 0, "Incorrect artists meta proto parsing")
        guard let safeResponse = response else {return}
        let items = client.parseArtistsDetails(response: safeResponse)
        XCTAssertNotEqual(items.count, 0, "Incorrect artists converting from proto")
    }
}
