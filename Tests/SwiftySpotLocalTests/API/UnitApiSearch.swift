//
//  UnitApiSearch.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitApiSearch: XCTestCase {

    func testLocalProtobufTracksResponseParse() {
        guard let url = TestConstants.testBundle.url(forResource: "searchResponse", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let response = try? SPSearchMainViewResponse(serializedBytes: data)
        XCTAssertNotNil(response, "Search response is nil")
        XCTAssertNotEqual(response?.hits.count, 0, "Incorrect search response content proto parsing")
        guard let safeResponse = response else {return}
        let spObj = SPSearchResult.from(protobuf: safeResponse)
        XCTAssertNotEqual(spObj.hits.count, 0, "Incorrect converting from proto")
    }
    
    func testLocalProtobufAutocompleteResponseParse() {
        guard let url = TestConstants.testBundle.url(forResource: "searchAutocompleteResponse", withExtension: "protobuf") else {
            XCTAssertNotNil(nil, "Protobuf asset not found")
            return
        }
        let data = (try? Data(contentsOf: url)) ?? Data()
        let response = try? SPSearchAutocompleteViewResponse(serializedBytes: data)
        XCTAssertNotNil(response, "Search response is nil")
        XCTAssertNotEqual(response?.hits.count, 0, "Incorrect search response content proto parsing")
        guard let safeResponse = response else {return}
        let spObj = SPSearchSuggestionResult.from(protobuf: safeResponse)
        XCTAssertNotEqual(spObj.hits.count, 0, "Incorrect converting from proto")
    }
}
