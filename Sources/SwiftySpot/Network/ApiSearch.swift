//
//  ApiSearch.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

import Foundation

func searchSuggestionByApi(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, reqId: UUID, query: String, catalogue: String, locale: String, entityTypes: [String], ts: Int64, onDemandSets: Bool, limit: UInt, completion: @escaping (_ result: Result<Com_Spotify_Searchview_Proto_AutocompleteViewResponse, SPError>) -> Void) {
    if (query.isEmpty || limit == 0) {
        completion(.success(Com_Spotify_Searchview_Proto_AutocompleteViewResponse()))
        return
    }
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return
    }
    if (authToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth Token is empty. Authorize session first")))
        return
    }
    guard let req: URLRequest = buildRequest(for: .searchSuggestion(userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, clId: clId, reqId: reqId, query: query, catalogue: catalogue, locale: locale, entityTypes: entityTypes, ts: ts, onDemandSets: onDemandSets, limit: limit)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build search suggestion request")))
        return
    }
    requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            let parsed = try Com_Spotify_Searchview_Proto_AutocompleteViewResponse(serializedData: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
}

func searchByApi(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, reqId: UUID, query: String, catalogue: String, locale: String, entityTypes: [String], ts: Int64, onDemandSets: Bool, limit: UInt, pageToken: String, completion: @escaping (_ result: Result<Com_Spotify_Searchview_Proto_MainViewResponse, SPError>) -> Void) {
    if (query.isEmpty || limit == 0) {
        completion(.success(Com_Spotify_Searchview_Proto_MainViewResponse()))
        return
    }
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return
    }
    if (authToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth Token is empty. Authorize session first")))
        return
    }
    guard let req: URLRequest = buildRequest(for: .search(userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, clId: clId, reqId: reqId, query: query, catalogue: catalogue, locale: locale, entityTypes: entityTypes, ts: ts, onDemandSets: onDemandSets, limit: limit, pageToken: pageToken)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build search request")))
        return
    }
    requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            let parsed = try Com_Spotify_Searchview_Proto_MainViewResponse(serializedData: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
}
