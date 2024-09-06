//
//  SPMetadataAudioFile.swift
//  SwiftySpot
//
//  Created by Developer on 19.09.2023.
//

extension SPMetadataAudioFile {
  ///File ID
  public var id: [UInt8] {
    get {
        return [UInt8].init(fileID)
    }
  }
  ///File ID hex string
  public var hexId: String {
    get {
        let hex = SPBase16.encode(id)
      return hex
    }
  }
}
