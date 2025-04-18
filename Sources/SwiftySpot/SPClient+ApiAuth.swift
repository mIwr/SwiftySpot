//
//  SPClientApiExt.swift
//  SwiftySpot
//
//  Created by Developer on 08.09.2023.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import SwiftProtobuf

extension SPClient {
    
    ///Authorize with no credentials (guest access)
    ///- Parameter completion: Authorization status response handler
    ///- Returns: API request session task
    func refreshGuestAuth(completion: @escaping (_ result: Result<SPAuthSession, SPError>) -> Void) -> URLSessionDataTask? {
        return getServerTimeByApi { result in
            do {
                let serverTs = try result.get()
                let totp = SPTOTPUtil.generate(serverTs: serverTs)
                if (totp.isEmpty) {
                    completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Empty generated TOTP")))
                    return
                }
                let totpVer: UInt8 = 5
                _ = getGuestAuthByApi(userAgent: self.webUserAgent, os: SPConstants.webPlatform, appVer: self.webAppVersionCode, totp: totp, totpVer: totpVer) { result in
                    do {
                        let authRes = try result.get()
                        let session = SPAuthSession.from(guestAuth: authRes)
                        self.guestAuthSession = session
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
    }
    
    ///Initialize authorization flow with credentials
    ///- Parameter login: User login: mail, phone number or username
    ///- Parameter password: User account password. Optional. If not provided, the magic link flow will be initiated (sent auth link to account mail)
    ///- Parameter completion: Authorization status response handler
    ///- Returns: API request session task
    public func initAuth(login: String, password: String?, completion: @escaping (_ result: Result<SPAuthInitMeta, SPError>) -> Void) -> URLSessionDataTask? {
        return safeClReq { safeClToken in
            var callbackUrl = "https://auth-callback.spotify.com/r/android/music/login"
            if (self.device.iOS) {
                callbackUrl = "https://auth-callback.spotify.com/r/ios/music/login"
            }
            let nonce = UUID().uuidString.lowercased()
            guard let safePassword = password else {
                return initAuthMagicLinkByApi(userAgent: self.userAgent, clToken: safeClToken, clId: self.clientId, os: self.device.os, appVer: self.appVersionCode, login: login, deviceId: self.device.deviceId) { result in
                    do {
                        _ = try result.get()
                        completion(.success(SPAuthInitMeta(nonce: nonce, callbackUrl: callbackUrl, captcha: nil)))
                    } catch {
#if DEBUG
                        print(error)
#endif
                        let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
                        completion(.failure(parsed))
                    }
                }
            }
            var clientInfo = SPShortClientInfo()
            clientInfo.clID = self.clientId
            clientInfo.deviceID = self.device.deviceId
            var cred = SPPassword()
            cred.id = login
            cred.password = safePassword
            cred.padding = Data(repeating: 0x1a, count: 28)
            let locale = SPLocaleUtil.getCurrLocaleLangCode() ?? "en-GB"
            let task = initAuthChallengeByApi(userAgent: self.userAgent, clToken: safeClToken, clientInfo: clientInfo, cred: cred, nonce: nonce, callbackUrl: callbackUrl, locale: locale) { result in
                do {
                    let challengeResponse = try result.get()
                    let challenges = challengeResponse.challenges.challenges
                    if (!challengeResponse.hasContext) {
                        completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "No challenge track ID"])))
                        return
                    }
                    if (challenges.isEmpty) {
                        completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "No challenges"])))
                        return
                    }
                    //var solution = SPLoginChallengeAnswerData()
                    let challenge = challenges[0]
                    if case .code? = challenge.method {
                        completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Challenge code not supported"])))
                        return
                    } else if case .hashcash(_)? = challenge.method {
                        /*var answer = SPLoginChallengeAnswer()
                        answer.hashcash = SPHashcashChallengeAnswer()
                        let now = Date.timeIntervalSinceReferenceDate
                        guard let hashcashSolve = SPHashCashUtil.solveAuthChallenge(context: challengeResponse.context, prefix: hashcashChallenge.prefix, length: hashcashChallenge.length) else {
                            //Timeout -> restart
                            _ = self.initAuth(login: login, password: password, completion: completion)
                            return
                        }
                        answer.hashcash.suffix = Data(hashcashSolve)
                        let diffNow = Date.timeIntervalSinceReferenceDate
                        let diff = diffNow - now
                        answer.hashcash.duration = Google_Protobuf_Duration(rounding: diff, rule: .towardZero)
                        solution.answers.append(answer)*/
                        completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Straight authorization with login-password is disabled"])))
                        return
                    } else if case .captcha(let captchaChallenge) = challenge.method {
                        completion(.success(SPAuthInitMeta(nonce: nonce, callbackUrl: callbackUrl, captcha: SPAuthChallengeInfo(context: challengeResponse.context, url: captchaChallenge.urlContainer.url, interactRef: captchaChallenge.interactRefContainer.interactRef))))
                        return
                    } else {
                        completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Unknown challenge type"])))
                        return
                    }
                    /*_ = authSolveChallengeByApi(userAgent: self.userAgent, clToken: self.clToken.val, loginContext: challengeResponse.context, clientInfo: clientInfo, answerData: solution, cred: cred) { result in
                        self.handleFinalLoginResponse(result, completion: completion)
                    }*/
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
    
