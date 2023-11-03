//
//  SPClientSupportApiExt.swift
//  SwiftySpot
//
//  Created by Developer on 16.09.2023.
//

import Foundation

extension SPClient {
    
    ///Refresh client session
    func refreshClientToken(completion: @escaping (_ result: Result<SPClientToken, SPError>) -> Void) {
        var clientInfo = SPClientInfo()
        clientInfo.clID = clientId
        clientInfo.appVerCode = appVersionCode
        var connectivity = SPConnectivity()
        var platformData = PlatformSpecificData()
        if (device.iOS) {
            var iosPlatform = NativeIOSData()
            iosPlatform.model = device.model
            iosPlatform.osVer = device.osVersionCode
            iosPlatform.hw = device.model
            iosPlatform.simulator = false
            iosPlatform.userInterfaceIdiom = 0
            platformData.ios = iosPlatform
        } else {
            //Android
            var androidPlatform = NativeAndroidData()
            androidPlatform.model = device.model
            androidPlatform.osVer = device.osVersionCode
            androidPlatform.model2 = device.model
            androidPlatform.brand = device.manufacturer
            androidPlatform.brand2 = device.manufacturer.lowercased()
            androidPlatform.sdk = device.osVersionNumber
            androidPlatform.aarch = 32
            var screen = SPScreenInfo()
            screen.height = 1920
            screen.width = 1080
            screen.density = 360
            screen.densityOther = 480
            androidPlatform.screen = screen
            platformData.android = androidPlatform
        }
        connectivity.platform = platformData
        connectivity.deviceID = device.deviceId
        clientInfo.connectivity = connectivity
        initSessionChallengeByApi(userAgent: userAgent, initData: clientInfo) { result in
            do {
                let res = try result.get()
                var solution = ChallengeAnswerData()
                solution.context = res.context
                if (res.challenges.isEmpty) {
                    completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "No challenges"])))
                    return
                }
                let challenge = res.challenges[0]
                switch challenge.type {
                case .challengeClientSecretHmac:
                    completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Client secret HMAC challenge not supported"])))
                    return
                case .challengeEvaluateJs:
                    completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Evaluate JS challenge not supported"])))
                    return
                case .challengeHashCash:
                    HashCashUtil.solveClTokenChallengeAsync(prefix: challenge.hashcashParameters.prefix, length: challenge.hashcashParameters.length) { hashcashSolution in
                        guard let safeHashcashSolution = hashcashSolution else {
                            //Timeout or compute fail -> restart
                            self.refreshClientToken(completion: completion)
                            return
                        }
                        var answer = ChallengeAnswer()
                        answer.type = challenge.type
                        answer.hashcash = HashCashAnswer()
                        answer.hashcash.suffix = safeHashcashSolution.uppercased()
                        solution.answers.append(answer)
                        initSessionSolveChallengeByApi(userAgent: self.userAgent, answerData: solution) { solveResult in
                            do {
                                let tk = try solveResult.get()
                                self.clToken = tk
                                self.clTokenCreateTsUTC = Int64(Date.timeIntervalBetween1970AndReferenceDate + Date.timeIntervalSinceReferenceDate)
                                let clSession = SPClientSession(token: tk.val, createTsUTC: self.clTokenCreateTsUTC, expiresInS: tk.expiresInS, refreshInS: tk.refreshAfterS)
                                self.notifyClSessionUpdate(clSession)
                                completion(.success(tk))
                            } catch {
        #if DEBUG
                                print(error)
        #endif
                                let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
                                completion(.failure(parsed))
                                
                            }
                        }
                    }
                    break
                default:
                    completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Unknown challenge type"])))
                    return
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
    
    ///Refresh authorization by stored credential data and username
    ///- Parameter completion: Authorization status response handler
    func refreshAuth(completion: @escaping (_ result: Result<SPAuthSession, SPError>) -> Void) {
        if (!authorized) {
            completion(.failure(.refreshAuthDataNotExists(usernameFound: !authSession.username.isEmpty, storedCredFound: !authSession.storedCredential.isEmpty)))
            commitLostAuth()
            return
        }
        guard let safeClToken = clientToken else {
            safeClReq { safeClToken in
                self.refreshAuth(completion: completion)
            }
            return
        }
        var clInfo = SPShortClientInfo()
        clInfo.clID = clientId
        clInfo.deviceID = device.deviceId
        var stored = SPStoredCredential()
        stored.username = authSession.username
        stored.data = authSession.storedCredential
        refreshAuthByApi(userAgent: userAgent, clToken: safeClToken, clientInfo: clInfo, stored: stored) { result in
            do {
                let authRes = try result.get()
                if !authRes.warnings.isEmpty {
                    print("API warnings:")
                    for apiWarn in authRes.warnings {
                        print(apiWarn)
                    }
                }
                if case .error(let err)? = authRes.response {
#if DEBUG
                    print(err)
#endif
                    let parsedErr = SPError.badRequest(errCode: err.rawValue, description: String(describing: err))
                    if (err == .invalidCredentials) {
                        self.commitLostAuth()
                    }
                    completion(.failure(parsedErr))
                    return
                }
                self.authSession = authRes.auth
                self.authTokenCreateTsUTC = Int64(Date.timeIntervalBetween1970AndReferenceDate + Date.timeIntervalSinceReferenceDate)
                let session = SPAuthSession(username: authRes.auth.username, token: authRes.auth.token, storedCred: authRes.auth.storedCredential, createTsUTC: self.clTokenCreateTsUTC, expiresInS: authRes.auth.expiresInS)
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
    }
    
    ///Drops current client session data. Possible causes: expired client token
    func commitLostClToken() {
        clToken = SPClientToken()
        clTokenCreateTsUTC = 0
        notifyClSessionUpdate(nil)
    }
    
    ///Drops current authorization token data (without stored credential and username). It means, that authorization has to be refreshed through stored credentials. Possible causes: expired authorization token.
    func commitLostAuthToken() {
        authSession.token = ""
        authTokenCreateTsUTC = 0
        notifyAuthUpdate(SPAuthSession(username: authSession.username, token: "", storedCred: authSession.storedCredential, createTsUTC: 0, expiresInS: 0))
    }
    
    ///Drops current auth data (stored credential, username and auth token), profile info and fav repository after logout or getting 'Invalid credentials' API error
    func commitLostAuth() {
        profile = nil
        notifyProfileUpdate(nil)
        authSession = SPAuthToken()
        authTokenCreateTsUTC = 0
        notifyAuthUpdate(nil)
        likedDislikedArtistsStorage.removeAll()
        likedDislikedAlbumsStorage.removeAll()
        likedDislikedTracksStorage.removeAll()
        collectionsStorage.removeAll()
        downloadInfoStorage.removeAll()
    }
    
    ///Retrieves from API private back-end access points
    ///- Parameter completion: Access point response handler
    func getAPs(completion: @escaping (_ result: Result<SPAccessPoint, SPError>) -> Void) {
        guard let safeClToken = clientToken else {
            safeClReq { safeClToken in
                self.getAPs(completion: completion)
            }
            return
        }
        getAccessPointsByApi(clToken: safeClToken){ result in
            do {
                let ap = try result.get()
                if (ap.accesspoint.isEmpty) {
                    completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Empty access points array. Try again later"])))
                    return
                }
                self.apHosts = ap.accesspoint
                self.dealerHosts = ap.dealer
                if (ap.spclient.isEmpty) {
                    completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "No http/s spclient access points"])))
                }
                self.spclientHosts.removeAll()
                for item in ap.spclient {
                    let split = item.split(separator: ":")
                    if (split.count < 2 || (split[1] != "80" && split[1] != "443")) {
                        continue
                    }
                    let host = String("https://" + split[0])
                    self.spclientHosts.append(host)
                }
                if (self.spclientHosts.isEmpty) {
                    self.notifyAPUpdate(nil)
                    completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "No parsed http/s spclient access points", "spclient": ap.spclient])))
                }
                self.notifyAPUpdate(self.spclientAp)
                completion(.success(ap))
            } catch {
#if DEBUG
                print(error)
#endif
                let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
                completion(.failure(parsed))
            }
        }
    }
    
    ///Get profile info from API
    ///- Parameter completion: Profile info response handler
    public func getProfileInfo(completion: @escaping (_ result: Result<SPProfile, SPError>) -> Void) {
        guard let safeClToken = clientToken, let safeAuthToken = authToken else {
            safeAuthReq { safeClToken, safeAuthToken in
                self.getProfileInfo(completion: completion)
            }
            return
        }
        getProfileInfoByApi(userAgent: userAgent, clToken: safeClToken, authToken: safeAuthToken, os: device.os, appVer: appVersionCode) { result in
            do {
                let profileRes = try result.get()
                self.profile = profileRes
                self.notifyProfileUpdate(profileRes)
                if (profileRes.username != self.authSession.username) {
                    //Username updated -> Update for refresh auth data
                    self.authSession.username = profileRes.username
                    let updAuth = SPAuthSession(username: profileRes.username, token: self.authSession.token, storedCred: self.authSession.storedCredential, createTsUTC: self.authTokenCreateTsUTC, expiresInS: self.authSession.expiresInS)
                    self.notifyAuthUpdate(updAuth)
                }
                completion(.success(profileRes))
            } catch {
#if DEBUG
                print(error)
#endif
                let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
                completion(.failure(parsed))
            }
        }
    }
    
    ///Execute API func with required client token parameter
    ///- Parameter clReq: API func handler with actual or refreshed client token
    func safeClReq(_ clReq: @escaping (_ safeClToken: String) -> Void) {
        if let cToken = clientToken {
            clReq(cToken)
            return
        }
        refreshClientToken { result in
            do {
                _ = try result.get()
                clReq(self.clToken.val)
            } catch {
                //TODO make retries or cancellation token support
                //self.safeClReq(clReq)
                self.commitLostClToken()
                clReq(self.clToken.val)
            }
        }
    }
    
    ///Execute API func with required client and auth tokens
    ///- Parameter authReq: API func handler with actual or refreshed client and auth tokens
    func safeAuthReq(_ authReq: @escaping (_ safeClToken: String, _ safeAuthToken: String) -> Void) {
        safeClReq { safeClToken in
            if let aToken = self.authToken {
                authReq(safeClToken, aToken)
                return
            }
            self.refreshAuth { result in
                do {
                    _ = try result.get()
                    authReq(self.clToken.val, self.authSession.token)
                } catch {
                    //TODO make retries or cancellation token support
                    //self.safeAuthReq(authReq)
                    authReq(self.clToken.val, self.authSession.token)
                }
            }
        }
    }
    
    ///Execute API func with required profile instance, client and auth tokens
    ///- Parameter authProfileReq: API func handler with actual or refreshed private back-end access point, client and auth tokens
    func safeAuthProfileReq(_ authProfileReq: @escaping (_ safeClToken: String, _ safeAuthToken: String, _ safeProfile: SPProfile) -> Void) {
        safeAuthReq { safeClToken, safeAuthToken in
            if let safeProfile = self.profile {
                authProfileReq(safeClToken, safeAuthToken, safeProfile)
                return
            }
            self.getProfileInfo { result in
                var country: String
                if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
                    country = Locale.current.region?.identifier ?? "DE"
                } else {
                    country = Locale.current.regionCode ?? "DE"
                }
                let safeProfile = self.profile ?? SPProfile(id: self.authSession.username, type: "user", email: "", displayName: "User", birthdate: "1970-01-01", extUrls: [:], href: "", images: [], country: country, product: "free", explicitContent: SPExplicit(enabled: false, locked: false), policies: SPPolicies(optInTrialPremiumOnlyMarket: false))
                authProfileReq(safeClToken, safeAuthToken, safeProfile)
            }
        }
    }
    
    ///Execute API func with required private back-end access point, client and auth tokens
    ///- Parameter authApReq: API func handler with actual or refreshed private back-end access point, client and auth tokens
    func safeAuthApReq(_ authApReq: @escaping (_ safeClToken: String, _ safeAuthToken: String, _ safeAp: String) -> Void) {
        safeAuthReq { safeClToken, safeAuthToken in
            if let ap = self.spclientAp {
                authApReq(safeClToken, safeAuthToken, ap)
                return
            }
            self.getAPs { result in
                let ap = self.spclientAp ?? SPConstants.defaultSpClientHost
                authApReq(safeClToken, safeAuthToken, ap)
            }
        }
    }
    
    ///Execute API func with required private back-end access point, profile instance, client and auth tokens
    ///- Parameter authProfileApReq: API func handler with actual or refreshed private back-end access point, profile instance, client and auth tokens
    func safeAuthProfileApReq(_ authProfileApReq: @escaping (_ safeClToken: String, _ safeAuthToken: String, _ safeProfile: SPProfile, _ safeAp: String) -> Void) {
        safeAuthProfileReq { safeClToken, safeAuthToken, safeProfile in
            self.safeAuthApReq { safeClToken2, safeAuthToken2, safeAp in
                authProfileApReq(safeClToken2, safeAuthToken2, safeProfile, safeAp)
            }
        }
    }
}
