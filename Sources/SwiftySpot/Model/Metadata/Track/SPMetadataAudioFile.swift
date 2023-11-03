//
//  SPMetadataAudioFile.swift
//  SwiftySpot
//
//  Created by Developer on 19.09.2023.
//

///Audio file meta info
public class SPMetadataAudioFile {
  ///File ID
  public let id: [UInt8]
  ///File ID hex string
  public var hexId: String {
    get {
      let hex = StringUtil.bytesToHexString(id)
      return hex
    }
  }
  ///Audio file format (codec)
  public let format: SPMetadataAudioFormat
  
  public init(id: [UInt8], format: SPMetadataAudioFormat) {
    self.id = id
    self.format = format
  }
  
  static func from(protobuf: Spotify_Metadata_AudioFile) -> SPMetadataAudioFile {
    let id = [UInt8].init(protobuf.fileID)
    let format = SPMetadataAudioFormat.from(protobuf: protobuf.format)
    return SPMetadataAudioFile(id: id, format: format)
  }
}
