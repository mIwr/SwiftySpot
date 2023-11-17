//
//  SPClientApiLyricsExt.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2023.
//

import Foundation

extension SPClient {
    
    ///Try download (if exists) track lyrics
    ///- Parameter trackId: Track navigation uri ID component
    ///- Parameter vocalRemove: TODO
    ///- Parameter syllableSync: Request line syllables additionally
    ///- Parameter completion: Completion handler
    public func getTrackLyrics(_ trackId: String, vocalRemove: Bool = false, syllableSync: Bool = false, completion: @escaping (_ result: Result<SPLyrics?, SPError>) -> Void) {
        let obj = SPTypedObj(id: trackId, entityType: .track)
        getLyrics(obj: obj, vocalRemove: vocalRemove, syllableSync: syllableSync, completion: completion)
    }
    
    ///Try download (if exists) object lyrics
    ///- Parameter obj: Object for lyrics request. For example: track, podcast
    ///- Parameter vocalRemove: TODO
    ///- Parameter syllableSync: Request line syllables additionally
    ///- Parameter completion: Completion handler
    public func getLyrics(obj: SPTypedObj, vocalRemove: Bool, syllableSync: Bool, completion: @escaping (_ result: Result<SPLyrics?, SPError>) -> Void) {
        guard let safeClToken = clientToken, let safeAuthToken = authToken else {
            safeAuthReq { safeClToken, safeAuthToken in
                self.getLyrics(obj: obj, vocalRemove: vocalRemove, syllableSync: syllableSync, completion: completion)
            }
            return
        }
        
        var langCode = ""
        if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            langCode = Locale.current.language.languageCode?.identifier(.alpha2) ?? "de"
            langCode += "_" + (Locale.current.region?.identifier ?? "DE")
        } else {
            langCode = Locale.current.languageCode ?? "de"
            langCode += "_" + (Locale.current.regionCode ?? "DE")
        }
        var type = ""
        if (obj.entityType == .track) {
            type = "track"
        }
        getLyricsByApi(userAgent: userAgent, clToken: safeClToken, authToken: safeAuthToken, os: device.os, appVer: appVersionCode, clId: clientId, type: type, id: obj.id, vocalRemove: vocalRemove, syllableSync: syllableSync, clientLangCode: langCode) { result in
            do {
                let lyricsData = try result.get()
                guard let safeLyrics = lyricsData else {
                    getReserveLyricsByApi(type: type, obj: obj) { reserveResult in
                        if let safeReserveLyrics = try? reserveResult.get() {
                            self.lyricsStorage.update([obj.uri: safeReserveLyrics])
                        }
                        completion(reserveResult)
                    }
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
    }
    
    #if DEBUG
    func getLyricsReserve(obj: SPTypedObj, completion: @escaping (_ result: Result<SPLyrics?, SPError>) -> Void) {
        var type = ""
        if (obj.entityType == .track) {
            type = "track"
        }
        getReserveLyricsByApi(type: type, obj: obj, completion: completion)
    }
    #endif
}
