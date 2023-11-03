//
//  ApiPlaylist.swift
//  SwiftySpot
//
//  Created by Developer on 18.09.2023.
//

import Foundation

func getPlaylistInfoByApi(apHost: String, userAgent: String, clToken: String, authToken: String, id: String, os: String, appVer: String, completion: @escaping (_ result: Result<PlaylistInfo, SPError>) -> Void) {
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
    let listItems = "audio-track, audio-episode"//audio-track, audio-episode, video-episode, audiobook"
    guard let req: URLRequest = buildRequest(for: .playlist(apHost: apHost, userAgent: userAgent, clToken: clToken, authToken: authToken, id: id, os: os, appVer: appVer, listItems: listItems)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build playlist info request")))
        return
    }
    requestSPResponse(req) { result in
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
}
