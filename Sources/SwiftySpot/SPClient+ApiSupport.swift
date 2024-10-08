//
//  SPClientSupportApiExt.swift
//  SwiftySpot
//
//  Created by Developer on 16.09.2023.
//

import Foundation

extension SPClient {
    
    ///Refresh client session
    func refreshClientToken(completion: @escaping (_ result: Result<SPClientToken, SPError>) -> Void) -> URLSessionDataTask? {
        var clientInfo = SPClientInfo()
        clientInfo.clID = clientId
        clientInfo.appVerCode = appVersionCode
        var connectivity = SPConnectivity()
        var platformData = SPPlatformSpecificData()
        if (device.iOS) {
            var iosPlatform = SPNativeIOSData()
            iosPlatform.model = device.model
            iosPlatform.osVer = device.osVersionCode
            iosPlatform.hw = device.model
            iosPlatform.simulator = false
            iosPlatform.userInterfaceIdiom = 0
            platformData.ios = iosPlatform
        } else {
            //Android
            var androidPlatform = SPNativeAndroidData()
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
        let task = initSessionChallengeByApi(userAgent: userAgent, initData: clientInfo) { result in
            do {
                let res = try result.get()
                var solution = SPChallengeAnswerData()
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
                    SPHashCashUtil.solveClTokenChallengeAsync(prefix: challenge.hashcashParameters.prefix, length: challenge.hashcashParameters.length) { hashcashSolution in
                        guard let safeHashcashSolution = hashcashSolution else {
                            //Timeout or compute fail -> restart
                            _ = self.refreshClientToken(completion: completion)
                            return
                        }
                        var answer = SPChallengeAnswer()
                        answer.type = challenge.type
                        answer.hashcash = SPHashCashAnswer()
                        answer.hashcash.suffix = safeHashcashSolution.uppercased()
                        solution.answers.append(answer)
                        _ = initSessionSolveChallengeByApi(userAgent: self.userAgent, answerData: solution) { solveResult in
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
        return task
    }
    
    ///Refresh authorization by stored credential data and username
    ///- Parameter completion: Authorization status response handler
    func refreshAuth(completion: @escaping (_ result: Result<SPAuthSession, SPError>) -> Void) -> URLSessionDataTask? {
        if (!authorized) {
            completion(.failure(.refreshAuthDataNotExists(usernameFound: !authSession.username.isEmpty, storedCredFound: !authSession.storedCredential.isEmpty)))
            commitLostAuth()
            return nil
        }
        return safeClReq { safeClToken in
            var clInfo = SPShortClientInfo()
            clInfo.clID = self.clientId
            clInfo.deviceID = self.device.deviceId
            var stored = SPStoredCredential()
            stored.username = self.authSession.username
            stored.data = self.authSession.storedCredential
            let task = refreshAuthByApi(userAgent: self.userAgent, clToken: safeClToken, clientInfo: clInfo, stored: stored) { result in
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
                    let session = SPAuthSession(username: authRes.auth.username, token: authRes.auth.token, storedCred: authRes.auth.storedCredential, createTsUTC: self.authTokenCreateTsUTC, expiresInS: authRes.auth.expiresInS)
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
            return task
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
    ///- Returns: API request session task
    func getAPs(completion: @escaping (_ result: Result<SPAccessPoint, SPError>) -> Void) -> URLSessionDataTask? {
        return getAccessPointsByApi(clToken: clientToken) { result in
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
    
    ///Retrieves from API DRM application certificate
    ///- Parameter completion: Application certificate response handler
    ///- Returns: API request session task
    public func getWdvCert(completion: @escaping (_ result: Result<Data, SPError>) -> Void) -> URLSessionDataTask? {
        return getWdvCertByApi { result in
            do {
                let data = try result.get()
                if (data.isEmpty) {
                    completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Empty DRM application certificate data"])))
                    return
                }
                self.wdvCert = data
                completion(.success(data))
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
    ///- Returns: API request session task
    public func getProfileInfo(completion: @escaping (_ result: Result<SPProfile, SPError>) -> Void) -> URLSessionDataTask? {
        return safeAuthReq { safeClToken, safeAuthToken in
            let task = getProfileInfoByApi(userAgent: self.userAgent, clToken: safeClToken, authToken: safeAuthToken, os: self.device.os, appVer: self.appVersionCode) { result in
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
            return task
        }
    }
    
    ///Execute API func with required client token parameter
    ///- Parameter clReq: API func handler with actual or refreshed client token
    ///- Returns: API request session task
    func safeClReq(_ clReq: @escaping (_ safeClToken: String) -> URLSessionDataTask?) -> URLSessionDataTask? {
        if let cToken = clientToken {
            return clReq(cToken)
        }
        let refreshTask = refreshClientToken { result in
            do {
                _ = try result.get()
                _ = clReq(self.clToken.val)
            } catch {
                self.commitLostClToken()
                _ = clReq(self.clToken.val)
            }
        }
        return refreshTask
    }
    
    ///Execute API func with required client and auth tokens
    ///- Parameter authReq: API func handler with actual or refreshed client and auth tokens
    ///- Returns: API request session task
    func safeAuthReq(_ authReq: @escaping (_ safeClToken: String, _ safeAuthToken: String) -> URLSessionDataTask?) -> URLSessionDataTask? {
        if let aToken = authToken {
            return safeClReq { safeClToken in
                let task = authReq(safeClToken, aToken)
                return task
            }
        }
        let task = refreshAuth { result in
            do {
                _ = try result.get()
                _ = authReq(self.clToken.val, self.authSession.token)
            } catch {
                self.commitLostAuthToken()
                _ = authReq(self.clToken.val, self.authSession.token)
            }
        }
        return task
    }
    
    ///Execute API func with required profile instance, client and auth tokens
    ///- Parameter authProfileReq: API func handler with actual or refreshed private back-end access point, client and auth tokens
    ///- Returns: API request session task
    func safeAuthProfileReq(_ authProfileReq: @escaping (_ safeClToken: String, _ safeAuthToken: String, _ safeProfile: SPProfile) -> URLSessionDataTask?) -> URLSessionDataTask? {
        if let safeProfile = profile {
            return safeAuthReq { safeClToken, safeAuthToken in
                let task = authProfileReq(safeClToken, safeAuthToken, safeProfile)
                return task
            }
        }
        let task = getProfileInfo { result in
            var country: String
            if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
                country = Locale.current.region?.identifier ?? "DE"
            } else {
                country = Locale.current.regionCode ?? "DE"
            }
            let safeProfile = self.profile ?? SPProfile(id: self.authSession.username, type: "user", email: "", displayName: "User", birthdate: "1970-01-01", extUrls: [:], href: "", images: [], country: country, product: "free", explicitContent: SPExplicit(enabled: false, locked: false), policies: SPPolicies(optInTrialPremiumOnlyMarket: false))
            _ = authProfileReq(self.clientToken ?? "", self.authToken ?? "", safeProfile)
        }
        return task
    }
    
    ///Execute API func with required private back-end access point, client and auth tokens
    ///- Parameter authApReq: API func handler with actual or refreshed private back-end access point, client and auth tokens
    ///- Returns: API request session task
    func safeAuthApReq(_ authApReq: @escaping (_ safeClToken: String, _ safeAuthToken: String, _ safeAp: String) -> URLSessionDataTask?) -> URLSessionDataTask? {
        let task = safeAuthReq { safeClToken, safeAuthToken in
            if let ap = self.spclientAp {
                return authApReq(safeClToken, safeAuthToken, ap)
            }
            if (safeClToken.isEmpty) {
                //After refresh client token is empty -> exec callback
                //+ Prevent client token refresh (required for AP) after parent task cancel
                return authApReq(safeClToken, safeAuthToken, SPConstants.defaultSpClientHost)
            }
            let refreshTask = self.getAPs { result in
                let ap = self.spclientAp ?? SPConstants.defaultSpClientHost
                _ = authApReq(safeClToken, safeAuthToken, ap)
            }
            return refreshTask
        }
        return task
    }
    
    ///Execute API func with required private back-end access point, profile instance, client and auth tokens
    ///- Parameter authProfileApReq: API func handler with actual or refreshed private back-end access point, profile instance, client and auth tokens
    ///- Returns: API request session task
    func safeAuthProfileApReq(_ authProfileApReq: @escaping (_ safeClToken: String, _ safeAuthToken: String, _ safeProfile: SPProfile, _ safeAp: String) -> URLSessionDataTask?) -> URLSessionDataTask? {
        let task = safeAuthProfileReq { safeClToken, safeAuthToken, safeProfile in
            if let ap = self.spclientAp {
                return authProfileApReq(safeClToken, safeAuthToken, safeProfile, ap)
            }
            if (safeClToken.isEmpty) {
                //After refresh client token is empty -> exec callback
                //+ Prevent client token refresh (required for AP) after parent task cancel
                return authProfileApReq(safeClToken, safeAuthToken, safeProfile, SPConstants.defaultSpClientHost)
            }
            let refreshTask = self.getAPs { result in
                let ap = self.spclientAp ?? SPConstants.defaultSpClientHost
                _ = authProfileApReq(safeClToken, safeAuthToken, safeProfile, ap)
            }
            return refreshTask
        }
        return task
    }
}
