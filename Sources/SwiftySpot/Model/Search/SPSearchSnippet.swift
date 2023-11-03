//
//  SPSearchSnippet.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Search snippet
public class SPSearchSnippet {
  ///Snippet segments
  public let segments: [SPSearchSegment]

  public init(segments: [SPSearchSegment]) {
    self.segments = segments
  }

  static func from(protobuf: Com_Spotify_Searchview_Proto_Snippet) -> SPSearchSnippet {
    var items: [SPSearchSegment] = []
    for item in protobuf.segments {
      let parsed = SPSearchSegment.from(protobuf: item)
      items.append(parsed)
    }
    return SPSearchSnippet(segments: items)
  }
}
