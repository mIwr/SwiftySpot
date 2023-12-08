//
//  ApiSignup.swift
//  SwiftySpot
//
//  Created by developer on 10.11.2023.
//

import Foundation

func validateSignupByApi(userAgent: String, clToken: String, os: String, appVer: String, validatorKey: String, password: String?, completion: @escaping (Result<SPSignupValidation, SPError>) -> Void) -> URLSessionDataTask? {
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    guard let req = buildRequest(for: .signupValidate(userAgent: userAgent, clToken: clToken, os: os, appVer: appVer, validatorKey: validatorKey, password: password)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build signup validation request")))
        return nil
    }
    let task = requestJson(req) { result in
        do {
            let json = try result.get()
            let data = try JSONSerialization.data(withJSONObject: json)
            let info: SPSignupValidation = try JSONDecoder().decode(SPSignupValidation.self, from: data)
            completion(.success(info))
        } catch {
            let parsed: SPError = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

func signupByApi(userAgent: String, clToken: String, os: String, appVer: String, clId: String, proto: Com_Spotify_Signup_V2_Proto_CreateAccountRequest, completion: @escaping (Result<Com_Spotify_Signup_V2_Proto_CreateAccountResponse, SPError>) -> Void) -> URLSessionDataTask? {
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    guard let req = buildRequest(for: .signup(userAgent: userAgent, clToken: clToken, os: os, appVer: appVer, clId: clId, proto: proto)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build signup request")))
        return nil
    }
    let task = requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let safeData = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            let parsed = try Com_Spotify_Signup_V2_Proto_CreateAccountResponse(serializedData: safeData)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}
