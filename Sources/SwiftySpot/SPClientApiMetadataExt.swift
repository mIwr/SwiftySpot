//
//  SPClientApiMetadata.swift
//  SwiftySpot
//
//  Created by Developer on 19.09.2023.
//

import Foundation

extension SPClient {

  ///Get artists meta
  ///- Parameter artistUris: Artist navigation uri's
  ///- Parameter completion: Meta info response handler
    public func getArtistsDetails(artistUris: [String], completion: @escaping (_ result: Result<[String: SPMetadataArtist], SPError>) -> Void) {
        var validatedUris: [String] = []
        for uri in artistUris {
            if (!SPNavigateUriUtil.validateAlbumUri(uri)) {
                #if DEBUG
                print("Uri " + uri + " for artist meta details not valid, skip")
                #endif
                continue
            }
            validatedUris.append(uri)
        }
        getMetadata(uris: validatedUris, kind: .artistV4) { response in
            do {
                let meta = try response.get()
                let items = self.parseArtistsDetails(response: meta)
                self.artistsMetaStorage.update(items)
                self._metaStorage.updateArtists(items)
                completion(.success(items))
            } catch {
#if DEBUG
                print(error)
#endif
                let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
                completion(.failure(parsed))
            }
        }
    }
    
    func parseArtistsDetails(response: Com_Spotify_Extendedmetadata_Proto_BatchedExtensionResponse) -> [String: SPMetadataArtist] {
        var items:[String: SPMetadataArtist] = [:]
        for dataArr in response.extendedMetadata {
            if (dataArr.kind != .artistV4) {
                #if DEBUG
                print("Found unexpected meta kind " + String(describing: dataArr.kind))
                #endif
                continue
            }
            for item in dataArr.extensionData {
                if (!item.extensionData.isA(Spotify_Metadata_Artist.self)) {
#if DEBUG
                    print("Found unexpected metadata type on album data array: " + item.extensionData.typeURL)
#endif
                    continue
                }
                do {
                    let artistMeta = try Spotify_Metadata_Artist(unpackingAny: item.extensionData)
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

  ///Get albums meta
  ///- Parameter albumUris: Album navigation uri's
  ///- Parameter completion: Meta info response handler
    public func getAlbumsDetails(albumUris: [String], completion: @escaping (_ result: Result<[String: SPMetadataAlbum], SPError>) -> Void) {
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
        getMetadata(uris: validatedUris, kind: .albumV4) { response in
            do {
                let meta = try response.get()
                let items = self.parseAlbumsDetails(response: meta)
                self.albumsMetaStorage.update(items)
                self._metaStorage.updateAlbums(items)
                completion(.success(items))
            } catch {
#if DEBUG
                print(error)
#endif
                let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
                completion(.failure(parsed))
            }
        }
    }
    
    func parseAlbumsDetails(response: Com_Spotify_Extendedmetadata_Proto_BatchedExtensionResponse) -> [String: SPMetadataAlbum] {
        var items:[String: SPMetadataAlbum] = [:]
        for dataArr in response.extendedMetadata {
            if (dataArr.kind != .albumV4) {
                #if DEBUG
                print("Found unexpected meta kind " + String(describing: dataArr.kind))
                #endif
                continue
            }
            for item in dataArr.extensionData {
                if (!item.extensionData.isA(Spotify_Metadata_Album.self)) {
#if DEBUG
                    print("Found unexpected metadata type on album data array: " + item.extensionData.typeURL)
#endif
                    continue
                }
                do {
                    let albumMeta = try Spotify_Metadata_Album(unpackingAny: item.extensionData)
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

  ///Get tracks meta
  ///- Parameter trackUris: Track navigation uri's
  ///- Parameter completion: Meta info response handler
    public func getTracksDetails(trackUris: [String], completion: @escaping (_ result: Result<[String: SPMetadataTrack], SPError>) -> Void) {
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
        getMetadata(uris: validatedUris, kind: .trackV4) { response in
            do {
                let meta = try response.get()
                let items = self.parseTracksDetails(response: meta)
                self.tracksMetaStorage.update(items)
                self._metaStorage.updateTracks(items)
                completion(.success(items))
            } catch {
#if DEBUG
                print(error)
#endif
                let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
                completion(.failure(parsed))
            }
        }
    }
    
    func parseTracksDetails(response: Com_Spotify_Extendedmetadata_Proto_BatchedExtensionResponse) -> [String: SPMetadataTrack] {
        var items:[String: SPMetadataTrack] = [:]
        for dataArr in response.extendedMetadata {
            if (dataArr.kind != .trackV4) {
                #if DEBUG
                print("Found unexpected meta kind " + String(describing: dataArr.kind))
                #endif
                continue
            }
            for item in dataArr.extensionData {
                if (!item.extensionData.isA(Spotify_Metadata_Track.self)) {
#if DEBUG
                    print("Found unexpected metadata type on tracks data array: " + item.extensionData.typeURL)
#endif
                    continue
                }
                do {
                    let trackMeta = try Spotify_Metadata_Track(unpackingAny: item.extensionData)
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

  ///Get meta info
  ///- Parameter uris: Navigation uri's
  ///- Parameter kind: Meta type
  ///- Parameter completion: Meta info response handler
    fileprivate func getMetadata(uris: [String], kind: Com_Spotify_Extendedmetadata_Proto_ExtensionKind, completion: @escaping (_ response: Result<Com_Spotify_Extendedmetadata_Proto_BatchedExtensionResponse, SPError>) -> Void) {
        guard let safeSpclientAp = spclientAp, let safeProfile = profile, let safeClToken = clientToken, let safeAuthToken = authToken else {
            safeAuthProfileApReq { safeClToken, safeAuthToken, safeProfile, safeAp in
                self.getMetadata(uris: uris, kind: kind, completion: completion)
            }
            return
        }
        var protoHeader = Com_Spotify_Extendedmetadata_Proto_BatchedEntityRequestHeader()
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
        var items: [Com_Spotify_Extendedmetadata_Proto_EntityRequest] = []
        for uri in uris {
            var req = Com_Spotify_Extendedmetadata_Proto_EntityRequest()
            req.uri = uri
            var query = Com_Spotify_Extendedmetadata_Proto_ExtensionQuery()
            query.kind = kind
            req.query.append(query)
            items.append(req)
        }
        getMetadataByApi(apHost: safeSpclientAp, userAgent: userAgent, clToken: safeClToken, authToken: safeAuthToken, os: device.os, appVer: appVersionCode, header: protoHeader, items: items, completion: completion)
    }
}
