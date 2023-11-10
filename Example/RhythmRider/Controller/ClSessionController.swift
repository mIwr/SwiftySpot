//
//  ClSessionController.swift
//  RhythmRider
//
//  Created by Developer on 13.10.2023.
//

import SwiftySpot

class ClSessionController {
    
    fileprivate static let _clTokenKey = "clToken"
    fileprivate static let _clTokenCreateTsKey = "clTokenCreateTs"
    fileprivate static let _clTokenExpiresKey = "clTokenExpires"
    
    fileprivate(set) var session: SPClientSession?
    
    init() {
        session = ClSessionController.load()
        NotificationCenter.default.addObserver(self, selector: #selector(onClSessionUpdate), name: .SPSessionUpdate, object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self, name: .SPSessionUpdate, object: nil)
    }
    
    @objc fileprivate func onClSessionUpdate(_ notification: Notification) {
        let updObj = notification.tryParseClientSessionUpdate()
        if (updObj.0 != true) {
            return
        }
        session = updObj.1
        save()
    }
    
    fileprivate func save() {
        guard let safeSession = session else {
            _ = SecureStorage.delete(key: ClSessionController._clTokenKey)
            _ = SecureStorage.delete(key: ClSessionController._clTokenExpiresKey)
            _ = SecureStorage.delete(key: ClSessionController._clTokenCreateTsKey)
            return
        }
        guard let safeTokenData = safeSession.token.data(using: String.Encoding.utf8, allowLossyConversion: false) else {return}
        var status = SecureStorage.save(key: ClSessionController._clTokenKey, data: safeTokenData)
        if status != errSecSuccess
        {
            print("Error during save client session token")
            return
        }
        var bytes = BitConvertUtil.getBytes(safeSession.expiresInS)
        let expiresData = Data(bytes)
        status = SecureStorage.save(key: ClSessionController._clTokenExpiresKey, data: expiresData)
        if status != errSecSuccess
        {
            print("Error during save client session token expires")
            return
        }
        bytes = BitConvertUtil.getBytes(safeSession.createTsUTC)
        let createTsData = Data(bytes)
        status = SecureStorage.save(key: ClSessionController._clTokenCreateTsKey, data: createTsData)
        if status != errSecSuccess
        {
            print("Error during save client session token creation timestamp")
            return
        }
    }
    
    static fileprivate func load() -> SPClientSession? {
        guard let safeTokenData = SecureStorage.load(key: ClSessionController._clTokenKey) else { return nil }
        guard let token = String(data: safeTokenData, encoding: .utf8) else { return nil }
        guard let safeExpiresData = SecureStorage.load(key: ClSessionController._clTokenExpiresKey) else { return nil }
        guard let expires: Int32 = BitConvertUtil.getVal([UInt8].init(safeExpiresData)) else { return nil }
        guard let safeCreateTsData = SecureStorage.load(key: ClSessionController._clTokenCreateTsKey) else { return nil }
        guard let createTs: Int64 = BitConvertUtil.getVal([UInt8].init(safeCreateTsData)) else { return nil }
        return SPClientSession(token: token, createTsUTC: createTs, expiresInS: expires, refreshInS: expires)
    }
}
