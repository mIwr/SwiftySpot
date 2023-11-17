//
//  SPClientApiCollectionExt.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

import Foundation

extension SPClient {
    
    public func getCollection(pageLimit: UInt, pageToken: String?, collectionName: String, completion: @escaping (_ result: Result<SPCollectionPage, SPError>) -> Void) {
        guard let safeProfile = profile, let safeClToken = clientToken, let safeAuthToken = authToken else {
            safeAuthProfileReq { safeClToken, safeAuthToken, safeProfile in
                self.getCollection(pageLimit: pageLimit, pageToken: pageToken, collectionName: collectionName, completion: completion)
            }
            return
        }
        getCollectionByApi(userAgent: userAgent, clToken: safeClToken, authToken: safeAuthToken, os: device.os, appVer: appVersionCode, username: safeProfile.username, collectionName: collectionName, paginationToken: pageToken, limit: pageLimit) { response in
            do {
                let collection = try response.get()
                let parsed = SPCollectionPage.from(protobuf: collection, pageSize: pageLimit)
                if (!self.collectionsStorage.contains(where: { (k,v) in
                    return k == collectionName
                })) {
                    let controller = SPCollectionController(name: collectionName, syncToken: parsed.syncToken, pageSize: pageLimit, nextPageToken: parsed.nextPageToken, initValues: [])
                    controller.updateFromCollection(parsed.items)
                    self.collectionsStorage[collectionName] = controller
                } else {
                    self.collectionsStorage[collectionName]?.updateFromPage(parsed)
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
    }
    
    public func getCollectionDelta(syncToken: String, collectionName: String, completion: @escaping (_ result: Result<SPCollectionDelta, SPError>) -> Void) {
        guard let safeAp = spclientAp, let safeProfile = profile, let safeClToken = clientToken, let safeAuthToken = authToken else {
            safeAuthProfileApReq({ safeClToken, safeAuthToken, safeProfile, safeAp in
                self.getCollectionDelta(syncToken: syncToken, collectionName: collectionName, completion: completion)
            })
            return
        }
        getCollectionDeltaByApi(apHost: safeAp, userAgent: userAgent, clToken: safeClToken, authToken: safeAuthToken, os: device.os, appVer: appVersionCode, username: safeProfile.username, collectionName: collectionName, lastSyncToken: syncToken) { response in
            do {
                let delta = try response.get()
                let parsed = SPCollectionDelta.from(protobuf: delta)
                if (!self.collectionsStorage.contains(where: { (k,v) in
                    return k == collectionName
                })) {
                    let controller = SPCollectionController(name: collectionName, syncToken: parsed.syncToken, initValues: [])
                    controller.updateFromCollection(parsed.items)
                    self.collectionsStorage[collectionName] = controller
                } else {
                    self.collectionsStorage[collectionName]?.updateFromDelta(parsed)
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
    }
    
    ///Update collection
    ///- Parameter appendUris: Navigation uri's, which will be inserted to the collection
    ///- Parameter removeUris: Navigation uri's, which will be removed from the collection
    ///- Parameter collectionName: Collection name
    ///- Parameter collectionChName: Collection update events channel
    ///- Parameter username: Collection owner username. If not stated, profile username will be used
    ///- Parameter completion: Collection update status handler
    public func collectionWrite(appendUris: [String], removeUris: [String], collectionName: String, username: String? = nil, completion: @escaping (_ result: Result<Bool, SPError>) -> Void) {
        guard let safeAp = spclientAp, let safeProfile = profile, let safeClToken = clientToken, let safeAuthToken = authToken else {
            safeAuthProfileApReq({ safeClToken, safeAuthToken, safeProfile, safeAp in
                self.collectionWrite(appendUris: appendUris, removeUris: removeUris, collectionName: collectionName, username: username, completion: completion)
            })
            return
        }
        var clUpdIdBytes = [UInt8].init(repeating: 0, count: 8)
        _ = SecRandomCopyBytes(kSecRandomDefault, clUpdIdBytes.count, &clUpdIdBytes)
        let clUpdId = StringUtil.bytesToHexString(clUpdIdBytes)
        var items: [Com_Spotify_Collection2_V2_Proto_CollectionItem] = []
        let ts = Int64(Date().timeIntervalSince1970)
        for uri in appendUris {
            var item = Com_Spotify_Collection2_V2_Proto_CollectionItem()
            item.uri = uri
            item.addedAtTs = ts
            items.append(item)
        }
        for uri in removeUris {
            var item = Com_Spotify_Collection2_V2_Proto_CollectionItem()
            item.uri = uri
            item.isRemoved = true
            items.append(item)
        }
        collectionUpdateByApi(apHost: safeAp, userAgent: userAgent, clToken: safeClToken, authToken: safeAuthToken, os: device.os, appVer: appVersionCode, username: username ?? safeProfile.username, collectionName: collectionName, updItems: items, clienUpdateId: clUpdId) { response in
            do {
                let success = try response.get()
                let updItems: [SPCollectionItem] = items.map { item in
                    return SPCollectionItem.from(protobuf: item)
                }
                if (!self.collectionsStorage.contains(where: { (k,v) in
                    return k == collectionName
                })) {
                    let controller = SPCollectionController(name: collectionName, initValues: [])
                    controller.updateFromCollection(updItems)
                    self.collectionsStorage[collectionName] = controller
                } else {
                    self.collectionsStorage[collectionName]?.updateFromCollection(updItems)
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
    }
}
