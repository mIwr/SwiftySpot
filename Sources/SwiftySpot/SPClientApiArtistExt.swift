//
//  SPClientApiArtistExt.swift
//  SwiftySpot
//
//  Created by Developer on 22.09.2023.
//

import Foundation

extension SPClient {
    
    func getArtistInfo(uri: String, imgSize: String, completion: @escaping (_ result: Result<SPArtist, SPError>) -> Void) {
        guard let safeClToken = clientToken, let safeAuthToken = authToken else {
            safeAuthReq { safeClToken, safeAuthToken in
                self.getArtistInfo(uri: uri, imgSize: imgSize, completion: completion)
            }
            return
        }
        let objFields: [String] = []
        //name,isVerified,header,biography,autobiography,monthlyListeners,gallery&imgSize=large
        getArtistInfoByApi(userAgent: userAgent, clToken: safeClToken, authToken: safeAuthToken, os: device.os, appVer: appVersionCode, clId: clientId, uri: uri, fields: objFields, imgSize: imgSize) { result in
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
    }
}
