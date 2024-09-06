//
//  ApiSession.swift
//  SwiftySpot
//
//  Created by Developer on 11.09.2023.
//

import Foundation

func initSessionChallengeByApi(userAgent: String, initData: SPClientInfo, completion: @escaping (_ result: Result<SPChallengesData, SPError>) -> Void) -> URLSessionDataTask? {
    var reqProtobuf = SPClientTokenRequest()
    reqProtobuf.type = .requestClientDataRequest
    reqProtobuf.client = initData
    guard let req: URLRequest = buildRequest(for: .clToken(userAgent: userAgent, proto: reqProtobuf)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build init session request")))
        return nil
    }
    let task = requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            guard let parsed = try? SPClientTokenResponse(serializedBytes: data) else {
                let badReq = try SPClientTokenBadRequest(serializedBytes: data)
                let err = SPError.badRequest(errCode: response.statusCode, description: badReq.errMsg)
                completion(.failure(err))
                return
            }
            completion(.success(parsed.challenges))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

func initSessionSolveChallengeByApi(userAgent: String, answerData: SPChallengeAnswerData, completion: @escaping (_ result: Result<SPClientToken, SPError>) -> Void) -> URLSessionDataTask? {
    var reqProtobuf = SPClientTokenRequest()
    reqProtobuf.type = .requestChallengeAnswersRequest
    reqProtobuf.answerData = answerData
    guard let req: URLRequest = buildRequest(for: .clToken(userAgent: userAgent, proto: reqProtobuf)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build solve challenge request")))
        return nil
    }
    let task = requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            if (data.isEmpty) {
                let err = SPError.badResponseData(errCode: response.statusCode, data: ["description": "Empty payload response"])
                completion(.failure(err))
                return
            }
            guard let parsed = try? SPClientTokenResponse(serializedBytes: data) else {
                let badReq = try SPClientTokenBadRequest(serializedBytes: data)
                let err = SPError.badRequest(errCode: response.statusCode, description: badReq.errMsg)
                completion(.failure(err))
                return
            }
            completion(.success(parsed.token))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

func getAccessPointsByApi(clToken: String?, completion: @escaping (_ result: Result<SPAccessPoint, SPError>) -> Void) -> URLSessionDataTask? {
    guard let req: URLRequest = buildRequest(for: .acessPoints(clToken: clToken)) else {
        completion(.failure(.badRequest(errCode: -1, description: "Unable to build access points retrieve request")))
        return nil
    }
    let task = requestJson(req) { result in
        do {
            let json = try result.get()
            let data = try JSONSerialization.data(withJSONObject: json)
            let queue: SPAccessPoint = try JSONDecoder().decode(SPAccessPoint.self, from: data)
            completion(.success(queue))
        } catch {
            let parsed: SPError = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}
