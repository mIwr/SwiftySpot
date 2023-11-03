//
//  SPClientApiPlaylistExt.swift
//  SwiftySpot
//
//  Created by Developer on 18.09.2023.
//

import Foundation

extension SPClient {
  
  ///Get playlist info by its ID
  ///- Parameter ID: Playlist navigation uri ID
  ///- Parameter completion: Playlist info response handler
  public func getPlaylistInfo(id: String, completion: @escaping (_ result: Result<SPPlaylist, SPError>) -> Void) {
    guard let safeSpclientAP = spclientAp, let safeClToken = clientToken, let safeAuthToken = authToken else {
      safeAuthApReq { safeClToken, safeAuthToken, safeAp in
        self.getPlaylistInfo(id: id, completion: completion)
      }
      return
    }
    getPlaylistInfoByApi(apHost: safeSpclientAP, userAgent: userAgent, clToken: safeClToken, authToken: safeAuthToken, id: id, os: device.os, appVer: appVersionCode) { result in
      do {
        let info = try result.get()
        var tracks:[SPPlaylistTrack] = []
        for track in info.payload.tracks {
          let converted = SPPlaylistTrack(uri: track.uri, createTsMsUTC: track.info.createTsMsUtc, props: track.info.props)
          tracks.append(converted)
        }
        let playlist = SPPlaylist(id: id, name: info.meta.name, desc: info.meta.desc, tracks: tracks, images: info.meta.image, additional: info.meta.additional)
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
