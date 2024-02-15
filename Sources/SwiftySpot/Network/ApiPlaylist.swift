//
//  ApiPlaylist.swift
//  SwiftySpot
//
//  Created by Developer on 18.09.2023.
//

import Foundation

func getPlaylistInfoByApi(apHost: String, userAgent: String, clToken: String, authToken: String, id: String, os: String, appVer: String, completion: @escaping (_ result: Result<PlaylistInfo, SPError>) -> Void) -> URLSessionDataTask? {
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
    let listItems = "audio-track, audio-episode"//audio-track, audio-episode, video-episode, audiobook"
    guard let req: URLRequest = buildRequest(for: .playlist(apHost: apHost, userAgent: userAgent, clToken: clToken, authToken: authToken, id: id, os: os, appVer: appVer, listItems: listItems)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build playlist info request")))
        return nil
    }
    let task = requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: SPError.GeneralErrCode, data: ["description": "Response data is nil"])))
                return
            }
            let parsed = try PlaylistInfo(serializedData: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}

func getPlaylistFromTrackByApi(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, trackId: String, completion: @escaping (_ result: Result<PlaylistFromTrackSeed, SPError>) -> Void) -> URLSessionDataTask? {
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return nil
    }
    if (authToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth Token is empty. Authorize session first")))
        return nil
    }
    guard let req: URLRequest = buildRequest(for: .playlistFromTrack(userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, clId: clId, trackId: trackId)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build playlist from track request")))
        return nil
    }
    let task = requestSPResponse(req) { result in
        do {
            let response = try result.get()
            guard let data = response.result else {
                completion(.failure(.badResponseData(errCode: response.statusCode, data: ["description": "Response data is nil"])))
                return
            }
            let parsed = try PlaylistFromTrackSeed(serializedData: data)
            completion(.success(parsed))
        } catch {
            let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
    return task
}
