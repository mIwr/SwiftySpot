//
//  ApiDownload.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

import Foundation

func postPlayIntentByApi(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, audioFileHexId: String, proto: Spotify_Playplay_Proto_PlayIntentRequest, completion: @escaping (_ result: Result<Spotify_Playplay_Proto_PlayIntentResponse, SPError>) -> Void) -> URLSessionDataTask? {
    if (apHost.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Private back-end is empty. Retrieve access points first")))
        return nil
    }
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    if (authToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth Token is empty. Authorize session first")))
        return nil
    }
    guard let req: URLRequest = buildRequest(for: .playIntent(apHost: apHost, userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, audioFileHexId: audioFileHexId, proto: proto)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build play intent request")))
        return nil
    }
    let task = requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let safeData = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            if (response.statusCode == 403) {
                //Playing ban + possible codec is restricted
                completion(.failure(.playIntentRestricted(hexFileId: audioFileHexId)))
                return
            }
            if (response.statusCode == 400 && safeData.isEmpty) {
                //Possible country restrictions + 404 'NOT FOUND' on direct download link
                /*
                 <Error>
                 <Code>NoSuchKey</Code>
                 <Message>The specified key does not exist.</Message>
                 <Details>No such object: master-storage-audio/audio/{Audio file hex ID}]</Details>
                 </Error>
                 */
                completion(.failure(.playIntentRestricted(hexFileId: audioFileHexId)))
                return
            }
            let parsed = try Spotify_Playplay_Proto_PlayIntentResponse(serializedData: safeData)
            if (parsed.obfuscatedKey.isEmpty) {
                completion(.failure(.badResponseData(errCode: response.statusCode, data: ["data": safeData])))
                return
            }
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

func getDownloadInfoByApi(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, audioFileHexId: String, productType: Int, completion: @escaping (_ result: Result<Spotify_Playplay_Proto_DownloadInfoResponse, SPError>) -> Void) -> URLSessionDataTask? {
    if (apHost.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Private back-end is empty. Retrieve access points first")))
        return nil
    }
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    if (authToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth Token is empty. Authorize session first")))
        return nil
    }
    guard let req: URLRequest = buildRequest(for: .downloadInfo(apHost: apHost, userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, audioFileHexId: audioFileHexId, productType: productType)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build download info request")))
        return nil
    }
    let task = requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            let parsed = try Spotify_Playplay_Proto_DownloadInfoResponse(serializedData: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}
