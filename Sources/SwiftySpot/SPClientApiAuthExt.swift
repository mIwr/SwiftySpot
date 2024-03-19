//
//  SPClientApiExt.swift
//  SwiftySpot
//
//  Created by Developer on 08.09.2023.
//

import Foundation
import SwiftProtobuf

extension SPClient {
    
    ///Authorize with credentials
    ///- Parameter login: User login: mail, phone number or username
    ///- Parameter password: User account password
    ///- Parameter completion: Authorization status response handler
    ///- Returns: API request session task
    public func auth(login: String, password: String, completion: @escaping (_ result: Result<SPAuthSession, SPError>) -> Void) -> URLSessionDataTask? {
        return safeClReq { safeClToken in
            var clientInfo = SPShortClientInfo()
            clientInfo.clID = self.clientId
            clientInfo.deviceID = self.device.deviceId
            var cred = SPPassword()
            cred.id = login
            cred.password = password
            cred.padding = Data(repeating: 0x1a, count: 28)
            let task = initAuthChallengeByApi(userAgent: self.userAgent, clToken: safeClToken, clientInfo: clientInfo, cred: cred) { result in
                do {
                    let challengeResponse = try result.get()
                    let challenges = challengeResponse.challenge.challenges
                    if (!challengeResponse.hasContext) {
                        completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "No challenge track ID"])))
                        return
                    }
                    if (challenges.isEmpty) {
                        completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "No challenges"])))
                        return
                    }
                    var solution = LoginChallengeAnswerData()
                    let challenge = challenges[0]
                    if case .code? = challenge.method {
                        completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Challenge code not supported"])))
                        return
                    } else if case .hashcash(let hashcashChallenge)? = challenge.method {
                        var answer = LoginChallengeAnswer()
                        answer.hashcash = HashcashAnswer()
                        let now = Date.timeIntervalSinceReferenceDate
                        guard let hashcashSolve = HashCashUtil.solveAuthChallenge(context: challengeResponse.context, prefix: hashcashChallenge.prefix, length: hashcashChallenge.length) else {
                            //Timeout -> restart
                            _ = self.auth(login: login, password: password, completion: completion)
                            return
                        }
                        answer.hashcash.suffix = Data(hashcashSolve)
                        let diffNow = Date.timeIntervalSinceReferenceDate
                        let diff = diffNow - now
                        answer.hashcash.duration = Google_Protobuf_Duration(timeInterval: diff)
                        solution.answers.append(answer)
                    } else {
                        completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Unknown challenge type"])))
                        return
                    }
                    _ = authSolveChallengeByApi(userAgent: self.userAgent, clToken: self.clToken.val, loginContext: challengeResponse.context, clientInfo: clientInfo, answerData: solution, cred: cred) { result in
                        do {
                            let authRes = try result.get()
                            if case .error(let err)? = authRes.response {
                                #if DEBUG
                                print(err)
                                #endif
                                let parsedErr = SPError.badRequest(errCode: err.rawValue, description: String(describing: err))
                                completion(.failure(parsedErr))
                                return
                            }
                            self.authSession = authRes.auth
                            self.authTokenCreateTsUTC = Int64(Date.timeIntervalBetween1970AndReferenceDate + Date.timeIntervalSinceReferenceDate)
                            let session = SPAuthSession(username: self.authSession.username, token: self.authSession.token, storedCred: self.authSession.storedCredential, createTsUTC: self.authTokenCreateTsUTC, expiresInS: self.authSession.expiresInS)
                            self.notifyAuthUpdate(session)
                            completion(.success(session))
                        } catch {
    #if DEBUG
                            print(error)
    #endif
                            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
                            completion(.failure(parsed))
                        }
                    }
                } catch {
    #if DEBUG
                    print(error)
    #endif
                    let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
                    completion(.failure(parsed))
                }
            }
            return task
        }
    }
    
    //Authorize with stored credential
    ///- Parameter login: User login: mail, phone number or username
    ///- Parameter storedCredential: Authorization stored credential. Used for refreshing auth tokens
    ///- Parameter completion: Authorization status response handler
    ///- Returns: API request session task
    public func auth(login: String, storedCredential: String, completion: @escaping (_ result: Result<SPAuthSession, SPError>) -> Void) -> URLSessionDataTask? {
        var session = SPAuthToken()
        session.username = login
        session.storedCredential = storedCredential.data(using: .utf8) ?? Data()
        authSession = session
        return refreshAuth(completion: completion)
    }
    
    ///Drop current authorization (token and refresh credential)
    ///- Parameter dropClSession: Drop active client session
    public func logout(dropClSession: Bool) {
        commitLostAuth()
        if (dropClSession) {
            commitLostClToken()
        }
    }
}
