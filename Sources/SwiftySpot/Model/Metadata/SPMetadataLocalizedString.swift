//
//  SPMetadataLocalizedName.swift
//  SwiftySpot
//
//  Created by Developer on 21.09.2023.
//

///Localized string meta info
public class SPMetadataLocalizedString {
  ///Language code
  public let language: String
  ///Localized string value
  public let value: String
  
  public init(language: String, value: String) {
    self.language = language
    self.value = value
  }
  
  static func from(protobuf: Spotify_Metadata_LocalizedString) -> SPMetadataLocalizedString {
    return SPMetadataLocalizedString(language: protobuf.language, value: protobuf.value)
  }
}
