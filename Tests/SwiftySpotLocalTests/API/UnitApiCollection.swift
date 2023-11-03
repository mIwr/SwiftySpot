//
//  UnitApiCollection.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitApiCollection: XCTestCase {
    
    //ARTISTS
    
    func testLocalProtobufLikedArtistsRequestParse() {
        guard let url = TestConstants.testBundle.url(forResource: "likedArtistsReq", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let pageReq = try? Com_Spotify_Collection2_V2_Proto_PageRequest(serializedData: data)
        XCTAssertNotNil(pageReq, "Info request is nil")
        XCTAssertNotEqual(pageReq?.username, nil, "Incorrect info request proto model")
    }
    
    func testLocalProtobufLikedArtistsResponseParse() {
        guard let url = TestConstants.testBundle.url(forResource: "likedArtistsResponse", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let response = try? Com_Spotify_Collection2_V2_Proto_PageResponse(serializedData: data)
        XCTAssertNotNil(response, "Collection info is nil")
        XCTAssertNotEqual(response?.items.count, 0, "Incorrect collection info proto parsing")
    }
    
    //Incorrect protobuf parse
    /*func testLocalProtobufDislikedArtistsRequestParse() {
        guard let url = TestConstants.testBundle.url(forResource: "dislikedArtistsReq", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let pageReq = try? Com_Spotify_Collection2_V2_Proto_PageRequest(serializedData: data)
        XCTAssertNotNil(pageReq, "Info request is nil")
        XCTAssertNotEqual(pageReq?.username, nil, "Incorrect info request proto model")
    }*/
    
    func testLocalProtobufDislikedArtistsResponseParse() {
        guard let url = TestConstants.testBundle.url(forResource: "dislikedArtistsResponse", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let response = try? Com_Spotify_Collection2_V2_Proto_PageResponse(serializedData: data)
        XCTAssertNotNil(response, "Collection info is nil")
        XCTAssertNotEqual(response?.items.count, 0, "Incorrect collection info proto parsing")
    }
    
    //TRACKS
    
    func testLocalProtobufLikedTracksRequestParse() {
        guard let url = TestConstants.testBundle.url(forResource: "likedTracksReq", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let pageReq = try? Com_Spotify_Collection2_V2_Proto_PageRequest(serializedData: data)
        XCTAssertNotNil(pageReq, "Info request is nil")
        XCTAssertNotEqual(pageReq?.username, nil, "Incorrect info request proto model")
    }
    
    func testLocalProtobufLikedTracksResponseParse() {
        guard let url = TestConstants.testBundle.url(forResource: "likedTracksResponse", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let response = try? Com_Spotify_Collection2_V2_Proto_PageResponse(serializedData: data)
        XCTAssertNotNil(response, "Collection info is nil")
        XCTAssertNotEqual(response?.items.count, 0, "Incorrect collection info proto parsing")
    }
    
    func testLocalProtobufDislikedTracksRequestParse() {
        guard let url = TestConstants.testBundle.url(forResource: "dislikedTracksReq", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let pageReq = try? Com_Spotify_Collection2_V2_Proto_PageRequest(serializedData: data)
        XCTAssertNotNil(pageReq, "Info request is nil")
        XCTAssertNotEqual(pageReq?.username, nil, "Incorrect info request proto model")
    }
    
    func testLocalProtobufDislikedTracksResponseParse() {
        guard let url = TestConstants.testBundle.url(forResource: "dislikedTracksResponse", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let response = try? Com_Spotify_Collection2_V2_Proto_PageResponse(serializedData: data)
        XCTAssertNotNil(response, "Collection info is nil")
        XCTAssertNotEqual(response?.items.count, 0, "Incorrect collection info proto parsing")
    }
}
