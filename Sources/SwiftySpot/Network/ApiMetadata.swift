//
//  ApiMetadata.swift
//  SwiftySpot
//
//  Created by Developer on 19.09.2023.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import SwiftProtobuf

func getMetadataByApi(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, header: SPMetaBatchedEntityRequestHeader, items: [SPMetaEntityRequest], completion: @escaping (_ result: Result<SPMetaBatchedExtensionResponse, SPError>) -> Void) -> URLSessionDataTask? {
    if (items.isEmpty) {
        let emptyRes = SPMetaBatchedExtensionResponse()
        completion(.success(emptyRes))
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
    var reqProtobuf = SPMetaBatchedEntityRequest()
    reqProtobuf.header = header
    reqProtobuf.request = items
    guard let req = buildRequest(for: .metadata(apHost: apHost, userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, proto: reqProtobuf)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build refresh auth request")))
        return nil
    }
    let task = requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            let parsed = try SPMetaBatchedExtensionResponse(serializedBytes: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}
