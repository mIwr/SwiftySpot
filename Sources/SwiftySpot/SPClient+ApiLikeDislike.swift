//
//  SPClientApiLikeDislikeExt.swift
//  SwiftySpot
//
//  Created by developer on 21.10.2023.
//

import Foundation

extension SPClient {
    
    fileprivate enum LikeDislikeCollectionVariant: UInt8 {
        case artists = 0
        case albums = 1
        case tracks = 2
    }
    
    ///Get liked artists collection
    ///- Parameter pageLimit: Collection items page size
    ///- Parameter pageToken: Collection pagination token. If not stated, the first page will be requested
    ///- Parameter completion: Collection page response handler
    ///- Returns: API request session task
    public func getLikedArtists(pageLimit: UInt, pageToken: String?, completion: @escaping (_ result: Result<SPCollectionPage, SPError>) -> Void) -> URLSessionDataTask? {
        return getLikeDislikeCollection(pageLimit: pageLimit, pageToken: pageToken, collectionVariant: .artists, liked: true, completion: completion)
    }
    
    ///Get disliked artists collection
    ///- Parameter pageLimit: Collection items page size
    ///- Parameter pageToken: Collection pagination token. If not stated, the first page will be requested
    ///- Parameter completion: Collection page response handler
    ///- Returns: API request session task
    public func getDislikedArtists(pageLimit: UInt, pageToken: String?, completion: @escaping (_ result: Result<SPCollectionPage, SPError>) -> Void) -> URLSessionDataTask? {
        return getLikeDislikeCollection(pageLimit: pageLimit, pageToken: pageToken, collectionVariant: .artists, liked: false, completion: completion)
    }
    
    ///Get liked tracks collection
    ///- Parameter pageLimit: Collection items page size
    ///- Parameter pageToken: Collection pagination token. If not stated, the first page will be requested
    ///- Parameter completion: Collection page response handler
    ///- Returns: API request session task
    public func getLikedTracks(pageLimit: UInt, pageToken: String?, completion: @escaping (_ result: Result<SPCollectionPage, SPError>) -> Void) -> URLSessionDataTask? {
        return getLikeDislikeCollection(pageLimit: pageLimit, pageToken: pageToken, collectionVariant: .tracks, liked: true, completion: completion)
    }
    
    ///Get disliked tracks collection
    ///- Parameter pageLimit: Collection items page size
    ///- Parameter pageToken: Collection pagination token. If not stated, the first page will be requested
    ///- Parameter completion: Collection page response handler
    ///- Returns: API request session task
    public func getDislikedTracks(pageLimit: UInt, pageToken: String?, completion: @escaping (_ result: Result<SPCollectionPage, SPError>) -> Void) -> URLSessionDataTask? {
        return getLikeDislikeCollection(pageLimit: pageLimit, pageToken: pageToken, collectionVariant: .tracks, liked: false, completion: completion)
    }
    
    ///Synchronize current liked artists collection with remote
    ///- Parameter syncToken: Current collection sync token
    ///- Parameter completion: Collection delta response handler
    ///- Returns: API request session task
    public func getLikedArtistsDelta(syncToken: String, completion: @escaping (_ result: Result<SPCollectionDelta, SPError>) -> Void) -> URLSessionDataTask? {
        return getLikeDislikeCollectionDelta(syncToken: syncToken, collectionVariant: .artists, liked: true, completion: completion)
    }
    
    ///Synchronize current disliked artists collection with remote
    ///- Parameter syncToken: Current collection sync token
    ///- Parameter completion: Collection delta response handler
    ///- Returns: API request session task
    public func getDislikedArtistsDelta(syncToken: String, completion: @escaping (_ result: Result<SPCollectionDelta, SPError>) -> Void) -> URLSessionDataTask? {
        return getLikeDislikeCollectionDelta(syncToken: syncToken, collectionVariant: .artists, liked: false, completion: completion)
    }
    
    ///Synchronize current liked tracks collection with remote
    ///- Parameter syncToken: Current collection sync token
    ///- Parameter completion: Collection delta response handler
    ///- Returns: API request session task
    public func getLikedTracksDelta(syncToken: String, completion: @escaping (_ result: Result<SPCollectionDelta, SPError>) -> Void) -> URLSessionDataTask? {
        return getLikeDislikeCollectionDelta(syncToken: syncToken, collectionVariant: .tracks, liked: true, completion: completion)
    }
    
    ///Synchronize current disliked tracks collection with remote
    ///- Parameter syncToken: Current collection sync token
    ///- Parameter completion: Collection delta response handler
    ///- Returns: API request session task
    public func getDislikedTracksDelta(syncToken: String, completion: @escaping (_ result: Result<SPCollectionDelta, SPError>) -> Void) -> URLSessionDataTask? {
        return getLikeDislikeCollectionDelta(syncToken: syncToken, collectionVariant: .tracks, liked: false, completion: completion)
    }
    
