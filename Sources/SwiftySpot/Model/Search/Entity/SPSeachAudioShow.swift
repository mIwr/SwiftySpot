//
//  SPSeachAudioshow.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

///Audio show search match
public class SPSearchAudioShow {
  ///Publisher name
  public let publisherName: String
  ///Show contains music and talk flag
  public let musicAndTalk: Bool
  ///Show category
  public let category: String
  
  public init(publisherName: String, musicAndTalk: Bool, category: String) {
    self.publisherName = publisherName
    self.musicAndTalk = musicAndTalk
    self.category = category
  }
  
  static func from(protobuf: Com_Spotify_Searchview_Proto_AudioShow) -> SPSearchAudioShow {
    return SPSearchAudioShow(publisherName: protobuf.publisherName, musicAndTalk: protobuf.musicAndTalk, category: protobuf.category)
  }
}
