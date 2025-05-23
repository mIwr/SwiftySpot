//
//  SPClientApiArtistExt.swift
//  SwiftySpot
//
//  Created by Developer on 22.09.2023.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension SPClient {
    
    func getArtistInfo(uri: String, imgSize: String, completion: @escaping (_ result: Result<SPArtist, SPError>) -> Void) -> URLSessionDataTask? {
        let task = safeAuthIncludingGuestReq { safeClToken, safeAuthToken in
            let objFields: [String] = []
            //name,isVerified,header,biography,autobiography,monthlyListeners,gallery&imgSize=large
            let task = getArtistInfoByApi(userAgent: self.userAgent, clToken: safeClToken, authToken: safeAuthToken, os: self.device.os, appVer: self.appVersionCode, clId: self.clientId, uri: uri, fields: objFields, imgSize: imgSize) { result in
                do {
                    let playlist = try result.get()
                    completion(.success(playlist))
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
        return task
    }
}
