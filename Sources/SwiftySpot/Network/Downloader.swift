//
//  Downloader.swift
//  SwiftySpot
//
//  Created by Developer on 07.09.2023.
//

import Foundation

///Downloads any resource
func download(headers: [String: String], fullPath: String, completion: @escaping (_ result: Result<Data, SPError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .download(headers: headers, fullPath: fullPath)) else {completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build downloader request"))); return}
    requestData(req, completion: completion)
}

///Downloads any resource with response headers
func downloadWithHeaders(headers: [String: String], fullPath: String, completion: @escaping (_ result: Result<(Data, [String: String]), SPError>) -> Void) {
    guard let req: URLRequest = buildRequest(for: .download(headers: headers, fullPath: fullPath)) else {completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build downloader request"))); return}
    requestDataWithHeaders(req, completion: completion)
}
