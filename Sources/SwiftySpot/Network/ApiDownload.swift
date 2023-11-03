//
//  ApiDownload.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

import Foundation

func postPlayIntentByApi(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, audioFileHexId: String, proto: Spotify_Playplay_Proto_PlayIntentRequest, completion: @escaping (_ result: Result<Spotify_Playplay_Proto_PlayIntentResponse, SPError>) -> Void) {
    if (apHost.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Private back-end is empty. Retrieve access points first")))
        return
    }
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return
    }
    if (authToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth Token is empty. Authorize session first")))
        return
    }
    guard let req: URLRequest = buildRequest(for: .playIntent(apHost: apHost, userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, audioFileHexId: audioFileHexId, proto: proto)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build play intent request")))
        return
    }
    requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            if (response.statusCode == 403) {
                completion(.failure(.playIntentRestricted(hexFileId: audioFileHexId)))
                return
            }
            let parsed = try Spotify_Playplay_Proto_PlayIntentResponse(serializedData: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
}

func getDownloadInfoByApi(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, audioFileHexId: String, productType: Int, completion: @escaping (_ result: Result<Spotify_Playplay_Proto_DownloadInfoResponse, SPError>) -> Void) {
    if (apHost.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Private back-end is empty. Retrieve access points first")))
        return
    }
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return
    }
    if (authToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth Token is empty. Authorize session first")))
        return
    }
    guard let req: URLRequest = buildRequest(for: .downloadInfo(apHost: apHost, userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, audioFileHexId: audioFileHexId, productType: productType)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build download info request")))
        return
    }
    requestSPResponse(req) { result in
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
}