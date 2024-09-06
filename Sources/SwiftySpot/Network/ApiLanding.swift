//
//  ApiLanding.swift
//  SwiftySpot
//
//  Created by Developer on 16.09.2023.
//

import Foundation
import SwiftProtobuf

func getLandingByApi(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, clientInfo: SPDacRequest.ClientInfo, facetUri: String, timezone: String, completion: @escaping (_ result: Result<SPDacResponse, SPError>) -> Void) -> URLSessionDataTask? {
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    if (authToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth Token is empty. Authorize session first")))
        return nil
    }
    var reqProtobuf = SPDacRequest()
    reqProtobuf.clientInfo = clientInfo
    reqProtobuf.uri = "dac:home"
    var featureReq = SPDacHomeViewServiceRequest()
    featureReq.facet = facetUri
    featureReq.timezone = timezone
    var anyProtobuf = Google_Protobuf_Any()
    anyProtobuf.value = (try? featureReq.serializedData()) ?? Data()
    reqProtobuf.featureRequest = anyProtobuf
    guard let req: URLRequest = buildRequest(for: .landing(userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, clId: clId, proto: reqProtobuf)) else {
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
            let parsed = try SPDacResponse(serializedBytes: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

