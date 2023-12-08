//
//  Downloader.swift
//  SwiftySpot
//
//  Created by Developer on 07.09.2023.
//

import Foundation

///Downloads any resource
func download(headers: [String: String], fullPath: String, completion: @escaping (_ result: Result<Data, SPError>) -> Void) -> URLSessionDataTask? {
    guard let req: URLRequest = buildRequest(for: .download(headers: headers, fullPath: fullPath)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build downloader request")))
        return nil
    }
    let task = requestData(req, completion: completion)
    return task
}

///Downloads any resource with response headers
func downloadWithHeaders(headers: [String: String], fullPath: String, completion: @escaping (_ result: Result<(Data, [String: String]), SPError>) -> Void) -> URLSessionDataTask? {
    guard let req: URLRequest = buildRequest(for: .download(headers: headers, fullPath: fullPath)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build downloader request")))
        return nil
    }
    let task = requestDataWithHeaders(req, completion: completion)
    return task
}
