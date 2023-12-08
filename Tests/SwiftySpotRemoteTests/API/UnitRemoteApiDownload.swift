//
//  UnitApiDownload.swift
//  SwiftySpot
//
//  Created by Developer on 29.09.2023.
//

import XCTest
@testable import SwiftySpot

final class UnitRemoteApiDownload: XCTestCase {

    var client = SPClient(device: TestConstants.device)
    
    override func setUp() {
        let data = TestCredentials.storedCredential.data(using: .utf8) ?? Data()
        let storedCred = [UInt8].init(data)
        client = SPClient(device: TestConstants.device, clToken: TestCredentials.clToken, clTokenExpires: TestCredentials.clExpires, clTokenRefreshAfter: TestCredentials.clRefresh, clTokenCreateTsUTC: TestCredentials.clCreated, authToken: "", authExpiresInS: 1, username: TestCredentials.username, storedCred: storedCred, authTokenCreateTsUTC: 1)
    }
    
    func testPlayIntent() {
        let trackUri = SPNavigateUriUtil.generateTrackUri(id: TestConstants.trackId)
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.getTracksDetails(trackUris: [trackUri]) { result in
            do {
                let meta = try result.get()
                XCTAssertTrue(!meta.isEmpty, "Meta is empty")
                XCTAssertTrue(meta.contains(where: { (key: String, value: SPMetadataTrack) in
                    return key == trackUri
                }), "No target meta object found")
                guard let trackMeta = meta[trackUri] else {
                    XCTAssertFalse(true, "Track meta is nil")
                    exp.fulfill()
                    return
                }
                let quality = SPMetadataAudioFormat.OGG_VORBIS_160
                var audioFileMeta: SPMetadataAudioFile?
                for file in trackMeta.files {
                    if (file.format == quality) {
                        audioFileMeta = file
                        break
                    }
                }
                guard let safeAudioFileMeta = audioFileMeta else {
                    XCTAssertFalse(true, "Track audio format '" + String(describing: quality) + "' is nil")
                    exp.fulfill()
                    return
                }
                _ = self.client.sendPlayIntent(hexFileId: safeAudioFileMeta.hexId, token: TestCredentials.dummyPlayIntentToken) { intentRes in
                    do {
                        let binData = try intentRes.get()
                        XCTAssertTrue(!binData.b4Seq.isEmpty, "b4Seq is empty")
                        XCTAssertTrue(!binData.obfuscatedKey.isEmpty, "b16Seq is empty")
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty metadata object: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty metadata object: " + error.localizedDescription)
            }
            
        }
        waitForExpectations(timeout: 20) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testDownloadAudioChunk() {
        let trackUri = SPNavigateUriUtil.generateTrackUri(id: TestConstants.trackId)
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.getTracksDetails(trackUris: [trackUri]) { result in
            do {
                let meta = try result.get()
                XCTAssertTrue(!meta.isEmpty, "Meta is empty")
                XCTAssertTrue(meta.contains(where: { (key: String, value: SPMetadataTrack) in
                    return key == trackUri
                }), "No target meta object found")
                guard let trackMeta = meta[trackUri] else {
                    XCTAssertFalse(true, "Track meta is nil")
                    exp.fulfill()
                    return
                }
                let quality = SPMetadataAudioFormat.OGG_VORBIS_160
                var audioFileMeta: SPMetadataAudioFile?
                for file in trackMeta.files {
                    if (file.format == quality) {
                        audioFileMeta = file
                        break
                    }
                }
                guard let safeAudioFileMeta = audioFileMeta else {
                    XCTAssertFalse(true, "Track audio format '" + String(describing: quality) + "' is nil")
                    exp.fulfill()
                    return
                }
                _ = self.client.sendPlayIntent(hexFileId: safeAudioFileMeta.hexId, token: TestCredentials.dummyPlayIntentToken) { intentRes in
                    do {
                        let binData = try intentRes.get()
                        XCTAssertTrue(!binData.b4Seq.isEmpty, "b4Seq is empty")
                        XCTAssertTrue(!binData.obfuscatedKey.isEmpty, "b16Seq is empty")
                        let hexKey = StringUtil.bytesToHexString(binData.obfuscatedKey)
                        print("Obfuscated key -> " + hexKey)
                        print("File ID -> " + safeAudioFileMeta.hexId)
                        _ = self.client.requestDownloadInfo(hexFileId: safeAudioFileMeta.hexId) { downloadInfoRes in
                            do {
                                let di = try downloadInfoRes.get()
                                XCTAssertTrue(!di.directLinks.isEmpty, "Track download links' array is empty")
                                guard let safeLink = di.directLinks.first else {
                                    XCTAssertFalse(true, "Track link is nil")
                                    exp.fulfill()
                                    return
                                }
                                _ = self.client.downloadAsChunk(cdnLink: safeLink, offsetInBytes: 0, chunkSizeInBytes: SPDownloadProgress.defaultChunkSizeInBytes, total: nil) { result in
                                    do {
                                        let chunk = try result.get()
                                        let progress = chunk.0
                                        XCTAssertNotEqual(progress.total, 0, "Track total size is 0 bytes")
                                        XCTAssertNotEqual(progress.position, 0, "Range position is 0")
                                        let data = chunk.1
                                        XCTAssertNotEqual(data.count, 0, "Track payload data is 0 bytes")
                                        /*let fm = FileManager.default
                                        guard let downloadsDirUrl = fm.urls(for: .downloadsDirectory, in: .userDomainMask).first else {
                                            XCTAssertFalse(true, "Downloads dir url not found")
                                            exp.fulfill()
                                            return
                                        }
                                        var saveUrl: URL
                                        if #available(macOS 13.0, *) {
                                            saveUrl = downloadsDirUrl.appending(path: "preview.bin")
                                        } else {
                                            saveUrl = downloadsDirUrl.appendingPathComponent("preview.bin")
                                        }
                                        try data.write(to: saveUrl)*/
                                    } catch {
                                        print(error)
                                        XCTAssert(false, "Empty metadata object: " + error.localizedDescription)
                                    }
                                    exp.fulfill()
                                }
                                
                            } catch {
                                print(error)
                                XCTAssert(false, "Empty metadata object: " + error.localizedDescription)
                            }
                        }
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty metadata object: " + error.localizedDescription)
                    }
                    
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty metadata object: " + error.localizedDescription)
            }
            
        }
        waitForExpectations(timeout: 30) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
    
    func testDownloadTrackPreview() {
        let trackUri = SPNavigateUriUtil.generateTrackUri(id: TestConstants.trackId)
        let exp = self.expectation(description: "Request time-out expectation")
        _ = client.getTracksDetails(trackUris: [trackUri]) { result in
            do {
                let meta = try result.get()
                XCTAssertTrue(!meta.isEmpty, "Meta is empty")
                XCTAssertTrue(meta.contains(where: { (key: String, value: SPMetadataTrack) in
                    return key == trackUri
                }), "No target meta object found")
                guard let trackMeta = meta[trackUri] else {
                    XCTAssertFalse(true, "Track meta is nil")
                    exp.fulfill()
                    return
                }
                _ = self.client.downloadTrackPreview(trackMeta, preferFormat: .OGG_VORBIS_160) { result in
                    do {
                        let data = try result.get()
                        XCTAssertNotEqual(data.count, 0, "Track payload data is 0 bytes")
                    } catch {
                        print(error)
                        XCTAssert(false, "Empty preview data: " + error.localizedDescription)
                    }
                    exp.fulfill()
                }
            } catch {
                print(error)
                XCTAssert(false, "Empty metadata object: " + error.localizedDescription)
            }
            
        }
        waitForExpectations(timeout: 30) { error in
            if let g_error = error
            {
                print(g_error)
                XCTAssert(false, "Timeout error: " + g_error.localizedDescription)
            }
        }
    }
}
