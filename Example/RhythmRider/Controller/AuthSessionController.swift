//
//  AuthController.swift
//  RhythmRider
//
//  Created by Developer on 13.10.2023.
//

import SwiftySpot

class AuthSessionController {
    
    fileprivate static let _authTokenKey = "spAuthToken"
    fileprivate static let _authTokenExpiresKey = "spAuthTokenExpires"
    fileprivate static let _authTokenCreateTsKey = "spAuthTokenCreateTs"
    fileprivate static let _authUsernameKey = "spAuthUsername"
    fileprivate static let _authStoredCredKey = "spAuthStoredCred"
    
    fileprivate(set) var session: SPAuthSession?
    
    init() {
        session = AuthSessionController.load()
        NotificationCenter.default.addObserver(self, selector: #selector(onAuthSessionUpdate), name: .SPAuthorizationUpdate, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .SPAuthorizationUpdate, object: nil)
    }
    
    @objc fileprivate func onAuthSessionUpdate(_ notification: Notification) {
        let updObj = notification.tryParseAuthUpdate()
        if (updObj.0 != true) {
            return
        }
        session = updObj.1
        save()
    }
    
    fileprivate func save() {
        guard let safeSession = session else {
            _ = SecureStorage.delete(key: AuthSessionController._authTokenKey)
            _ = SecureStorage.delete(key: AuthSessionController._authTokenExpiresKey)
            _ = SecureStorage.delete(key: AuthSessionController._authTokenCreateTsKey)
            _ = SecureStorage.delete(key: AuthSessionController._authUsernameKey)
            _ = SecureStorage.delete(key: AuthSessionController._authStoredCredKey)
            return
        }
        guard let safeTokenData = safeSession.token.data(using: String.Encoding.utf8, allowLossyConversion: false) else {return}
        var status = SecureStorage.save(key: AuthSessionController._authTokenKey, data: safeTokenData)
        if status != errSecSuccess
        {
            print("Error during save authorization token")
            return
        }
        var bytes = SPBinaryUtil.getBytes(safeSession.expiresInS)
        let expiresData = Data(bytes)
        status = SecureStorage.save(key: AuthSessionController._authTokenExpiresKey, data: expiresData)
        if status != errSecSuccess
        {
            print("Error during save authorization token expires")
            return
        }
        bytes = SPBinaryUtil.getBytes(safeSession.createTsUTC)
        let createTsData = Data(bytes)
        status = SecureStorage.save(key: AuthSessionController._authTokenCreateTsKey, data: createTsData)
        if status != errSecSuccess
        {
            print("Error during save authorization token creation timestamp")
            return
        }
        guard let safeUsernameData = safeSession.username.data(using: String.Encoding.utf8, allowLossyConversion: false) else {return}
        status = SecureStorage.save(key: AuthSessionController._authUsernameKey, data: safeUsernameData)
        if status != errSecSuccess
        {
            print("Error during save authorization username")
            return
        }
        status = SecureStorage.save(key: AuthSessionController._authStoredCredKey, data: safeSession.storedCred)
        if status != errSecSuccess
        {
            print("Error during save authorization stored credential")
            return
        }
    }
    
    static fileprivate func load() -> SPAuthSession? {
        guard let safeTokenData = SecureStorage.load(key: AuthSessionController._authTokenKey) else { return nil }
        guard let token = String(data: safeTokenData, encoding: .utf8) else { return nil }
        guard let safeExpiresData = SecureStorage.load(key: AuthSessionController._authTokenExpiresKey) else { return nil }
        guard let expires: Int32 = SPBinaryUtil.getVal([UInt8].init(safeExpiresData)) else { return nil }
        guard let safeCreateTsData = SecureStorage.load(key: AuthSessionController._authTokenCreateTsKey) else { return nil }
        guard let createTs: Int64 = SPBinaryUtil.getVal([UInt8].init(safeCreateTsData)) else { return nil }
        guard let safeUsernameData = SecureStorage.load(key: AuthSessionController._authUsernameKey) else { return nil }
        guard let username = String(data: safeUsernameData, encoding: .utf8) else { return nil }
        guard let safeStoredCredData = SecureStorage.load(key: AuthSessionController._authStoredCredKey) else { return nil }
        return SPAuthSession(username: username, token: token, storedCred: safeStoredCredData, createTsUTC: createTs, expiresInS: expires)
    }
}
