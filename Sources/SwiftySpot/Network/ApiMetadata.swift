//
//  ApiMetadata.swift
//  SwiftySpot
//
//  Created by Developer on 19.09.2023.
//

import Foundation
import SwiftProtobuf

func getMetadataByApi(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, header: Com_Spotify_Extendedmetadata_Proto_BatchedEntityRequestHeader, items: [Com_Spotify_Extendedmetadata_Proto_EntityRequest], completion: @escaping (_ result: Result<Com_Spotify_Extendedmetadata_Proto_BatchedExtensionResponse, SPError>) -> Void) {
    if (items.isEmpty) {
        let emptyRes = Com_Spotify_Extendedmetadata_Proto_BatchedExtensionResponse()
        completion(.success(emptyRes))
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
    var reqProtobuf = Com_Spotify_Extendedmetadata_Proto_BatchedEntityRequest()
    reqProtobuf.header = header
    reqProtobuf.request = items
    guard let req: URLRequest = buildRequest(for: .metadata(apHost: apHost, userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, proto: reqProtobuf)) else {
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
            let parsed = try Com_Spotify_Extendedmetadata_Proto_BatchedExtensionResponse(serializedData: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
}
