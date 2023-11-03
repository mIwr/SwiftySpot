//
//  SPSearchAudiobook.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Audiobook search match
public class SPSearchAudiobook {
  
  ///Authors
  public let authorNames: [String]
  ///Narrators
  public let narratorNames: [String]
  ///Audiobook is explicit flag
  public let explicit: Bool
  ///Audiobook duration in seconds
  public let durationInS: Int
  ///Audiobook description
  public let desc: String
  ///Audio book search access settings
  public let access: SPSearchAccess
  
  public init(authorNames: [String], narratorNames: [String], explicit: Bool, durationInS: Int, desc: String, access: SPSearchAccess) {
    self.authorNames = authorNames
    self.narratorNames = narratorNames
    self.explicit = explicit
    self.durationInS = durationInS
    self.desc = desc
    self.access = access
  }
  
  static func from(protobuf: Com_Spotify_Searchview_Proto_Audiobook) -> SPSearchAudiobook {
    let access = SPSearchAccess.from(protobuf: protobuf.access)
    return SPSearchAudiobook(authorNames: protobuf.authorNames, narratorNames: protobuf.narratorNames, explicit: protobuf.explicit, durationInS: Int(protobuf.duration.seconds), desc: protobuf.desc, access: access)
  }
}
