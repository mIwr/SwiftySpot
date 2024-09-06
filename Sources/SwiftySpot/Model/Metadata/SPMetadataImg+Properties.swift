//
//  SPMetadataImg.swift
//  SwiftySpot
//
//  Created by Developer on 19.09.2023.
//

extension SPMetadataImage {
  ///Image ID
  public var id: [UInt8] {
      get {
        return [UInt8].init(fileID)
      }
  }
  ///Image ID hex string
  public var hexId: String {
    get {
        let hex = SPBase16.encode(id)
        return hex
    }
  }
  
  static func fromGroup(_ group: [SPMetadataImageGroup]) -> [[SPMetadataImage]] {
    var parsedGroup: [[SPMetadataImage]] = []
    for itemGroup in group {
      parsedGroup.append(itemGroup.images)
    }
    return parsedGroup
  }
}
