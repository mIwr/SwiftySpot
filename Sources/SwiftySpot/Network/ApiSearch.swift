//
//  ApiSearch.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

import Foundation

func searchSuggestionByApi(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, reqId: UUID, query: String, catalogue: String, locale: String, entityTypes: [String], ts: Int64, onDemandSets: Bool, limit: UInt, completion: @escaping (_ result: Result<SPSearchAutocompleteViewResponse, SPError>) -> Void) -> URLSessionDataTask? {
    if (query.isEmpty || limit == 0) {
        completion(.success(SPSearchAutocompleteViewResponse()))
        return nil
    }
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    if (authToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth Token is empty. Authorize session first")))
        return nil
    }
    guard let req: URLRequest = buildRequest(for: .searchSuggestion(userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, clId: clId, reqId: reqId, query: query, catalogue: catalogue, locale: locale, entityTypes: entityTypes, ts: ts, onDemandSets: onDemandSets, limit: limit)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build search suggestion request")))
        return nil
    }
    let task = requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            let parsed = try SPSearchAutocompleteViewResponse(serializedBytes: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

func searchByApi(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, reqId: UUID, query: String, catalogue: String, locale: String, entityTypes: [String], ts: Int64, onDemandSets: Bool, limit: UInt, pageToken: String, completion: @escaping (_ result: Result<SPSearchMainViewResponse, SPError>) -> Void) -> URLSessionDataTask? {
    if (query.isEmpty || limit == 0) {
        completion(.success(SPSearchMainViewResponse()))
        return nil
    }
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    if (authToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth Token is empty. Authorize session first")))
        return nil
    }
    guard let req: URLRequest = buildRequest(for: .search(userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, clId: clId, reqId: reqId, query: query, catalogue: catalogue, locale: locale, entityTypes: entityTypes, ts: ts, onDemandSets: onDemandSets, limit: limit, pageToken: pageToken)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build search request")))
        return nil
    }
    let task = requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            let parsed = try SPSearchMainViewResponse(serializedBytes: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

func webSearchByApi(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, query: String, opName: String, opQueryHashHexString: String, limit: UInt, offset: UInt, completion: @escaping (_ result: Result<SPWebSearchResult, SPError>) -> Void) -> URLSessionDataTask? {
    if (query.isEmpty || limit == 0) {
        completion(.success(SPWebSearchResult()))
        return nil
    }
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    if (authToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth Token is empty. Authorize session first")))
        return nil
    }
    guard let req: URLRequest = buildRequest(for: .webSearch(userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, query: query, opName: opName, opQueryHashHexString: opQueryHashHexString, limit: limit, offset: offset)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build search request")))
        return nil
    }
    let task = requestJson(req) { result in
        do {
            let dict = try result.get()
            let data = try JSONSerialization.data(withJSONObject: dict)
            let searchResWrapper: SPWebSearchResultWrapper = try JSONDecoder().decode(SPWebSearchResultWrapper.self, from: data)
            completion(.success(searchResWrapper.data.searchV2))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}
