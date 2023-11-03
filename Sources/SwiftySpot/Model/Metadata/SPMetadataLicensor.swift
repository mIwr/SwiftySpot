//
//  SPMetadataLicensor.swift
//  SwiftySpot
//
//  Created by Developer on 20.09.2023.
//

///Licensor meta info
public class SPMetadataLicensor {
  ///Licensor UUID
  public let uuid: [UInt8]
  
  public init(uuid: [UInt8]) {
    self.uuid = uuid
  }
  
  static func from(protobuf: Spotify_Metadata_Licensor) -> SPMetadataLicensor {
    let uuid = [UInt8].init(protobuf.uuid)
    return SPMetadataLicensor(uuid: uuid)
  }
}
