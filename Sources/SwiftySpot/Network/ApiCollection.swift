//
//  ApiLike.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func getCollectionByApi(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, username: String, collectionName: String, paginationToken: String?, limit: UInt, completion: @escaping (_ result: Result<SPPageResponse, SPError>) -> Void) -> URLSessionDataTask? {
    if (limit == 0) {
        completion(.success(SPPageResponse()))
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
    var reqProtobuf = SPCollectionPageRequest()
    reqProtobuf.username = username
    reqProtobuf.setName = collectionName
    reqProtobuf.limit = Int32(limit)
    if let safePageToken = paginationToken {
        reqProtobuf.paginationToken = safePageToken
    }
    guard let req = buildRequest(for: .collection(userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, proto: reqProtobuf)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build collection info request")))
        return nil
    }
    let task = requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            let parsed = try SPPageResponse(serializedBytes: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

func getCollectionDeltaByApi(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, username: String, collectionName: String, lastSyncToken: String, completion: @escaping (_ result: Result<SPDeltaResponse, SPError>) -> Void) -> URLSessionDataTask? {
    if (apHost.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Private back-end is empty. Retrieve access points first")))
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
    var reqProtobuf = SPCollectionDeltaRequest()
    reqProtobuf.username = username
    reqProtobuf.setName = collectionName
    reqProtobuf.lastSyncToken = lastSyncToken
    guard let req = buildRequest(for: .collectionDelta(apHost: apHost, userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, proto: reqProtobuf)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build collection delta request")))
        return nil
    }
    let task = requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            let parsed = try SPDeltaResponse(serializedBytes: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

func collectionUpdateByApi(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, username: String, collectionName: String, updItems: [SPCollectionPageItem], clienUpdateId: String, completion: @escaping (_ result: Result<Bool, SPError>) -> Void) -> URLSessionDataTask? {
    if (updItems.isEmpty) {
        completion(.success(true))
        return nil
    }
    if (apHost.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Private back-end is empty. Retrieve access points first")))
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
    var reqProtobuf = SPCollectionWriteRequest()
    reqProtobuf.username = username
    reqProtobuf.setName = collectionName
    reqProtobuf.items = updItems
    reqProtobuf.clientUpdateID = clienUpdateId
    guard let req = buildRequest(for: .collectionWrite(apHost: apHost, userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, proto: reqProtobuf)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build collection delta request")))
        return nil
    }
    let task = requestSPResponse(req) { result in
        do {
            let response = try result.get()
            let success = response.isSuccessStatusCode
            completion(.success(success))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}
