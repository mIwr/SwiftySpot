//
//  SPClientApiLyricsExt.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2023.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension SPClient {
    
    ///Try download (if exists) track lyrics
    ///- Parameter trackId: Track navigation uri ID component
    ///- Parameter vocalRemove: TODO
    ///- Parameter syllableSync: Request line syllables additionally
    ///- Parameter completion: Completion handler
    ///- Returns: API request session task
    public func getTrackLyrics(_ trackId: String, vocalRemove: Bool = false, syllableSync: Bool = false, completion: @escaping (_ result: Result<SPLyrics?, SPError>) -> Void) -> URLSessionDataTask? {
        let obj = SPTypedObj(id: trackId, entityType: .track)
        let task = getLyrics(obj: obj, vocalRemove: vocalRemove, syllableSync: syllableSync, completion: completion)
        return task
    }
    
    ///Try download (if exists) object lyrics
    ///- Parameter obj: Object for lyrics request. For example: track, podcast
    ///- Parameter vocalRemove: TODO
    ///- Parameter syllableSync: Request line syllables additionally
    ///- Parameter completion: Completion handler
    ///- Returns: API request session task
    public func getLyrics(obj: SPTypedObj, vocalRemove: Bool, syllableSync: Bool, completion: @escaping (_ result: Result<SPLyrics?, SPError>) -> Void) -> URLSessionDataTask? {
        return safeAuthReq { safeClToken, safeAuthToken in
            let langCode = SPLocaleUtil.getCurrLocaleLangCode() ?? "de_DE"
            var type = ""
            if (obj.entityType == .track) {
                type = "track"
            }
            let task = getLyricsByApi(userAgent: self.userAgent, clToken: safeClToken, authToken: safeAuthToken, os: self.device.os, appVer: self.appVersionCode, clId: self.clientId, type: type, id: obj.id, vocalRemove: vocalRemove, syllableSync: syllableSync, clientLangCode: langCode) { result in
                do {
                    let lyricsData = try result.get()
                    guard let safeLyrics = lyricsData else {
                        completion(.failure(.lyricsNotFound))
                        return
                    }
                    let parsed = SPLyrics.from(protobuf: safeLyrics, target: obj)
                    self.lyricsStorage.update([obj.uri: parsed])
                    completion(.success(parsed))
                } catch {
    #if DEBUG
                    print(error)
    #endif
                    let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
                    completion(.failure(parsed))
                }
            }
            return task
        }
    }
}
