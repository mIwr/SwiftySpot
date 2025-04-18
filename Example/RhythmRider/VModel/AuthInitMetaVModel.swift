//
//  AuthInitMetaVModel.swift
//  RhythmRider
//
//  Created by developer on 11.04.2025.
//

import SwiftySpot

class AuthInitMetaVModel: ObservableObject {
    
    @Published var authInitMeta: SPAuthInitMeta
    {
        didSet {
            guard let safeChallengeUrlStr = authInitMeta.captcha?.url else {
                return
            }
            guard let safeChallengeUrl = URL(string: safeChallengeUrlStr) else {
                return
            }
            challengeUrl = safeChallengeUrl
        }
    }
    fileprivate(set) var challengeUrl: URL
    
    init(authInitMeta: SPAuthInitMeta? = nil) {
        self.authInitMeta = authInitMeta ?? SPAuthInitMeta()
        challengeUrl = Bundle.main.bundleURL
    }
}
