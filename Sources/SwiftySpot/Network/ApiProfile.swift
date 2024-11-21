//
//  ApiProfile.swift
//  SwiftySpot
//
//  Created by Developer on 20.09.2023.
//

import Foundation

func getWebProfileInfoByApi(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, completion: @escaping (_ result: Result<SPProfile, SPError>) -> Void) -> URLSessionDataTask? {
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    if (authToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth Token is empty. Authorize session first")))
        return nil
    }
    guard let req: URLRequest = buildRequest(for: .webProfile(userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer)) else {
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

func getWebProfileCustomByApi(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, username: String, completion: @escaping (_ result: Result<[String: Any], SPError>) -> Void) -> URLSessionDataTask? {
    if (authToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth Token is empty. Authorize session first")))
        return nil
    }
    if (username.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Username is empty")))
        return nil
    }
    guard let req: URLRequest = buildRequest(for: .webProfileCustom(userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, username: username)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build profile info request")))
        return nil
    }
    let task = requestJson(req) { result in
        do {
            let json = try result.get()
            completion(.success(json))
        } catch {
            let parsed: SPError = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

func getWebProfileCustom2ByApi(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, username: String, completion: @escaping (_ result: Result<SPWebProfileResponse, SPError>) -> Void) -> URLSessionDataTask? {
    if (authToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth Token is empty. Authorize session first")))
        return nil
    }
    if (username.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Username is empty")))
        return nil
    }
    guard let req: URLRequest = buildRequest(for: .webProfileCustom2(userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, username: username)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build profile info request")))
        return nil
    }
    let task = requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            let parsed = try SPWebProfileResponse(serializedBytes: data)
            completion(.success(parsed))
        } catch {
            let parsed: SPError = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

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
