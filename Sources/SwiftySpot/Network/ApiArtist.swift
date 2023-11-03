//
//  ApiArtist.swift
//  SwiftySpot
//
//  Created by Developer on 21.09.2023.
//

import Foundation

func getArtistUIInfoByApi(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, id: String, locale: String, application: String, video: Bool, podcast: Bool, deviceId: String, timezone: String, timeFormat: String, onDemandUris: [String], completion: @escaping (_ result: Result<SPArtist, SPError>) -> Void) {
    var signal = ""
    if (!onDemandUris.isEmpty) {
        signal = "ondemand:"
        for uri in onDemandUris {
            signal += uri + ","
        }
        signal.removeLast()
        signal = signal.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""
    }
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return
    }
    if (authToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth Token is empty. Authorize session first")))
        return
    }
    guard let req = buildRequest(for: .artistUI(userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, clId: clId, id: id, locale: locale, application: application, video: video, podcast: podcast, deviceId: deviceId, timezone: timezone, timeFormat: timeFormat, signal: signal)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build artist info request")))
        return
    }
    requestJson(req) { result in
        do {
            let json = try result.get()
            _ = try JSONSerialization.data(withJSONObject: json)
            //TODO parse artist view info (JSON) and append endpoint to SPClient
            completion(.success(SPArtist()))
        } catch {
            let parsed: SPError = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
}

func getArtistInfoByApi(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, uri: String, fields: [String], imgSize: String, completion: @escaping (_ result: Result<SPArtist, SPError>) -> Void) {
    if (clToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Client Token is empty. Initialize session first")))
        return
    }
    if (authToken.isEmpty) {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Auth Token is empty. Authorize session first")))
        return
    }
    guard let req = buildRequest(for: .artist(userAgent: userAgent, clToken: clToken, authToken: authToken, os: os, appVer: appVer, clId: clId, uri: uri, fields: fields, imgSize: imgSize)) else {
        completion(.failure(.badRequest(errCode: SPError.GeneralErrCode, description: "Unable to build artist info request")))
        return
    }
    requestJson(req) { result in
        do {
            let json = try result.get()
            _ = try JSONSerialization.data(withJSONObject: json)
            //TODO parse artist info (JSON)
            completion(.success(SPArtist()))
        } catch {
            let parsed: SPError = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
            completion(.failure(parsed))
        }
    }
}

/*
 {"name":"Vita","artistUri":"spotify:artist:6xFDR4HD7uLGWhdV9vF9qP","isVerified":true,"autobiography":{"body":"","links":{"instagram":"https://instagram.com/vita_ohne_li"}},"gallery":{"total":3,"images":[{"originalId":"ab67616789c71423a114a045aa70e050","image":{"size":"LARGE","uri":"https://i.scdn.co/image/ab6761670000ecd47638ebdc5eeb5fba558f1faf","width":640,"height":640}},{"originalId":"ab676167db6f76e93d389ebf015bbeba","image":{"size":"LARGE","uri":"https://i.scdn.co/image/ab6761670000ecd424908916c2c76140fea44145","width":640,"height":640}},{"originalId":"ab6761677ef3416edf076c9dce333e69","image":{"size":"LARGE","uri":"https://i.scdn.co/image/ab6761670000ecd4810cbe9120f8936231ccc196","width":640,"height":640}}],"gallerySource":"S4A"},"header":{"size":"LARGE","uri":"https://i.scdn.co/image/ab6761860000101683cde7ce6eb198095fa1e325","width":2660,"height":1140},"monthlyListeners":57689,"globalChartPosition":0}
 */
