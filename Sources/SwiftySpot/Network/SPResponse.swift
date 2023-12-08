//
//  Response.swift
//  SwiftySpot
//
//  Created by Developer on 08.09.2023.
//

import Foundation

///Represents low-level parsed protobuf response from back-end
public class SPResponse {
    
    ///Response status code
    public let statusCode: Int
    ///Response payload
    public let result: Data?
    ///Response error data
    public let error: ResponseError?
    
    public var isSuccessStatusCode: Bool {get {return statusCode >= 200 && statusCode < 300}}
    
    public init(statusCode: Int, result: Data?, error: ResponseError?) {
        self.statusCode = statusCode
        self.result = result
        self.error = error
    }
}