    ///Like artist (Add navigation uri to profile collection)
    ///- Parameter uri: Artist navigation uri
    ///- Parameter completion: Like status response handler
    public func likeArtist(uri: String, completion: @escaping (_ result: Result<Bool, SPError>) -> Void) -> URLSessionDataTask? {
        return likeDislikeCollectionWrite(appendUris: [uri], removeUris: [], collectionVariant: .artists, liked: true, completion: completion)
    }
    
    ///Remove artist like (Remove artist navigation uri from profile collection)
    ///- Parameter uri: Artist navigation uri
    ///- Parameter completion: Remove like status response handler
    ///- Returns: API request session task
    public func removeArtistLike(uri: String, completion: @escaping (_ result: Result<Bool, SPError>) -> Void) -> URLSessionDataTask? {
        return likeDislikeCollectionWrite(appendUris: [], removeUris: [uri], collectionVariant: .artists, liked: true, completion: completion)
    }
    
    ///Update liked artists collection
    ///- Parameter appendUris: Artist navigation uri's, which will be inserted to the collection
    ///- Parameter removeUris: Artist navigation uri's, which will be removed from the collection
    ///- Parameter completion: Collection update status response handler
    ///- Returns: API request session task
    public func likedArtistsUpdate(appendUris: [String], removeUris: [String], completion: @escaping (_ result: Result<Bool, SPError>) -> Void) -> URLSessionDataTask? {
        return likeDislikeCollectionWrite(appendUris: appendUris, removeUris: removeUris, collectionVariant: .artists, liked: true, completion: completion)
    }
    
    ///Add artist to dislike collection
    ///- Parameter uri: Artist navigation uri
    ///- Parameter completion: Dislike status response handler
    ///- Returns: API request session task
    public func dislikeArtist(uri: String, completion: @escaping (_ result: Result<Bool, SPError>) -> Void) -> URLSessionDataTask? {
        return likeDislikeCollectionWrite(appendUris: [uri], removeUris: [], collectionVariant: .artists, liked: false, completion: completion)
    }
    
    ///Remove artist from dislike collection
    ///- Parameter uri: Artist navigation uri
    ///- Parameter completion: Dislike status response handler
    ///- Returns: API request session task
    public func removeArtistDislike(uri: String, completion: @escaping (_ result: Result<Bool, SPError>) -> Void) -> URLSessionDataTask? {
        return likeDislikeCollectionWrite(appendUris: [], removeUris: [uri], collectionVariant: .artists, liked: false, completion: completion)
    }
    
    ///Update disliked artists collection
    ///- Parameter appendUris: Artist navigation uri's, which will be inserted to the collection
    ///- Parameter removeUris: Artist navigation uri's, which will be removed from the collection
    ///- Parameter completion: Collection update status response handler
    ///- Returns: API request session task
    public func dislikedArtistsUpdate(appendUris: [String], removeUris: [String], completion: @escaping (_ result: Result<Bool, SPError>) -> Void) -> URLSessionDataTask? {
        return likeDislikeCollectionWrite(appendUris: appendUris, removeUris: removeUris, collectionVariant: .artists, liked: false, completion: completion)
    }
    
    ///Like track (Add navigation uri to profile collection)
    ///- Parameter uri: Track navigation uri
    ///- Parameter completion: Like status response handler
    ///- Returns: API request session task
    public func likeTrack(uri: String, completion: @escaping (_ result: Result<Bool, SPError>) -> Void) -> URLSessionDataTask? {
        return likeDislikeCollectionWrite(appendUris: [uri], removeUris: [], collectionVariant: .tracks, liked: true, completion: completion)
    }
    
    ///Remove track like (Remove navigation uri from profile collection)
    ///- Parameter uri: Track navigation uri
    ///- Parameter completion: Remove like status response handler
    ///- Returns: API request session task
    public func removeTrackLike(uri: String, completion: @escaping (_ result: Result<Bool, SPError>) -> Void) -> URLSessionDataTask? {
        return likeDislikeCollectionWrite(appendUris: [], removeUris: [uri], collectionVariant: .tracks, liked: true, completion: completion)
    }
    
    ///Update liked tracks collection
    ///- Parameter appendUris: Track navigation uri's, which will be inserted to the collection
    ///- Parameter removeUris: Track navigation uri's, which will be removed from the collection
    ///- Parameter completion: Collection update status response handler
    ///- Returns: API request session task
    public func likedTracksUpdate(appendUris: [String], removeUris: [String], completion: @escaping (_ result: Result<Bool, SPError>) -> Void) -> URLSessionDataTask? {
        return likeDislikeCollectionWrite(appendUris: appendUris, removeUris: removeUris, collectionVariant: .tracks, liked: true, completion: completion)
    }
    
