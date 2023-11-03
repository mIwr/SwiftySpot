//
//  SPPolicies.swift
//  SwiftySpot
//
//  Created by Developer on 20.09.2023.
//

import Foundation

///Profile policies
public class SPPolicies: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case optInTrialPremiumOnlyMarket = "opt_in_trial_premium_only_market"
    }
    
    public let optInTrialPremiumOnlyMarket: Bool
    
    public init(optInTrialPremiumOnlyMarket: Bool) {
        self.optInTrialPremiumOnlyMarket = optInTrialPremiumOnlyMarket
    }
}
