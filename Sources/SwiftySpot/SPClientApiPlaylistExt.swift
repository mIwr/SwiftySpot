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
    ///- Returns: API request session task
    public func getPlaylistInfo(id: String, completion: @escaping (_ result: Result<SPPlaylist, SPError>) -> Void) -> URLSessionDataTask? {
        return safeAuthApReq { safeClToken, safeAuthToken, safeSpclientAP in
            let task = getPlaylistInfoByApi(apHost: safeSpclientAP, userAgent: self.userAgent, clToken: safeClToken, authToken: safeAuthToken, id: id, os: self.device.os, appVer: self.appVersionCode) { result in
                do {
                    let info = try result.get()
                    var tracks: [SPPlaylistTrack] = []
                    for track in info.payload.tracks {
                        let converted = SPPlaylistTrack(uri: track.uri, createTsMsUTC: track.info.createTsMsUtc, props: track.info.props)
                        tracks.append(converted)
                    }
                    let playlist = SPPlaylist(id: id, name: info.meta.name, desc: info.meta.desc, tracks: tracks, images: info.meta.image, additional: info.meta.additional)
                    self.playlistsMetaStorage.update([SPNavigateUriUtil.generatePlaylistUri(id: id): playlist])
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
    }
    
    ///Generate playlist by track seed
    ///- Parameter trackId: Track ID seed
    ///- Parameter completion: Playlist info response handler
    ///- Returns: API request session task
    public func getPlaylistFromTrack(trackId: String, completion: @escaping (_ result: Result<[SPTypedObj], SPError>) -> Void) -> URLSessionDataTask? {
        return safeAuthApReq { safeClToken, safeAuthToken, safeSpclientAP in
            let task = getPlaylistFromTrackByApi(userAgent: self.userAgent, clToken: safeClToken, authToken: safeAuthToken, os: self.device.os, appVer: self.appVersionCode, clId: self.clientId, trackId: trackId) { result in
                do {
                    let playlists = try result.get()
                    var parsedPlaylists: [SPTypedObj] = []
                    for playlistShort in playlists.playlists {
                        let item = SPTypedObj(uri: playlistShort.uri)
                        if (item.entityType != .playlist) {
                            #if DEBUG
                            print("Unexpected uri (not playlist) " + playlistShort.uri)
                            #endif
                            continue
                        }
                        parsedPlaylists.append(item)
                    }
                    completion(.success(parsedPlaylists))
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
