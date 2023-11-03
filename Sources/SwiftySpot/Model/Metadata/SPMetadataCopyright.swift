//
//  SPMetadataCopyright.swift
//  SwiftySpot
//
//  Created by Developer on 20.09.2023.
//

import Foundation

///Copyright meta info
public class SPMetadataCopyright {
  ///Copiryght text
  public let text: String
  ///Copyright type
  public let type: SPMetadataCopyrightType
  
  public init(text: String, type: SPMetadataCopyrightType) {
    self.text = text
    self.type = type
  }
  
  static func from(protobuf: Spotify_Metadata_Copyright) -> SPMetadataCopyright {
    let type = SPMetadataCopyrightType.from(protobuf: protobuf.type)
    return SPMetadataCopyright(text: protobuf.text, type: type)
  }
}
