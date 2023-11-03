//
//  SPMetadataRestriction.swift
//  SwiftySpot
//
//  Created by Developer on 19.09.2023.
//

///Restriction meta info
public class SPMetadataRestriction {
  ///Profile product types requirements
  public let catalogue: [Int32]
  ///Profile product requirements
  public let catalogueStr: [String]
  ///Restriction type
  public let type: Int32
  
  public init(catalogue: [Int32], catalogueStr: [String], type: Int32) {
    self.catalogue = catalogue
    self.catalogueStr = catalogueStr
    self.type = type
  }
  
  static func from(protobuf: Spotify_Metadata_Restriction) -> SPMetadataRestriction {
    return SPMetadataRestriction(catalogue: protobuf.catalogue, catalogueStr: protobuf.catalogueStr, type: protobuf.type)
  }
}
