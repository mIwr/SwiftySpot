//
//  SPClientNotifierExt.swift
//  SwiftySpot
//
//  Created by Developer on 08.09.2023.
//

import Foundation

extension Notification.Name {
    ///Client session update event. Payload contains in notification.object with type 'SPClientSession'
    public static let SPSessionUpdate = Notification.Name(SPClient._sessionEventName)
    ///Authorization update event. Payload contains in notification.object with type 'SPAuthSession?'
    public static let SPAuthorizationUpdate = Notification.Name(SPClient._authEventName)
    ///Access point update event. Payload contains in notification.object with type 'String?'
    public static let SPAPUpdate = Notification.Name(SPClient._apEventName)
    
    ///Profile info update event. Payload contains in notification.object with type 'SPProfile?'
    public static let SPProfileUpdate = Notification.Name(SPClient._profileEventName)
}

extension SPClient {
    fileprivate static let _sessionEventName = "SPSessionUpdate"
    fileprivate static let _authEventName = "SPAuthorizationUpdate"
    fileprivate static let _apEventName = "SPAPUpdate"
    fileprivate static let _profileEventName = "SPProfileUpdate"
    
    func notifyClSessionUpdate(_ session: SPClientSession?) {
        let notification = Notification(name: .SPSessionUpdate, object: session)
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
    
    func notifyAuthUpdate(_ auth: SPAuthSession?) {
        let notification = Notification.init(name: .SPAuthorizationUpdate, object: auth)
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
    
    func notifyAPUpdate(_ ap: String?) {
        let notification = Notification(name: .SPAPUpdate, object: ap)
        NotificationCenter.default.post(notification)
    }
    
    func notifyProfileUpdate(_ profile: SPProfile?) {
        let notification = Notification(name: .SPProfileUpdate, object: profile)
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
}

extension Notification {
    
    public func tryParseClientSessionUpdate() -> (Bool, SPClientSession?)  {
        if let session = object as? SPClientSession?, name == Notification.Name.SPSessionUpdate {
            return (true, session)
        }
        return (false, nil)
    }
    
    public func tryParseAuthUpdate() -> (Bool, SPAuthSession?)  {
        if let auth = object as? SPAuthSession?, name == Notification.Name.SPAuthorizationUpdate {
            return (true, auth)
        }
        return (false, nil)
    }
    
    public func tryParseAPUpdate() -> (Bool, String?) {
        if let ap = object as? String?, name == Notification.Name.SPAPUpdate {
            return (true, ap)
        }
        return (false, nil)
    }
    
    public func tryParseProfileUpdate() -> (Bool, SPProfile?) {
        if let profile = object as? SPProfile?, name == Notification.Name.SPProfileUpdate {
            return (true, profile)
        }
        return (false, nil)
    }
}
