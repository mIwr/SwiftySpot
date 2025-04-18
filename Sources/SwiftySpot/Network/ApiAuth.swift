//
//  ApiAuth.swift
//  SwiftySpot
//
//  Created by Developer on 07.09.2023.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

func getServerTimeByApi(completion: @escaping (_ result: Result<Int64, SPError>) -> Void) -> URLSessionDataTask? {
    guard let req = buildRequest(for: .serverTime) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build server time retrieve request")))
        return nil
    }
    let task = requestJson(req) { result in
        do {
            let json = try result.get()
            guard let ts = json["serverTime"] as? Int64 else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Not found serverTime in response"])))
                return
            }
            completion(.success(ts))
        } catch {
            let parsed: SPError = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

func getGuestAuthByApi(userAgent: String, os: String, appVer: String, totp: String, totpVer: UInt8, completion: @escaping (_ result: Result<SPGuestWebAuthSession, SPError>) -> Void) -> URLSessionDataTask? {
    if (totp.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Empty TOTP")))
        return nil
    }
    let nowTs = Int64(Date().timeIntervalSince1970)
    guard let req = buildRequest(for: .guestAuth(userAgent: userAgent, os: os, appVer: appVer, totp: totp, totpVer: totpVer, timestamp: nowTs)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build guest auth request")))
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

func initAuthChallengeByApi(userAgent: String, clToken: String, clientInfo: SPShortClientInfo, cred: SPPassword, nonce: String, callbackUrl: String, locale: String, completion: @escaping (_ result: Result<SPLoginResponse, SPError>) -> Void) -> URLSessionDataTask? {
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    var reqProtobuf = SPLoginRequest()
    reqProtobuf.client = clientInfo
    reqProtobuf.passwordV4 = cred
    var interaction = SPLoginInteraction()
    var finish = SPLoginInteractionFinish()
    finish.unknown1 = 1
    finish.uri = callbackUrl
    finish.nonce = nonce
    finish.unknown2 = 1
    interaction.finish = finish
    var hint = SPLoginInteractionHint()
    hint.uiLocale = locale
    interaction.hint = hint
    let bVal: [UInt8] = [0x1]
    interaction.unknown = Data(bVal)
    reqProtobuf.interaction = interaction
    guard let req = buildRequest(for: .auth(userAgent: userAgent, clToken: clToken, proto: reqProtobuf)) else {
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
            let parsed = try SPLoginResponse(serializedBytes: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

func initAuthMagicLinkByApi(userAgent: String, clToken: String, clId: String, os: String, appVer: String, login: String, deviceId: String, completion: @escaping (_ result: Result<Bool, SPError>) -> Void) -> URLSessionDataTask? {
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    guard let req = buildRequest(for: .initAuthMagicLink(userAgent: userAgent, clToken: clToken, clId: clId, os: os, appVer: appVer, login: login, deviceId: deviceId)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build init auth with magic link request")))
        return nil
    }
    let task = requestData(req) { result in
        do {
            let data = try result.get()
            if (data.isEmpty) {
                return completion(.success(true))
            }
            //TODO monitor another cases (error with json dict, for example)
            return completion(.success(true))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

func authSolveChallengeByApi(userAgent: String, clToken: String, loginContext: Data, interactionNonce: String, callbackUrl: String, clientInfo: SPShortClientInfo, answerData: SPLoginChallengeAnswerData, cred: SPPassword, completion: @escaping (_ result: Result<SPLoginResponse, SPError>) -> Void) -> URLSessionDataTask? {
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    if (loginContext.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth track ID is empty. Retrieve auth challenge first")))
        return nil
    }
    var reqProtobuf = SPLoginRequest()
    reqProtobuf.client = clientInfo
    reqProtobuf.context = loginContext
    reqProtobuf.passwordV4 = cred
    reqProtobuf.answerData = answerData
    var interaction = SPLoginInteraction()
    var finish = SPLoginInteractionFinish()
    finish.unknown1 = 1
    finish.uri = callbackUrl
    finish.nonce = interactionNonce
    finish.unknown2 = 1
    interaction.finish = finish
    let bVal: [UInt8] = [0x1]
    interaction.unknown = Data(bVal)
    reqProtobuf.interaction = interaction
    guard let req = buildRequest(for: .auth(userAgent: userAgent, clToken: clToken, proto: reqProtobuf)) else {
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
            let parsed = try SPLoginResponse(serializedBytes: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

func authApplyMagicLinkByApi(userAgent: String, clToken: String, interactionNonce: String, callbackUrl: String, clientInfo: SPShortClientInfo, oneTimeToken: SPOneTimeToken, completion: @escaping (_ result: Result<SPLoginResponse, SPError>) -> Void) -> URLSessionDataTask? {
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    var reqProtobuf = SPLoginRequest()
    reqProtobuf.client = clientInfo
    reqProtobuf.oneTimeToken = oneTimeToken
    var interaction = SPLoginInteraction()
    var finish = SPLoginInteractionFinish()
    finish.unknown1 = 1
    finish.uri = callbackUrl
    finish.nonce = interactionNonce
    finish.unknown2 = 1
    interaction.finish = finish
    let bVal: [UInt8] = [0x1]
    interaction.unknown = Data(bVal)
    reqProtobuf.interaction = interaction
    guard let req = buildRequest(for: .auth(userAgent: userAgent, clToken: clToken, proto: reqProtobuf)) else {
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
            let parsed = try SPLoginResponse(serializedBytes: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

func refreshAuthByApi(userAgent: String, clToken: String, clientInfo: SPShortClientInfo, stored: SPStoredCredential, completion: @escaping (_ result: Result<SPLoginResponse, SPError>) -> Void) -> URLSessionDataTask? {
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    if (stored.id.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Login is empty. Enter the login (account e-mail, username or phone number) or auth by another method")))
        return nil
    }
    if (stored.data.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Stored credential is empty. Auth by another method")))
        return nil
    }
    var reqProtobuf = SPLoginRequest()
    reqProtobuf.client = clientInfo
    reqProtobuf.stored = stored
    guard let req = buildRequest(for: .auth(userAgent: userAgent, clToken: clToken, proto: reqProtobuf)) else {
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
            let parsed = try SPLoginResponse(serializedBytes: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}
