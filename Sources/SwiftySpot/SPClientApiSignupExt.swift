//
//  SPClientApiSignupExt.swift
//  SwiftySpot
//
//  Created by developer on 10.11.2023.
//

import Foundation

extension SPClient {
    
    func signupValidate(completion: @escaping (Result<SPSignupValidation, SPError>) -> Void) {
        signupValidatePass("", completion: completion)
    }
    
    func signupValidatePass(_ password: String, completion: @escaping (Result<SPSignupValidation, SPError>) -> Void) {
        guard let safeClToken = clientToken else {
            safeClReq { safeClToken in
                self.signupValidatePass(password, completion: completion)
            }
            return
        }
        validateSignupByApi(userAgent: userAgent, clToken: safeClToken, os: device.os, appVer: appVersionCode, validatorKey: clientValidationKey, password: password) { result in
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
    }
    
    func signup(mail: String, password: String, displayName: String, bDate: Date, gender: SPGender, completion: @escaping (Result<SPSignupSession, SPError>) -> Void) {
        guard let safeClToken = clientToken else {
            safeClReq { safeClToken in
                self.signup(mail: mail, password: password, displayName: displayName, bDate: bDate, gender: gender, completion: completion)
            }
            return
        }
        var accDetails = Com_Spotify_Signup_V2_Proto_AccountDetails()
        accDetails.displayName = displayName
        accDetails.gender = gender.protoEnum
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        accDetails.birthdate = dateFormatter.string(from: bDate)
        var mailPass = Com_Spotify_Signup_V2_Proto_EmailAndPasswordIdentifier()
        mailPass.email = mail
        mailPass.password = password
        accDetails.identifier = mailPass
        var consentFlags = Com_Spotify_Signup_V2_Proto_ConsentFlags()
        consentFlags.eulaAgreed = true
        consentFlags.collectInfo = true
        consentFlags.sendEmail = true
        consentFlags.thirdPartyEmail = true
        consentFlags.pushNotificaitons = false
        accDetails.consentFlags = consentFlags
        
        var clInfo = Com_Spotify_Signup_V2_Proto_ClientInfo()
        clInfo.appVersion = appVersionCode
        clInfo.deviceID = device.deviceId
        clInfo.platform = device.android ? "Android-ARM" : "iOS-ARM"
        clInfo.signupKey = clientValidationKey
        clInfo.capabilities = [.webInteractionV1]
        
        var tracking = Com_Spotify_Signup_V2_Proto_Tracking()
        tracking.creationPoint = "client_mobile"
        
        var protobuf = Com_Spotify_Signup_V2_Proto_CreateAccountRequest()
        protobuf.callbackUri = "https://auth-callback.spotify.com/r/android/music/signup"
        protobuf.details = accDetails
        protobuf.clientInfo = clInfo
        protobuf.tracking = tracking
        signupByApi(userAgent: userAgent, clToken: safeClToken, os: device.os, appVer: appVersionCode, clId: clientId, proto: protobuf) { result in
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
    }
}