    ///Add track to dislike collection
    ///- Parameter uri: Track navigation uri
    ///- Parameter completion: Dislike status response handler
    public func dislikeTrack(uri: String, completion: @escaping (_ result: Result<Bool, SPError>) -> Void) -> URLSessionDataTask? {
        return likeDislikeCollectionWrite(appendUris: [uri], removeUris: [], collectionVariant: .tracks, liked: false, completion: completion)
    }
    
    ///Remove track from dislike collection
    ///- Parameter uri: Track navigation uri
    ///- Parameter completion: Dislike status response handler
    ///- Returns: API request session task
    public func removeTrackDislike(uri: String, completion: @escaping (_ result: Result<Bool, SPError>) -> Void) -> URLSessionDataTask? {
        return likeDislikeCollectionWrite(appendUris: [], removeUris: [uri], collectionVariant: .tracks, liked: false, completion: completion)
    }
    
    ///Update disliked tracks collection
    ///- Parameter appendUris: Track navigation uri's, which will be inserted to the collection
    ///- Parameter removeUris: Track navigation uri's, which will be removed from the collection
    ///- Parameter completion: Collection update status response handler
    ///- Returns: API request session task
    public func dislikedTracksUpdate(appendUris: [String], removeUris: [String], completion: @escaping (_ result: Result<Bool, SPError>) -> Void) -> URLSessionDataTask? {
        return likeDislikeCollectionWrite(appendUris: appendUris, removeUris: removeUris, collectionVariant: .tracks, liked: false, completion: completion)
    }
    
