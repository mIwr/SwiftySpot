//
//  SPClientApiSignupExt.swift
//  SwiftySpot
//
//  Created by developer on 10.11.2023.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension SPClient {
    
    func signupValidate(completion: @escaping (Result<SPSignupValidation, SPError>) -> Void) {
       _ = signupValidatePass("", completion: completion)
    }
    
    func signupValidatePass(_ password: String, completion: @escaping (Result<SPSignupValidation, SPError>) -> Void) -> URLSessionDataTask? {
        guard let safeClToken = clientToken else {
            return safeClReq { safeClToken in
                return self.signupValidatePass(password, completion: completion)
            }
        }
        let task = validateSignupByApi(userAgent: userAgent, clToken: safeClToken, os: device.os, appVer: appVersionCode, validatorKey: clientValidationKey, password: password) { result in
            do {
                let validationRes = try result.get()
                completion(.success(validationRes))
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
    
    func signup(mail: String, password: String, displayName: String, bDate: Date, gender: SPGender, completion: @escaping (Result<SPSignupSession, SPError>) -> Void) -> URLSessionDataTask? {
        guard let safeClToken = clientToken else {
            return safeClReq { safeClToken in
                return self.signup(mail: mail, password: password, displayName: displayName, bDate: bDate, gender: gender, completion: completion)
            }
        }
        var accDetails = SPAccountDetails()
        accDetails.displayName = displayName
        accDetails.gender = gender.protoEnum
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        accDetails.birthdate = dateFormatter.string(from: bDate)
        var mailPass = SPEmailAndPasswordIdentifier()
        mailPass.email = mail
        mailPass.password = password
        accDetails.identifier = mailPass
        var consentFlags = SPConsentFlags()
        consentFlags.eulaAgreed = true
        consentFlags.collectInfo = true
        consentFlags.sendEmail = true
        consentFlags.thirdPartyEmail = true
        consentFlags.pushNotificaitons = false
        accDetails.consentFlags = consentFlags
        
        var clInfo = SPSignupClientInfo()
        clInfo.appVersion = appVersionCode
        clInfo.deviceID = device.deviceId
        clInfo.platform = device.android ? "Android-ARM" : "iOS-ARM"
        clInfo.signupKey = clientValidationKey
        clInfo.capabilities = [.webInteractionV1]
        
        var tracking = SPTracking()
        tracking.creationPoint = "client_mobile"
        
        var protobuf = SPCreateAccountRequest()
        protobuf.callbackUri = "https://auth-callback.spotify.com/r/android/music/signup"
        protobuf.details = accDetails
        protobuf.clientInfo = clInfo
        protobuf.tracking = tracking
        let task = signupByApi(userAgent: userAgent, clToken: safeClToken, os: device.os, appVer: appVersionCode, clId: clientId, proto: protobuf) { result in
            do {
                let sessionRes = try result.get()
                let parsed = SPSignupSession.from(protobuf: sessionRes)
                completion(.success(parsed))
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
