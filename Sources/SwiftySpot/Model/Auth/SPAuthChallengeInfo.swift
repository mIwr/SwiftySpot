//
//  SPAuthChallengeInfo.swift
//  SwiftySpot
//
//  Created by developer on 17.04.2025.
//

import Foundation

///Captcha challenge info
public class SPAuthChallengeInfo {
    
    ///Authorization session context
    public let context: Data
    
    ///Captcha challenge url
    public let url: String
    
    ///Captcha interaction reference
    public let interactRef: String
    
    init(context: Data, url: String, interactRef: String) {
        self.context = context
        self.url = url
        self.interactRef = interactRef
    }
}
