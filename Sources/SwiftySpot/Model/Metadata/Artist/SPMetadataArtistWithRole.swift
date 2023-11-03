//
//  SPMetadataArtistWithRole.swift
//  SwiftySpot
//
//  Created by Developer on 20.09.2023.
//

///Artist and role meta info
public class SPMetadataArtistWithRole {
  ///Artist GID
  public let gid: [UInt8]
  ///Artist name
  public let name: String
  ///Artist role
  public let role: SPMetadataArtistRole
  
  public init(gid: [UInt8], name: String, role: SPMetadataArtistRole) {
    self.gid = gid
    self.name = name
    self.role = role
  }
  
  static func from(protobuf: Spotify_Metadata_ArtistWithRole) -> SPMetadataArtistWithRole {
    let gid = [UInt8].init(protobuf.gid)
    let role = SPMetadataArtistRole.from(protobuf: protobuf.role)
    return SPMetadataArtistWithRole(gid: gid, name: protobuf.name, role: role)
  }
}
