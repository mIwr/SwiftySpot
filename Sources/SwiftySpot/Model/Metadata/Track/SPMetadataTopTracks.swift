//
//  SPMetadataTopTracks.swift
//  SwiftySpot
//
//  Created by Developer on 20.09.2023.
//

///Top tracks meta info
public class SPMetadataTopTracks {
  ///Country code
  public let country: String
  ///Brief meta about tracks
  public let items: [SPMetadataTrack]
  
  public init(country: String, items: [SPMetadataTrack] = []) {
    self.country = country
    self.items = items
  }
  
  static func from(protobuf: SPMetaTopTracks) -> SPMetadataTopTracks {
    var tracks: [SPMetadataTrack] = []
    for item in protobuf.tracks {
      let track = SPMetadataTrack.from(protobuf: item, uri: "")
      tracks.append(track)
    }
    return SPMetadataTopTracks(country: protobuf.country, items: tracks)
  }
}
