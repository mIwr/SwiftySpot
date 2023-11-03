//
//  ApiLanding.swift
//  SwiftySpot
//
//  Created by Developer on 16.09.2023.
//

import Foundation
import SwiftProtobuf

func getLandingByApi(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, clientInfo: Com_Spotify_Dac_Api_V1_Proto_DacRequest.ClientInfo, facetUri: String, timezone: String, completion: @escaping (_ result: Result<Com_Spotify_Dac_Api_V1_Proto_DacResponse, SPError>) -> Void) {
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return
    }
    if (authToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth Token is empty. Authorize session first")))
        return
    }
    var reqProtobuf = Com_Spotify_Dac_Api_V1_Proto_DacRequest()
    reqProtobuf.clientInfo = clientInfo
    reqProtobuf.uri = "dac:home"
    var featureReq = Com_Spotify_Home_Dac_Viewservice_V1_Proto_HomeViewServiceRequest()
    featureReq.facet = facetUri
    featureReq.timezone = timezone
    var anyProtobuf = Google_Protobuf_Any()
    anyProtobuf.value = (try? featureReq.serializedData()) ?? Data()
    reqProtobuf.featureRequest = anyProtobuf
    guard let req: URLRequest = buildRequest(for: .landing(userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, clId: clId, proto: reqProtobuf)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build refresh auth request")))
        return
    }
    requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            let parsed = try Com_Spotify_Dac_Api_V1_Proto_DacResponse(serializedData: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
}

