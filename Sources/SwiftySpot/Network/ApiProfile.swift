//
//  ApiProfile.swift
//  SwiftySpot
//
//  Created by Developer on 20.09.2023.
//

import Foundation

func getProfileInfoByApi(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, completion: @escaping (_ result: Result<SPProfile, SPError>) -> Void) -> URLSessionDataTask? {
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    if (authToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth Token is empty. Authorize session first")))
        return nil
    }
    guard let req: URLRequest = buildRequest(for: .profile(userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build profile info request")))
        return nil
    }
    let task = requestJson(req) { result in
        do {
            let json = try result.get()
            let data = try JSONSerialization.data(withJSONObject: json)
            let info: SPProfile = try JSONDecoder().decode(SPProfile.self, from: data)
            completion(.success(info))
        } catch {
            let parsed: SPError = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}
