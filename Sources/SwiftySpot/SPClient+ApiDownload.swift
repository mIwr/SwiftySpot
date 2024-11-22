//
//  SPClientApiDownloadExt.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension SPClient {
    
    ///Initializes download session by retrieving key for decrypting audio file from cache or remote storage
    ///- Parameter hexFileId: File (codec) ID hex string
    ///- Parameter completion: Wdv intent data response handler
    ///- Returns: API request session task
    public func findOrRequestWdvSeektable(hexFileId: String, completion: @escaping (_ result: Result<SPWDVSeektable, SPError>) -> Void) -> URLSessionDataTask? {
        let info = downloadInfoStorage.find(hexFileId: hexFileId)
        if let safeWdvSeektable = info.2 {
            completion(.success(safeWdvSeektable))
            return nil
        }
        return requestWdvSeektable(hexFileId: hexFileId, completion: completion)
    }
    
    public func requestWdvSeektable(hexFileId: String, completion: @escaping (_ result: Result<SPWDVSeektable, SPError>) -> Void) -> URLSessionDataTask? {
        let task = getWdvSeektableByApi(fileHexId: hexFileId) { response in
            do {
                let seektable = try response.get()
                self.downloadInfoStorage.updateSeektables([hexFileId: seektable])
                completion(.success(seektable))
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
    
    func requestAudioWdvIntentUrl(completion: @escaping (_ result: Result<SPWDVLicUrl, SPError>) -> Void) -> URLSessionDataTask? {
        return requestWdvIntentUrl(fileType: "audio", completion: completion)
    }
    
    func requestVideoWdvIntentUrl(completion: @escaping (_ result: Result<SPWDVLicUrl, SPError>) -> Void) -> URLSessionDataTask? {
        return requestWdvIntentUrl(fileType: "video", completion: completion)
    }
    
    func requestWdvIntentUrl(fileType: String, completion: @escaping (_ result: Result<SPWDVLicUrl, SPError>) -> Void) -> URLSessionDataTask? {
        //filetype: "audio" or "video"
        return safeAuthApReq { safeClToken, safeAuthToken, safeAp in
            let os = "WebPlayer"
            let task = getWdvIntentUrlByApi(apHost: safeAp, userAgent: self.webUserAgent, clToken: safeClToken, authToken: safeAuthToken, os: os, appVer: self.webAppVersionCode, fileType: fileType) { response in
                    do {
                        let licUrl = try response.get()
                        completion(.success(licUrl))
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
    
    public func requestAudioWdvIntent(challenge: [UInt8], completion: @escaping (_ result: Result<Data, SPError>) -> Void) -> URLSessionDataTask? {
        return requestWdvIntent(fileType: "audio", challenge: challenge, completion: completion)
    }
    
    public func requestVideoWdvIntent(challenge: [UInt8], completion: @escaping (_ result: Result<Data, SPError>) -> Void) -> URLSessionDataTask? {
        return requestWdvIntent(fileType: "video", challenge: challenge, completion: completion)
    }
    
    public func requestWdvIntent(fileType: String, challenge: [UInt8], completion: @escaping (_ result: Result<Data, SPError>) -> Void) -> URLSessionDataTask? {
        //filetype: "audio" or "video"
        return safeAuthApReq { safeClToken, safeAuthToken, safeAp in
            let os = "WebPlayer"
            let task = postWdvIntentByApi(apHost: safeAp, userAgent: self.webUserAgent, clToken: safeClToken, authToken: safeAuthToken, os: os, appVer: self.webAppVersionCode, fileType: fileType, challenge: challenge) { response in
                    do {
                        let intent = try response.get()
                        completion(.success(intent))
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
    
    ///Initializes audio download session by retrieving key for decrypting audio file from cache or remote storage
    ///- Parameter hexFileId: Audio file (codec) ID hex string
    ///- Parameter token: Play intent token bytes
    ///- Parameter completion: Play intent data response handler
    ///- Returns: API request session task
    public func findOrSendPlayIntent(hexFileId: String, token: [UInt8], completion: @escaping (_ result: Result<SPPlayIntentResponse, SPError>) -> Void) -> URLSessionDataTask? {
        let pair = downloadInfoStorage.find(hexFileId: hexFileId)
        if let safeIntent = pair.1 {
            completion(.success(safeIntent))
            return nil
        }
        return sendPlayIntent(hexFileId: hexFileId, token: token, completion: completion)
    }
    
    ///Initializes audio download session by retrieving key for decrypting audio file
    ///- Parameter hexFileId: Audio file (codec) ID hex string
    ///- Parameter token: Play intent token bytes
    ///- Parameter completion: Play intent data response handler
    ///- Returns: API request session task
    public func sendPlayIntent(hexFileId: String, token: [UInt8], completion: @escaping (_ result: Result<SPPlayIntentResponse, SPError>) -> Void) -> URLSessionDataTask? {
        return safeAuthApReq { safeClToken, safeAuthToken, safeAp in
            var protoReq = SPPlayIntentRequest()
            protoReq.version = 2
            protoReq.token = Data(token)
            protoReq.interactivity = SPInteractivity.interactive
            protoReq.contentType = SPContentType.audioTrack
            protoReq.timestamp = Int64(Date().timeIntervalSince1970)
            let task = postPlayIntentByApi(apHost: safeAp, userAgent: self.userAgent, clToken: safeClToken, authToken: safeAuthToken, os: self.device.os, appVer: self.appVersionCode, audioFileHexId: hexFileId, proto: protoReq) { response in
                do {
                    let intent = try response.get()
                    self.downloadInfoStorage.updatePlayIntents([hexFileId: intent])
                    completion(.success(intent))
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
    
    ///Retrieves download info with direct links to encrypted audio file from cache if exists and not expired otherwise - from remote storage
    ///- Parameter hexFileId: Audio file (codec) ID hex string
    ///- Parameter completion: Download info response handler
    ///- Returns: API request session task
    public func findOrRequestDownloadInfo(hexFileId: String, completion: @escaping (_ result: Result<SPDownloadInfo, SPError>) -> Void) -> URLSessionDataTask? {
        let pair = downloadInfoStorage.find(hexFileId: hexFileId)
        if let safeDi = pair.0 {
            completion(.success(safeDi))
            return nil
        }
        return requestDownloadInfo(hexFileId: hexFileId, completion: completion)
    }
    
    ///Retrieves download info with direct links to encrypted audio file. Can be executed with guest authorization
    ///- Parameter hexFileId: Audio file (codec) ID hex string
    ///- Parameter completion: Download info response handler
    ///- Returns: API request session task
    public func requestDownloadInfo(hexFileId: String, completion: @escaping (_ result: Result<SPDownloadInfo, SPError>) -> Void) -> URLSessionDataTask? {
        return safeAuthIncludingGuestProfileApReq { safeClToken, safeAuthToken, safeProfile, safeAp in
            let task = getDownloadInfoByApi(apHost: safeAp, userAgent: self.userAgent, clToken: safeClToken, authToken: safeAuthToken, os: self.device.os, appVer: self.appVersionCode, audioFileHexId: hexFileId, productType: safeProfile.productType) { response in
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
            return task
        }
    }
    
    ///Downloads short track preview (Unencrypted)
    ///- Parameter trackMeta: Track metadata
    ///- Parameter preferFormat: Prefer audio format (codec) for track preview. if not stated, the first available format is used
    ///- Parameter completion: Preview audio data response handler
    ///- Returns: Data request session task
    public func downloadTrackPreview(_ trackMeta: SPMetadataTrack, preferFormat: SPMetadataAudioFormat? = nil, completion: @escaping (_ result: Result<Data, SPError>) -> Void) -> URLSessionDataTask? {
        let previewPaths = trackMeta.previewDownloadUrls
        var previewPath: String = ""
        if let safePreferFormat = preferFormat, let safePath = previewPaths[safePreferFormat] {
            previewPath = safePath
        } else if let safeFirst = previewPaths.values.first {
            previewPath = safeFirst
        } else {
            completion(.failure(.audioPreviewNotFound))
            return nil
        }
        let task = downloadAsOnePiece(cdnLink: previewPath) { result in
            if let safeData = try? result.get(), !safeData.isEmpty {
                completion(result)
                return
            }
            //data is nil or empty -> Reserve download
            if let safePreviewMp3Format = trackMeta.findPreviewAudioFile(codec: .mp396) {
                _ = self.downloadTrackPreviewReserve(mp3HexFileId: safePreviewMp3Format.hexId, completion: completion)
                return
                
            } else if let safeMp3Format = trackMeta.findAudioFile(codec: .mp396) {
                _ = self.downloadTrackPreviewReserve(mp3HexFileId: safeMp3Format.hexId, completion: completion)
                return
            }
            completion(result)
        }
        return task
    }
    
    func downloadTrackPreviewReserve(mp3HexFileId: String, completion: @escaping (_ result: Result<Data, SPError>) -> Void) -> URLSessionDataTask? {
        let headers: [String: String] = [
            "Icy-MetaData": "1",
            "User-Agent": "previewplayer",
            "Accept-Encoding": "identity",
        ]
        let link = SPConstants.defaultPreviewCdnHost + "mp3-preview/" + mp3HexFileId
        let task = download(headers: headers, fullPath: link, completion: completion)
        return task
    }
    
    ///Download track without chunks as one piece
    ///Uses the same endpoint to retrieve track data chunk, but without bytes range header
    ///- Parameter cdnLink: Download link
    ///- Parameter decryptHandler: Track bytes decryption function. If not stated, returns downloaded data 'as-is'
    ///- Parameter completion: Download completion handler
    ///- Returns: API request session task
    public func downloadAsOnePiece(cdnLink: String, decryptHandler: ((_ trackData: Data) -> Data)? = nil, completion: @escaping (_ result: Result<Data, SPError>) -> Void) -> URLSessionDataTask? {
        let headers: [String: String] = [
            "User-Agent": userAgent,
        ]
        let task = download(headers: headers, fullPath: cdnLink) { response in
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
        return task
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
    ///- Returns: API request session task
    public func downloadAsChunk(cdnLink: String, offsetInBytes: UInt64, chunkSizeInBytes: UInt64 = SPDownloadProgress.defaultChunkSizeInBytes, total: UInt64?, decryptHandler: ((_ trackData: Data) -> Data)? = nil, completion: @escaping (_ result: Result<(SPDownloadProgress, Data), SPError>) -> Void) -> URLSessionDataTask? {
        if (chunkSizeInBytes == 0) {
            completion(.success((SPDownloadProgress(cdnLink: cdnLink, startOffset: offsetInBytes, chunkSize: chunkSizeInBytes, total: total ?? offsetInBytes), Data())))
            return nil
        }
        if let gTotal = total, gTotal <= offsetInBytes {
            completion(.success((SPDownloadProgress(cdnLink: cdnLink, startOffset: offsetInBytes, chunkSize: chunkSizeInBytes, total: gTotal), Data())))
            return nil
        }
        let endRange = offsetInBytes + chunkSizeInBytes
        let headers: [String: String] = [
            "User-Agent": userAgent,
            "Range": "bytes=" + String(offsetInBytes) + "-" + String(endRange)
        ]
        let task = downloadWithHeaders(headers: headers, fullPath: cdnLink) { response in
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
        return task
    }
}
