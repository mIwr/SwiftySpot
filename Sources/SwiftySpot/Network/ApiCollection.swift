//
//  ApiLike.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

import Foundation

func getCollectionByApi(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, username: String, collectionName: String, paginationToken: String?, limit: UInt, completion: @escaping (_ result: Result<Com_Spotify_Collection2_V2_Proto_PageResponse, SPError>) -> Void) {
    if (limit == 0) {
        completion(.success(Com_Spotify_Collection2_V2_Proto_PageResponse()))
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
    var reqProtobuf = Com_Spotify_Collection2_V2_Proto_PageRequest()
    reqProtobuf.username = username
    reqProtobuf.setName = collectionName
    reqProtobuf.limit = Int32(limit)
    if let safePageToken = paginationToken {
        reqProtobuf.paginationToken = safePageToken
    }
    guard let req: URLRequest = buildRequest(for: .collection(userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, proto: reqProtobuf)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build collection info request")))
        return
    }
    requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            let parsed = try Com_Spotify_Collection2_V2_Proto_PageResponse(serializedData: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
}

func getCollectionDeltaByApi(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, username: String, collectionName: String, lastSyncToken: String, completion: @escaping (_ result: Result<Com_Spotify_Collection2_V2_Proto_DeltaResponse, SPError>) -> Void) {
    if (apHost.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Private back-end is empty. Retrieve access points first")))
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
    var reqProtobuf = Com_Spotify_Collection2_V2_Proto_DeltaRequest()
    reqProtobuf.username = username
    reqProtobuf.setName = collectionName
    reqProtobuf.lastSyncToken = lastSyncToken
    guard let req: URLRequest = buildRequest(for: .collectionDelta(apHost: apHost, userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, proto: reqProtobuf)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build collection delta request")))
        return
    }
    requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            let parsed = try Com_Spotify_Collection2_V2_Proto_DeltaResponse(serializedData: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
}

func collectionUpdateByApi(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, username: String, collectionName: String, updItems: [Com_Spotify_Collection2_V2_Proto_CollectionItem], clienUpdateId: String, completion: @escaping (_ result: Result<Bool, SPError>) -> Void) {
    if (updItems.isEmpty) {
        completion(.success(true))
        return
    }
    if (apHost.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Private back-end is empty. Retrieve access points first")))
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
    var reqProtobuf = Com_Spotify_Collection2_V2_Proto_WriteRequest()
    reqProtobuf.username = username
    reqProtobuf.setName = collectionName
    reqProtobuf.items = updItems
    reqProtobuf.clientUpdateID = clienUpdateId
    guard let req: URLRequest = buildRequest(for: .collectionWrite(apHost: apHost, userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, proto: reqProtobuf)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build collection delta request")))
        return
    }
    requestSPResponse(req) { result in
        do {
            let response = try result.get()
            let success = response.isSuccessStatusCode
            completion(.success(success))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
}
