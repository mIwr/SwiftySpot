//
//  SPSearchPlaylist.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Playlist search match
public class SPSearchPlaylist {
  ///User-related playlist flag
  public let personalized: Bool
  ///Spotify is author flag
  public let ownedBySpotify: Bool
  ///Tracks count
  public let tracksCount: Int
  
  public init(personalized: Bool, ownedBySpotify: Bool, tracksCount: Int) {
    self.personalized = personalized
    self.ownedBySpotify = ownedBySpotify
    self.tracksCount = tracksCount
  }
  
  static func from(protobuf: Com_Spotify_Searchview_Proto_Playlist) -> SPSearchPlaylist {
    return SPSearchPlaylist(personalized: protobuf.personalized, ownedBySpotify: protobuf.ownedBySpotify, tracksCount: Int(protobuf.tracksCount))
  }
}
