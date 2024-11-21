//
//  SPClientApiCollectionExt.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

import Foundation

extension SPClient {
    
    ///Get user collection info
    ///- Parameter pageLimit: Collection page size
    ///- Parameter pageToken: Collection pagination state token
    ///- Parameter collectionName: Collection name
    ///- Parameter completion: Collection page response handler
    ///- Returns: API request session task
    public func getCollection(pageLimit: UInt, pageToken: String?, collectionName: String, completion: @escaping (_ result: Result<SPCollectionPage, SPError>) -> Void) -> URLSessionDataTask? {
        return safeAuthApReq { safeClToken, safeAuthToken, safeAp in
            let task = getCollectionByApi(userAgent: self.userAgent, clToken: safeClToken, authToken: safeAuthToken, os: self.device.os, appVer: self.appVersionCode, username: self.authSession.username, collectionName: collectionName, paginationToken: pageToken, limit: pageLimit) { response in
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
            return task
        }
    }
    
    ///Get user collection delta updates
    ///- Parameter syncToken: Collection last sync token
    ///- Parameter collectionName: Collection name
    ///- Parameter completion: Collection page response handler
    ///- Returns: API request session task
    public func getCollectionDelta(syncToken: String, collectionName: String, completion: @escaping (_ result: Result<SPCollectionDelta, SPError>) -> Void) -> URLSessionDataTask? {
        return safeAuthApReq { safeClToken, safeAuthToken, safeAp in
            let task = getCollectionDeltaByApi(apHost: safeAp, userAgent: self.userAgent, clToken: safeClToken, authToken: safeAuthToken, os: self.device.os, appVer: self.appVersionCode, username: self.authSession.username, collectionName: collectionName, lastSyncToken: syncToken) { response in
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
            return task
        }
    }
    
    ///Update collection
    ///- Parameter appendUris: Navigation uri's, which will be inserted to the collection
    ///- Parameter removeUris: Navigation uri's, which will be removed from the collection
    ///- Parameter collectionName: Collection name
    ///- Parameter collectionChName: Collection update events channel
    ///- Parameter username: Collection owner username. If not stated, profile username will be used
    ///- Parameter completion: Collection update status handler
    ///- Returns: API request session task
    public func collectionWrite(appendUris: [String], removeUris: [String], collectionName: String, username: String? = nil, completion: @escaping (_ result: Result<Bool, SPError>) -> Void) -> URLSessionDataTask? {
        return safeAuthApReq { safeClToken, safeAuthToken, safeAp in
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
            let task = collectionUpdateByApi(apHost: safeAp, userAgent: self.userAgent, clToken: safeClToken, authToken: safeAuthToken, os: self.device.os, appVer: self.appVersionCode, username: username ?? self.authSession.username, collectionName: collectionName, updItems: items, clienUpdateId: clUpdId) { response in
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
            return task
        }
    }
}
