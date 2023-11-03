//
//  SPAccessPoint.swift
//  SwiftySpot
//
//  Created by Developer on 15.09.2023.
//

///Private back-end API access point info
class SPAccessPoint: Decodable {
    
    ///Access point base urls
    let accesspoint: [String]
    ///Dealer  base urls
    let dealer: [String]
    ///API client  base urls
    let spclient: [String]
    
    init(accesspoint: [String], dealer: [String], spclient: [String]) {
        self.accesspoint = accesspoint
        self.dealer = dealer
        self.spclient = spclient
    }
}
