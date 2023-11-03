//
//  SPMetadataBiography.swift
//  SwiftySpot
//
//  Created by Developer on 20.09.2023.
//

///Bio meta data
public class SPMetadataBiography {
  ///Bio text
  public let text: String
  ///Biography portraits
  public let portraitVariants: [SPMetadataImg]
  ///Biography portraits by sizes group
  public let portraitGroup: [[SPMetadataImg]]
  
  public init(text: String, portraitVariants: [SPMetadataImg] = [], portraitGroup: [[SPMetadataImg]] = []) {
    self.text = text
    self.portraitVariants = portraitVariants
    self.portraitGroup = portraitGroup
  }
  
  static func from(protobuf: Spotify_Metadata_Biography) -> SPMetadataBiography {
    var portraitVariants: [SPMetadataImg] = []
    for item in protobuf.portraitVariants {
      let parsed = SPMetadataImg.from(protobuf: item)
      portraitVariants.append(parsed)
    }
    let portraitGroup = SPMetadataImg.fromGroup(protobuf.portraitGroups)
    return SPMetadataBiography(text: protobuf.text, portraitVariants: portraitVariants, portraitGroup: portraitGroup)
  }
}
