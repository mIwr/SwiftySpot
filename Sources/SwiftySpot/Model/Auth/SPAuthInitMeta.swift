//
//  SPAuthInitMeta.swift
//  SwiftySpot
//
//  Created by developer on 10.04.2025.
//

///Spotify authorization init meta info
public class SPAuthInitMeta {
    
    ///User interaction nonce
    public let nonce: String
    
    ///Auth callback url
    public let callbackUrl: String
    
    ///Auth captcha info
    public let captcha: SPAuthChallengeInfo?
    
    public init() {
        nonce = ""
        callbackUrl = ""
        captcha = nil
    }
    
    init(nonce: String, callbackUrl: String, captcha: SPAuthChallengeInfo?) {
        self.nonce = nonce
        self.callbackUrl = callbackUrl
        self.captcha = captcha
    }
}
