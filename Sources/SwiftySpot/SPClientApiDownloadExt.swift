//
//  SPClientApiDownloadExt.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

import Foundation

extension SPClient {
    
    ///Initializes audio download session by retrieving key for decrypting audio file from cache or remote storage
    ///- Parameter hexFileId: Audio file (codec) ID hex string
    ///- Parameter token: Play intent token bytes
    ///- Parameter completion: Play intent data response handler
    public func findOrSendPlayIntent(hexFileId: String, token: [UInt8], completion: @escaping (_ result: Result<SPPlayIntentData, SPError>) -> Void) {
        let pair = downloadInfoStorage.find(hexFileId: hexFileId)
        if let safeIntent = pair.1 {
            completion(.success(safeIntent))
            return
        }
        sendPlayIntent(hexFileId: hexFileId, token: token, completion: completion)
    }
    
    ///Initializes audio download session by retrieving key for decrypting audio file
    ///- Parameter hexFileId: Audio file (codec) ID hex string
    ///- Parameter token: Play intent token bytes
    ///- Parameter completion: Play intent data response handler
    public func sendPlayIntent(hexFileId: String, token: [UInt8], completion: @escaping (_ result: Result<SPPlayIntentData, SPError>) -> Void) {
        guard let safeSpclientAp = spclientAp, let safeClToken = clientToken, let safeAuthToken = authToken else {
            safeAuthApReq { safeClToken, safeAuthToken, safeAp in
                self.sendPlayIntent(hexFileId: hexFileId, token: token, completion: completion)
            }
            return
        }
        var protoReq = Spotify_Playplay_Proto_PlayIntentRequest()
        protoReq.version = 2
        protoReq.token = Data(token)
        protoReq.interactivity = Spotify_Playplay_Proto_Interactivity.interactive
        protoReq.contentType = Spotify_Playplay_Proto_ContentType.audioTrack
        protoReq.timestamp = Int64(Date().timeIntervalSince1970)
        postPlayIntentByApi(apHost: safeSpclientAp, userAgent: userAgent, clToken: safeClToken, authToken: safeAuthToken, os: device.os, appVer: appVersionCode, audioFileHexId: hexFileId, proto: protoReq) { response in
            do {
                let intent = try response.get()
                let parsed = SPPlayIntentData.from(protobuf: intent)
                self.downloadInfoStorage.updatePlayIntents([hexFileId: parsed])
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
    
    ///Retrieves download info with direct links to encrypted audio file from cache if exists and not expired otherwise - from remote storage
    ///- Parameter hexFileId: Audio file (codec) ID hex string
    ///- Parameter completion: Download info response handler
    public func findOrRequestDownloadInfo(hexFileId: String, completion: @escaping (_ result: Result<SPDownloadInfo, SPError>) -> Void) {
        let pair = downloadInfoStorage.find(hexFileId: hexFileId)
        if let safeDi = pair.0 {
            completion(.success(safeDi))
            return
        }
        requestDownloadInfo(hexFileId: hexFileId, completion: completion)
    }
    
    ///Retrieves download info with direct links to encrypted audio file
    ///- Parameter hexFileId: Audio file (codec) ID hex string
    ///- Parameter completion: Download info response handler
    public func requestDownloadInfo(hexFileId: String, completion: @escaping (_ result: Result<SPDownloadInfo, SPError>) -> Void) {
        guard let safeSpclientAp = spclientAp, let safeProfile = profile, let safeClToken = clientToken, let safeAuthToken = authToken else {
            safeAuthProfileApReq { safeClToken, safeAuthToken, safeProfile, safeAp in
                self.requestDownloadInfo(hexFileId: hexFileId, completion: completion)
            }
            return
        }
        getDownloadInfoByApi(apHost: safeSpclientAp, userAgent: userAgent, clToken: safeClToken, authToken: safeAuthToken, os: device.os, appVer: appVersionCode, audioFileHexId: hexFileId, productType: safeProfile.productType) { response in
            do {
                let downloadInfo = try response.get()
                let parsed = SPDownloadInfo.from(protobuf: downloadInfo)
                self.downloadInfoStorage.updateDownloadInfo([parsed])
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
    
    ///Downloads short track preview (Unencrypted)
    ///- Parameter trackMeta: Track metadata
    ///- Parameter preferFormat: Prefer audio format (codec) for track preview. if not stated, the first available format is used
    ///- Parameter completion: Preview audio data response handler
    public func downloadTrackPreview(_ trackMeta: SPMetadataTrack, preferFormat: SPMetadataAudioFormat? = nil, completion: @escaping (_ result: Result<Data, SPError>) -> Void) {
        let previewPaths = trackMeta.previewDownloadUrls
        var previewPath: String = ""
        if let safePreferFormat = preferFormat, let safePath = previewPaths[safePreferFormat] {
            previewPath = safePath
        } else if let safeFirst = previewPaths.values.first {
            previewPath = safeFirst
        } else {
            completion(.failure(.audioPreviewNotFound))
            return
        }
        downloadAsOnePiece(cdnLink: previewPath, completion: completion)
    }
    
    ///Download track without chunks as one piece
    ///Uses the same endpoint to retrieve track data chunk, but without bytes range header
    ///- Parameter cdnLink: Download link
    ///- Parameter decryptHandler: Track bytes decryption function. If not stated, returns downloaded data 'as-is'
    ///- Parameter completion: Download completion handler
    public func downloadAsOnePiece(cdnLink: String, decryptHandler: ((_ trackData: Data) -> Data)? = nil, completion: @escaping (_ result: Result<Data, SPError>) -> Void) {
        let headers: [String: String] = [
            "User-Agent": userAgent,
        ]
        download(headers: headers, fullPath: cdnLink) { response in
            do {
                var data = try response.get()
                if let safeDecrytptHandler = decryptHandler {
                    data = safeDecrytptHandler(data)
                }
                completion(.success(data))
            } catch {
#if DEBUG
                print(error)
#endif
                let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
                completion(.failure(parsed))
            }
        }
    }
    
    ///Download track chunk
    ///Default chunk size is ~512 kb, but can be set custom value
    ///If chunk size is bigger than track total size, Spotify returns all available track data from defined offset. It also means, that track can be downloaded as one chunk by providing very large chunk size parameter
    ///- Parameter cdnLink: Download link
    ///- Parameter offsetInBytes: Track data stream offset in bytes
    ///- Parameter chunkSizeInBytes: Track chunk size in bytes
    ///- Parameter total: Track total size. It is known only after the first chunk download
    ///- Parameter decryptHandler: Track bytes decryption function. If not stated, returns downloaded data 'as-is'
    ///- Parameter completion: Download completion handler with track chunk bytes and download progress meta
    public func downloadAsChunk(cdnLink: String, offsetInBytes: UInt64, chunkSizeInBytes: UInt64 = SPDownloadProgress.defaultChunkSizeInBytes, total: UInt64?, decryptHandler: ((_ trackData: Data) -> Data)? = nil, completion: @escaping (_ result: Result<(SPDownloadProgress, Data), SPError>) -> Void) {
        if (chunkSizeInBytes == 0) {
            completion(.success((SPDownloadProgress(cdnLink: cdnLink, startOffset: offsetInBytes, chunkSize: chunkSizeInBytes, total: total ?? offsetInBytes), Data())))
            return
        }
        if let gTotal = total, gTotal <= offsetInBytes {
            completion(.success((SPDownloadProgress(cdnLink: cdnLink, startOffset: offsetInBytes, chunkSize: chunkSizeInBytes, total: gTotal), Data())))
            return
        }
        let endRange = offsetInBytes + chunkSizeInBytes
        let headers: [String: String] = [
            "User-Agent": userAgent,
            "Range": "bytes=" + String(offsetInBytes) + "-" + String(endRange)
        ]
        downloadWithHeaders(headers: headers, fullPath: cdnLink) { response in
            do {
                //Header example: 'Content-Range: bytes 131072-655359/2772556'
                let pair = try response.get()
                var data = pair.0
                if let safeDecrytptHandler = decryptHandler {
                    data = safeDecrytptHandler(data)
                }
                let headers = pair.1
                var total = total ?? endRange
                if let contentRange = headers["Content-Range"], contentRange.contains("/") {
                    let split = contentRange.split(separator: "/")
                    let totalStr = split[split.count - 1]
                    if let safeTotal = UInt64(totalStr) {
                        total = safeTotal
                    }
                }
                let progress = SPDownloadProgress(cdnLink: cdnLink, startOffset: offsetInBytes, chunkSize: chunkSizeInBytes, total: total)
                completion(.success((progress, data)))
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
