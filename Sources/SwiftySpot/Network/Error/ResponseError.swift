//
//  ResponseError.swift
//  SwiftySpot
//
//  Created by Developer on 08.09.2023.
//

import Foundation

///Represents response error object from back-end
public class ResponseError: NSObject, Decodable {
    ///Response error name
    public let name: String
    ///Response error description
    public let message: String
    
    public init(name: String, message: String) {
        self.name = name
        self.message = message
    }
    
    public override var description: String {
        get {
            return name + ": " + message
        }
    }
}
