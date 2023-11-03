//
//  SPMetadataImg.swift
//  SwiftySpot
//
//  Created by Developer on 19.09.2023.
//

///Image meta info
public class SPMetadataImg {
  ///Image ID
  public let id: [UInt8]
  ///Image ID hex string
  public var hexId: String {
    get {
      let hex = StringUtil.bytesToHexString(id)
      return hex
    }
  }
  ///Image size in bytes
  public let size: Int32
  ///Image width in pixels
  public let width: Int32
  ///Image height in pixels
  public let height: Int32
  
  public init(id: [UInt8], size: Int32, width: Int32, height: Int32) {
    self.id = id
    self.size = size
    self.width = width
    self.height = height
  }
  
  static func from(protobuf: Spotify_Metadata_Image) -> SPMetadataImg {
    let id = [UInt8].init(protobuf.fileID)
    return SPMetadataImg(id: id, size: protobuf.size, width: protobuf.width, height: protobuf.height)
  }
  
  static func fromGroup(_ group: [Spotify_Metadata_ImageGroup]) -> [[SPMetadataImg]] {
    var parsedGroup: [[SPMetadataImg]] = []
    for itemGroup in group {
      var items: [SPMetadataImg] = []
      for item in itemGroup.images {
        let parsed = SPMetadataImg.from(protobuf: item)
        items.append(parsed)
      }
      parsedGroup.append(items)
    }
    return parsedGroup
  }
}
