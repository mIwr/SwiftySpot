//
//  APIProvider.swift
//  SwiftySpot
//
//  Created by Developer on 07.09.2023.
//

import Foundation

///Initializes request for predefined api methods
func buildRequest(for method: ApiTarget) -> URLRequest? {
    let pathEncoded = method.path.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    guard let url: URL = URL(string: method.baseURL + pathEncoded) else {return nil}
    var urlReq: URLRequest = URLRequest(url: url)
    urlReq.httpMethod = method.method
    urlReq.allHTTPHeaderFields = method.headers
    #if DEBUG
    print("Request -> " + method.method + " '" + method.baseURL + method.path + "'")
    #endif
    if let protobuf = method.protobuf {
        urlReq.httpBody = protobuf
        urlReq.allHTTPHeaderFields?["Content-Length"] = String(protobuf.count)
        #if DEBUG
        if !protobuf.isEmpty{
            let bytes = [UInt8].init(protobuf)
            let hexStr = StringUtil.bytesToHexString(bytes)
            print("Request protobuf body hex string (" + String(bytes.count) + " bytes): " + hexStr)
        }
        #endif
    }
    return urlReq
}

///Send request and try parse as base SPResponse
func requestSPResponse(_ request: URLRequest, completion: @escaping (_ result: Result<SPResponse, SPError>) -> Void) -> URLSessionDataTask {
    let task = URLSession.shared.dataTask(with: request)
    {
        (data, response, error) in
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        guard let responseData = data else {
            guard let safeErr = error else {
                completion(.failure(.badResponseData(errCode: statusCode, data: ["description": "Unknown response error"])))
                return
            }
            completion(.failure(.badResponseData(errCode: statusCode, data: ["description": safeErr])))
            return
        }
#if DEBUG
        let bytes = [UInt8].init(responseData)
        let hexStr = StringUtil.bytesToHexString(bytes)
        print("Raw hex string (" + String(bytes.count) + " bytes) response [" + String(statusCode) + "]: " + hexStr)
#endif
        let spResponse = SPResponse(statusCode: statusCode, result: responseData, error: nil)
        completion(.success(spResponse))
    }
    task.resume()
    return task
}

///Send request and try parse as Data instance
func requestData(_ request: URLRequest, completion: @escaping (_ result: Result<Data, SPError>) -> Void) -> URLSessionDataTask {
    let task = URLSession.shared.dataTask(with: request)
    {
        (data, response, error) in
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        guard let responseData = data else {
            if let g_error = error
            {
                completion(.failure(.badResponseData(errCode: statusCode, data: ["description": g_error])))
            } else {
                completion(.failure(.badResponseData(errCode: statusCode, data: ["description": error.debugDescription])))
            }
            return
        }
#if DEBUG
        print("Raw data (" + String(responseData.count) + " bytes) response [" + String(statusCode) + "]")
#endif
        guard (response as? HTTPURLResponse).map({ (200..<300).contains($0.statusCode) }) != false else
        {
            completion(.failure(.invalidResponseStatusCode(errCode: statusCode, description: String(data: responseData, encoding: .utf8) ?? "")))
            return
        }
        completion(.success(responseData))
    }
    task.resume()
    return task
}

///Send request and try parse as pair of Data instance and response headers
func requestDataWithHeaders(_ request: URLRequest, completion: @escaping (_ result: Result<(Data, [String: String]), SPError>) -> Void) -> URLSessionDataTask {
    let task = URLSession.shared.dataTask(with: request)
    {
        (data, response, error) in
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        guard let responseData = data else {
            if let g_error = error
            {
                completion(.failure(.badResponseData(errCode: statusCode, data: ["description": g_error])))
            } else {
                completion(.failure(.badResponseData(errCode: statusCode, data: ["description": error.debugDescription])))
            }
            return
        }
#if DEBUG
        print("Raw data (" + String(responseData.count) + " bytes) response [" + String(statusCode) + "]")
#endif
        guard (response as? HTTPURLResponse).map({ (200..<300).contains($0.statusCode) }) != false else
        {
            completion(.failure(.invalidResponseStatusCode(errCode: statusCode, description: String(data: responseData, encoding: .utf8) ?? "")))
            return
        }
        let headers:[String: String] = ((response as? HTTPURLResponse)?.allHeaderFields as? [String: String]) ?? [:]
        completion(.success((responseData, headers)))
    }
    task.resume()
    return task
}

///Send request and try parse as json
func requestJson(_ request: URLRequest, completion: @escaping (_ result: Result<[String: Any], SPError>) -> Void) -> URLSessionDataTask {
    let task = URLSession.shared.dataTask(with: request)
    {
        (data, response, error) in
        let statusCode = (response as? HTTPURLResponse)?.statusCode ?? -1
        guard let responseData = data else {
            if let g_error = error
            {
                completion(.failure(.badResponseData(errCode: statusCode, data: ["description": g_error])))
            } else {
                completion(.failure(.badResponseData(errCode: statusCode, data: ["description": error.debugDescription])))
            }
            return
        }
#if DEBUG
        let bytes = [UInt8].init(responseData)
        let hexStr = StringUtil.bytesToHexString(bytes)
        print("Raw hex string (" + String(bytes.count) + " bytes) response [" + String(statusCode) + "]: " + hexStr)
#endif
        guard (response as? HTTPURLResponse).map({ (200..<300).contains($0.statusCode) }) != false else
        {
            completion(.failure(.invalidResponseStatusCode(errCode: statusCode, description: String(data: responseData, encoding: .utf8) ?? "")))
            return
        }
        do
        {
            guard let json = try JSONSerialization.jsonObject(with: responseData, options: []) as? [String: AnyObject] else {
                throw SPError.badResponseData(errCode: statusCode, data: ["description": "Parsed json is nil", "data": responseData])                
            }
            completion(.success(json))
        } catch {
            completion(.failure(.badResponseData(errCode: statusCode, data: ["description": error, "data": responseData])))
        }
    }
    task.resume()
    return task
}
