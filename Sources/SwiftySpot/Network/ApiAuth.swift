//
//  ApiAuth.swift
//  SwiftySpot
//
//  Created by Developer on 07.09.2023.
//

import Foundation

func getGuestAuthByApi(userAgent: String, os: String, appVer: String, completion: @escaping (_ result: Result<SPGuestWebAuthSession, SPError>) -> Void) -> URLSessionDataTask? {
    guard let req: URLRequest = buildRequest(for: .guestAuth(userAgent: userAgent, os: os, appVer: appVer)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build init auth request")))
        return nil
    }
    let task = requestJson(req) { result in
        do {
            let json = try result.get()
            let data = try JSONSerialization.data(withJSONObject: json)
            let auth: SPGuestWebAuthSession = try JSONDecoder().decode(SPGuestWebAuthSession.self, from: data)
            completion(.success(auth))
        } catch {
            let parsed: SPError = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

func initAuthChallengeByApi(userAgent: String, clToken: String, clientInfo: SPShortClientInfo, cred: SPPassword, completion: @escaping (_ result: Result<SPLoginV3Response, SPError>) -> Void) -> URLSessionDataTask? {
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    var reqProtobuf = SPLoginV3Request()
    reqProtobuf.client = clientInfo
    reqProtobuf.password = cred
    guard let req: URLRequest = buildRequest(for: .auth(userAgent: userAgent, clToken: clToken, proto: reqProtobuf)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build init auth request")))
        return nil
    }
    let task = requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            let parsed = try SPLoginV3Response(serializedBytes: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

func authSolveChallengeByApi(userAgent: String, clToken: String, loginContext: Data, clientInfo: SPShortClientInfo, answerData: SPLoginChallengeAnswerData, cred: SPPassword, completion: @escaping (_ result: Result<SPLoginV3Response, SPError>) -> Void) -> URLSessionDataTask? {
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    if (loginContext.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth track ID is empty. Retrieve auth challenge first")))
        return nil
    }
    var reqProtobuf = SPLoginV3Request()
    reqProtobuf.client = clientInfo
    reqProtobuf.context = loginContext
    reqProtobuf.password = cred
    reqProtobuf.answerData = answerData
    guard let req: URLRequest = buildRequest(for: .auth(userAgent: userAgent, clToken: clToken, proto: reqProtobuf)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build auth request")))
        return nil
    }
    let task = requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            let parsed = try SPLoginV3Response(serializedBytes: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

func refreshAuthByApi(userAgent: String, clToken: String, clientInfo: SPShortClientInfo, stored: SPStoredCredential, completion: @escaping (_ result: Result<SPLoginV3Response, SPError>) -> Void) -> URLSessionDataTask? {
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    if (stored.username.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Username is empty. Auth by another method")))
        return nil
    }
    if (stored.data.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Stored credential is empty. Auth by another method")))
        return nil
    }
    var reqProtobuf = SPLoginV3Request()
    reqProtobuf.client = clientInfo
    reqProtobuf.stored = stored
    guard let req: URLRequest = buildRequest(for: .auth(userAgent: userAgent, clToken: clToken, proto: reqProtobuf)) else {
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
            let parsed = try SPLoginV3Response(serializedBytes: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}
