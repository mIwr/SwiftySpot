//
//  APLirycs.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2023.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import SwiftProtobuf

func getLyricsByApi(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, type: String, id: String, vocalRemove: Bool, syllableSync: Bool, clientLangCode: String, completion: @escaping (_ result: Result<SPColorLyricsResponse?, SPError>) -> Void) -> URLSessionDataTask? {
    if (type.isEmpty || id.isEmpty) {
        completion(.success(nil))
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
    guard let req = buildRequest(for: .lyrics(userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, clId: clId, type: type, id: id, vocalRemove: vocalRemove, syllableSync: syllableSync, clientLangCode: clientLangCode)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build lyrics info request")))
        return nil
    }
    let task = requestSPResponse(req) { result in
        do {
            let response = try result.get()
            if (response.statusCode == 404) {
                completion(.success(nil))
                return
            }
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            let parsed = try SPColorLyricsResponse(serializedBytes: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}
