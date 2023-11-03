//
//  SPDownloadInfo.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

import Foundation

///Audio file download info
public class SPDownloadInfo {
  ///Download source
  public let result: SPDownloadInfoStatus
  ///Download links
  public let directLinks: [String]
  ///Audio file ID bytes
  public let fileId: [UInt8]
  ///Audio file ID hex string
  public var hexFileId: String {
    get {
      let hex = StringUtil.bytesToHexString(fileId)
      return hex
    }
  }
  ///Download info creation timestamp
  public let createTsUTC: Int64
  ///Download info lifetime duration in seconds
  public let expiresInS: Int32
  ///Direct link expiry datetime (UTC+0)
  public var expiryUTC: Date {
    get {
      let expiryTs = Int64(expiresInS) + createTsUTC
      let dt = Date(timeIntervalSince1970: TimeInterval(expiryTs))

      return dt
    }
  }
  ///Direct link expiry local datetime
  public var expiryLocal: Date {
    get {
      let nowDt = Date()
      let timezoneSecs = TimeZone.current.secondsFromGMT(for: nowDt)
      let expiryTs = Int64(expiresInS) + createTsUTC + Int64(timezoneSecs)
      let dt = Date(timeIntervalSince1970: TimeInterval(expiryTs))

      return dt
    }
  }
  ///Direct link active flag: compares 'expiry 'and 'now' timestamps
  public var active: Bool {
    get {
      let nowTs = Int64(Date().timeIntervalSince1970)
      let expiryTs = Int64(expiresInS) + createTsUTC
      return result == .CDN && nowTs < expiryTs
    }
  }

  public init(result: SPDownloadInfoStatus, directLinks: [String], fileId: [UInt8], createTsUTC: Int64, expiresInS: Int32) {
    self.result = result
    self.directLinks = directLinks
    self.fileId = fileId
    self.createTsUTC = createTsUTC
    self.expiresInS = expiresInS
  }

  static func from(protobuf: Spotify_Playplay_Proto_DownloadInfoResponse, createTs: Int64? = nil) -> SPDownloadInfo {
    let ts = createTs ?? Int64(Date().timeIntervalSince1970)
    let result = SPDownloadInfoStatus.from(protobuf: protobuf.result)
    return SPDownloadInfo(result: result, directLinks: protobuf.directLinks, fileId: [UInt8].init(protobuf.fileID), createTsUTC: ts, expiresInS: protobuf.expiresInS)
  }
}
