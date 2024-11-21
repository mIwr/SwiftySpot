//
//  SPClientApiMetadata.swift
//  SwiftySpot
//
//  Created by Developer on 19.09.2023.
//

import Foundation

extension SPClient {
    
    ///Get artists meta. Can be executed with guest authorization
    ///- Parameter artistUris: Artist navigation uri's
    ///- Parameter completion: Meta info response handler
    ///- Returns: API request session task
    public func getArtistsDetails(artistUris: [String], completion: @escaping (_ result: Result<[String: SPMetadataArtist], SPError>) -> Void) -> URLSessionDataTask? {
        var validatedUris: [String] = []
        for uri in artistUris {
            if (!SPNavigateUriUtil.validateArtistUri(uri)) {
#if DEBUG
                print("Uri " + uri + " for artist meta details not valid, skip")
#endif
                continue
            }
            validatedUris.append(uri)
        }
        let task = getMetadata(uris: validatedUris, kind: .artistV4) { response in
            do {
                let meta = try response.get()
                let items = self.parseArtistsDetails(response: meta)
                self.artistsMetaStorage.update(items)
                completion(.success(items))
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
    
    func parseArtistsDetails(response: SPMetaBatchedExtensionResponse) -> [String: SPMetadataArtist] {
        var items:[String: SPMetadataArtist] = [:]
        for dataArr in response.extendedMetadata {
            if (dataArr.kind != .artistV4) {
#if DEBUG
                print("Found unexpected meta kind " + String(describing: dataArr.kind))
#endif
                continue
            }
            for item in dataArr.extensionData {
                if (!item.extensionData.isA(SPMetaArtist.self)) {
#if DEBUG
                    print("Found unexpected metadata type on artist data array: " + item.extensionData.typeURL)
#endif
                    continue
                }
                do {
                    let artistMeta = try SPMetaArtist(unpackingAny: item.extensionData)
                    let parsed = SPMetadataArtist.from(protobuf: artistMeta, uri: item.entityUri)
                    items[item.entityUri] = parsed
                } catch {
#if DEBUG
                    print(error)
#endif
                }
            }
        }
        return items
    }
    
    ///Get albums meta. Can be executed with guest authorization
    ///- Parameter albumUris: Album navigation uri's
    ///- Parameter completion: Meta info response handler
    ///- Returns: API request session task
    public func getAlbumsDetails(albumUris: [String], completion: @escaping (_ result: Result<[String: SPMetadataAlbum], SPError>) -> Void)  -> URLSessionDataTask? {
        var validatedUris: [String] = []
        for uri in albumUris {
            if (!SPNavigateUriUtil.validateAlbumUri(uri)) {
#if DEBUG
                print("Uri " + uri + " for album meta details not valid, skip")
#endif
                continue
            }
            validatedUris.append(uri)
        }
        let task = getMetadata(uris: validatedUris, kind: .albumV4) { response in
            do {
                let meta = try response.get()
                let items = self.parseAlbumsDetails(response: meta)
                self.albumsMetaStorage.update(items)
                completion(.success(items))
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
    
    func parseAlbumsDetails(response: SPMetaBatchedExtensionResponse) -> [String: SPMetadataAlbum] {
        var items:[String: SPMetadataAlbum] = [:]
        for dataArr in response.extendedMetadata {
            if (dataArr.kind != .albumV4) {
#if DEBUG
                print("Found unexpected meta kind " + String(describing: dataArr.kind))
#endif
                continue
            }
            for item in dataArr.extensionData {
                if (!item.extensionData.isA(SPMetaAlbum.self)) {
#if DEBUG
                    print("Found unexpected metadata type on album data array: " + item.extensionData.typeURL)
#endif
                    continue
                }
                do {
                    let albumMeta = try SPMetaAlbum(unpackingAny: item.extensionData)
                    let parsed = SPMetadataAlbum.from(protobuf: albumMeta, uri: item.entityUri)
                    items[item.entityUri] = parsed
                } catch {
#if DEBUG
                    print(error)
#endif
                }
            }
        }
        return items
    }
    
    ///Get tracks meta. Can be executed with guest authorization
    ///- Parameter trackUris: Track navigation uri's
    ///- Parameter completion: Meta info response handler
    ///- Returns: API request session task
    public func getTracksDetails(trackUris: [String], completion: @escaping (_ result: Result<[String: SPMetadataTrack], SPError>) -> Void) -> URLSessionDataTask? {
        var validatedUris: [String] = []
        for uri in trackUris {
            if (!SPNavigateUriUtil.validateTrackUri(uri)) {
#if DEBUG
                print("Uri " + uri + " for track meta details not valid, skip")
#endif
                continue
            }
            validatedUris.append(uri)
        }
        let task = getMetadata(uris: validatedUris, kind: .trackV4) { response in
            do {
                let meta = try response.get()
                let items = self.parseTracksDetails(response: meta)
                self.tracksMetaStorage.update(items)
                completion(.success(items))
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
    
    func parseTracksDetails(response: SPMetaBatchedExtensionResponse) -> [String: SPMetadataTrack] {
        var items:[String: SPMetadataTrack] = [:]
        for dataArr in response.extendedMetadata {
            if (dataArr.kind != .trackV4) {
#if DEBUG
                print("Found unexpected meta kind " + String(describing: dataArr.kind))
#endif
                continue
            }
            for item in dataArr.extensionData {
                if (!item.extensionData.isA(SPMetaTrack.self)) {
#if DEBUG
                    print("Found unexpected metadata type on tracks data array: " + item.extensionData.typeURL)
#endif
                    continue
                }
                do {
                    let trackMeta = try SPMetaTrack(unpackingAny: item.extensionData)
                    let parsed = SPMetadataTrack.from(protobuf: trackMeta, uri: item.entityUri)
                    items[item.entityUri] = parsed
                } catch {
#if DEBUG
                    print(error)
#endif
                }
            }
        }
        return items
    }
    
    ///Get meta info. Can be executed with guest authorization
    ///- Parameter uris: Navigation uri's
    ///- Parameter kind: Meta type
    ///- Parameter completion: Meta info response handler
    ///- Returns: API request session task
    fileprivate func getMetadata(uris: [String], kind: SPMetaExtensionKind, completion: @escaping (_ response: Result<SPMetaBatchedExtensionResponse, SPError>) -> Void) -> URLSessionDataTask? {
        return safeAuthIncludingGuestProfileApReq { safeClToken, safeAuthToken, safeProfile, safeAp in
            var protoHeader = SPMetaBatchedEntityRequestHeader()
            var country: String = safeProfile.country
            if (country.isEmpty) {
                if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
                    country = Locale.current.region?.identifier ?? "DE"
                } else {
                    country = Locale.current.regionCode ?? "DE"
                }
            }
            var catalogue = safeProfile.product
            if (catalogue.isEmpty) {
                catalogue = "free"
            }
            protoHeader.country = country
            protoHeader.catalogue = catalogue
            var taskBytes: [UInt8] = [UInt8].init(repeating: 0, count: 16)
            _ = SecRandomCopyBytes(kSecRandomDefault, taskBytes.count, &taskBytes)
            protoHeader.taskID = Data(taskBytes)
            var items: [SPMetaEntityRequest] = []
            for uri in uris {
                var req = SPMetaEntityRequest()
                req.uri = uri
                var query = SPMetaExtensionQuery()
                query.kind = kind
                req.query.append(query)
                items.append(req)
            }
            let task = getMetadataByApi(apHost: safeAp, userAgent: self.userAgent, clToken: safeClToken, authToken: safeAuthToken, os: self.device.os, appVer: self.appVersionCode, header: protoHeader, items: items, completion: completion)
            return task
        }
    }
}