    ///Finish authorization flow with credentials and passed challenge interaction reference
    ///- Parameter login: User login: mail, phone number or username
    ///- Parameter password: User account password
    ///- Parameter authInitMeta: Authorization flow meta
    ///- Parameter loginContext: Challenge context  data
    ///- Parameter challengeInteractRef: Passed challenge interaction reference. Received from spotify auth callback in query interact_ref parameter
    ///- Parameter completion: Authorization status response handler
    ///- Returns: API request session task
    public func authWithCaptcha(login: String, password: String, authInitMeta: SPAuthInitMeta, loginContext: Data, challengeInteractRef: String, completion: @escaping (_ result: Result<SPAuthSession, SPError>) -> Void) -> URLSessionDataTask? {
        return safeClReq { safeClToken in
            var answer = SPLoginChallengeAnswer()
            answer.captcha = SPCaptchaChallengeAnswer()
            answer.captcha.interactRef = challengeInteractRef
            var solution = SPLoginChallengeAnswerData()
            solution.answers.append(answer)
            var clientInfo = SPShortClientInfo()
            clientInfo.clID = self.clientId
            clientInfo.deviceID = self.device.deviceId
            var cred = SPPassword()
            cred.id = login
            cred.password = password
            cred.padding = Data(repeating: 0x1a, count: 28)
            let task = authSolveChallengeByApi(userAgent: self.userAgent, clToken: self.clToken.val, loginContext: loginContext, interactionNonce: authInitMeta.nonce, callbackUrl: authInitMeta.callbackUrl, clientInfo: clientInfo, answerData: solution, cred: cred) { result in
                self.handleFinalLoginResponse(result, completion: completion)
            }
            return task
        }
    }
    
    public func authWithMagicLink(_ magicLink: String, authInitMeta: SPAuthInitMeta, completion: @escaping (_ result: Result<SPAuthSession, SPError>) -> Void) -> URLSessionDataTask? {
        let validatedLink = magicLink.replacingOccurrences(of: "#", with: "?")
        guard let safeUrl = URL(string: validatedLink) else {
            completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Magic link bad format")))
            return nil
        }
        guard let safeQueryDict = safeUrl.queryDictionary() else {
            completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Magic link bad format - unable to parse query")))
            return nil
        }
        guard let safeOneTimeToken = safeQueryDict["token"], !safeOneTimeToken.isEmpty else {
            completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Magic link bad format - unable to find 'token' parameter in query")))
            return nil
        }
        return safeClReq { safeClToken in
            var cred = SPOneTimeToken()
            cred.token = safeOneTimeToken
            var clientInfo = SPShortClientInfo()
            clientInfo.clID = self.clientId
            clientInfo.deviceID = self.device.deviceId
            return authApplyMagicLinkByApi(userAgent: self.userAgent, clToken: safeClToken, interactionNonce: authInitMeta.nonce, callbackUrl: authInitMeta.callbackUrl, clientInfo: clientInfo, oneTimeToken: cred, completion: { result in
                self.handleFinalLoginResponse(result, completion: completion)
            })
        }
    }
    
    fileprivate func handleFinalLoginResponse(_ result: Result<SPLoginResponse, SPError>, completion: @escaping (_ result: Result<SPAuthSession, SPError>) -> Void) {
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