    fileprivate func getLikeDislikeCollection(pageLimit: UInt, pageToken: String?, collectionVariant: LikeDislikeCollectionVariant, liked: Bool, completion: @escaping (_ result: Result<SPCollectionPage, SPError>) -> Void) -> URLSessionDataTask? {
        guard let safeClToken = clientToken, let safeAuthToken = authToken else {
            return safeAuthReq { safeClToken, safeAuthToken in
                return self.getLikeDislikeCollection(pageLimit: pageLimit, pageToken: pageToken, collectionVariant: collectionVariant, liked: liked, completion: completion)
            }
        }
        let collectionName = getCollectionName(collectionVariant: collectionVariant, liked: liked)
        let task = getCollectionByApi(userAgent: userAgent, clToken: safeClToken, authToken: safeAuthToken, os: device.os, appVer: appVersionCode, username: authSession.username, collectionName: collectionName, paginationToken: pageToken, limit: pageLimit) { response in
            do {
                let collection = try response.get()
                let parsed = SPCollectionPage.from(protobuf: collection, pageSize: pageLimit)
                switch (collectionVariant) {
                case .artists:
                    self.likedDislikedArtistsStorage.updateFromPage(parsed, liked: liked)
                    break
                case .albums, .tracks:
                    var tracks: [SPCollectionItem] = []
                    var albums: [SPCollectionItem] = []
                    for item in parsed.items {
                        if (item.entityType == .track) {
                            tracks.append(item)
                            continue
                        }
                        if (item.entityType == .album) {
                            albums.append(item)
                        }
                    }
                    if (!tracks.isEmpty) {
                        let tracksPage = SPCollectionPage(syncToken: parsed.syncToken, nextPageToken: parsed.nextPageToken, items: tracks, pageSise: parsed.pageSize)
                        self.likedDislikedTracksStorage.updateFromPage(tracksPage, liked: liked)
                    }
                    if (!albums.isEmpty) {
                        let albumsPage = SPCollectionPage(syncToken: parsed.syncToken, nextPageToken: parsed.nextPageToken, items: albums, pageSise: parsed.pageSize)
                        self.likedDislikedAlbumsStorage.updateFromPage(albumsPage, liked: liked)
                    }
                    break
                }
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
    
    fileprivate func getLikeDislikeCollectionDelta(syncToken: String, collectionVariant: LikeDislikeCollectionVariant, liked: Bool, completion: @escaping (_ result: Result<SPCollectionDelta, SPError>) -> Void) -> URLSessionDataTask? {
        guard let safeAp = spclientAp, let safeClToken = clientToken, let safeAuthToken = authToken else {
            return safeAuthApReq({ safeClToken, safeAuthToken, safeAp in
                return self.getLikeDislikeCollectionDelta(syncToken: syncToken, collectionVariant: collectionVariant, liked: liked, completion: completion)
            })
        }
        let collectionName = getCollectionName(collectionVariant: collectionVariant, liked: liked)
        let task = getCollectionDeltaByApi(apHost: safeAp, userAgent: userAgent, clToken: safeClToken, authToken: safeAuthToken, os: device.os, appVer: appVersionCode, username: authSession.username, collectionName: collectionName, lastSyncToken: syncToken) { response in
            do {
                let delta = try response.get()
                let parsed = SPCollectionDelta.from(protobuf: delta)
                switch (collectionVariant) {
                case .artists:
                    self.likedDislikedArtistsStorage.updateFromDelta(parsed, liked: liked)
                    break
                case .albums, .tracks:
                    var tracks: [SPCollectionItem] = []
                    var albums: [SPCollectionItem] = []
                    for item in parsed.items {
                        if (item.entityType == .track) {
                            tracks.append(item)
                            continue
                        }
                        if (item.entityType == .album) {
                            albums.append(item)
                        }
                    }
                    if (!tracks.isEmpty) {
                        let tracksDelta = SPCollectionDelta(updatePossible: parsed.updatePossible, syncToken: parsed.syncToken, items: tracks)
                        self.likedDislikedTracksStorage.updateFromDelta(tracksDelta, liked: liked)
                    }
                    if (!albums.isEmpty) {
                        let albumsDelta = SPCollectionDelta(updatePossible: parsed.updatePossible, syncToken: parsed.syncToken, items: albums)
                        self.likedDislikedAlbumsStorage.updateFromDelta(albumsDelta, liked: liked)
                    }
                    break
                }
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
    
    fileprivate func likeDislikeCollectionWrite(appendUris: [String], removeUris: [String], collectionVariant: LikeDislikeCollectionVariant, liked: Bool, username: String? = nil, completion: @escaping (_ result: Result<Bool, SPError>) -> Void) -> URLSessionDataTask? {
        guard let safeAp = spclientAp, let safeClToken = clientToken, let safeAuthToken = authToken else {
            return safeAuthApReq({ safeClToken, safeAuthToken, safeAp in
                return self.likeDislikeCollectionWrite(appendUris: appendUris, removeUris: removeUris, collectionVariant: collectionVariant, liked: liked, username: username, completion: completion)
            })
        }
        var clUpdIdBytes = [UInt8].init(repeating: 0, count: 8)
        _ = SecRandomCopyBytes(kSecRandomDefault, clUpdIdBytes.count, &clUpdIdBytes)
        let clUpdId = SPBase16.encode(clUpdIdBytes)
        var items: [SPCollectionPageItem] = []
        let ts = Int64(Date().timeIntervalSince1970)
        for uri in appendUris {
            var item = SPCollectionPageItem()
            item.uri = uri
            item.addedAtTs = ts
            items.append(item)
        }
        for uri in removeUris {
            var item = SPCollectionPageItem()
            item.uri = uri
            item.isRemoved = true
            items.append(item)
        }
        let collectionName = getCollectionName(collectionVariant: collectionVariant, liked: liked)
        let task = collectionUpdateByApi(apHost: safeAp, userAgent: userAgent, clToken: safeClToken, authToken: safeAuthToken, os: device.os, appVer: appVersionCode, username: username ?? authSession.username, collectionName: collectionName, updItems: items, clienUpdateId: clUpdId) { response in
            do {
                let success = try response.get()
                let updItems: [SPCollectionItem] = items.map { item in
                    return SPCollectionItem.from(protobuf: item)
                }
                switch (collectionVariant) {
                case .artists:
                    self.likedDislikedArtistsStorage.updateFromCollection(updItems, liked: liked)
                    break
                case .albums, .tracks:
                    var tracks: [SPCollectionItem] = []
                    var albums: [SPCollectionItem] = []
                    for item in updItems {
                        if (item.entityType == .track) {
                            tracks.append(item)
                            continue
                        }
                        if (item.entityType == .album) {
                            albums.append(item)
                        }
                    }
                    if (!tracks.isEmpty) {
                        self.likedDislikedTracksStorage.updateFromCollection(tracks, liked: liked)
                    }
                    if (!albums.isEmpty) {
                        self.likedDislikedAlbumsStorage.updateFromCollection(albums, liked: liked)
                    }
                    break
                }
                completion(.success(success))
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
    
    fileprivate func getCollectionName(collectionVariant: LikeDislikeCollectionVariant, liked: Bool) -> String {
        switch (collectionVariant) {
        case .artists: return liked ? likedDislikedArtistsStorage.liked.name : likedDislikedArtistsStorage.disliked.name
        case .albums: return liked ? likedDislikedAlbumsStorage.liked.name : likedDislikedAlbumsStorage.disliked.name
        case .tracks: return liked ? likedDislikedTracksStorage.liked.name : likedDislikedTracksStorage.disliked.name
        }
    }
}
