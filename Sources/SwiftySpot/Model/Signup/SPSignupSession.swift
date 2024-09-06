//
//  SPSignupSession.swift
//  SwiftySpot
//
//  Created by developer on 10.11.2023.
//

class SPSignupSession {
    
    let username: String?
    let loginToken: String?
    let error: String?
    let challengeSessionId: String?
    
    var success: Bool {
        return username != nil && loginToken != nil
    }
    
    fileprivate init() {
        username = nil
        loginToken = nil
        error = nil
        challengeSessionId = nil
    }
    
    init(username: String, loginToken: String) {
        self.username = username
        self.loginToken = loginToken
        error = nil
        challengeSessionId = nil
    }
    
    init(error: String) {
        self.error = error
        username = nil
        loginToken = nil
        challengeSessionId = nil
    }
    
    init(challengeSessionId: String) {
        self.challengeSessionId = challengeSessionId
        username = nil
        loginToken = nil
        error = nil
    }
    
    static func from(protobuf: SPCreateAccountResponse) -> SPSignupSession {
        switch(protobuf.resultCase) {
        case .success(let data): return SPSignupSession(username: data.username, loginToken: data.loginToken)
        case .error(let err): return SPSignupSession(error: err.details)
        case .challenge(let challenge): return SPSignupSession(challengeSessionId: challenge.sessionID)
        case .none: return SPSignupSession()
        }
    }
}
