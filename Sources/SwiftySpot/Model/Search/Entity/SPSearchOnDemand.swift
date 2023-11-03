//
//  SPSearchOnDemand.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Search on demand match
public class SPSearchOnDemand {
  ///Track navigation uri
  public let trackUri: String
  ///Playlist navigation uri
  public let playlistUri: String
  
  public init(trackUri: String, playlistUri: String) {
    self.trackUri = trackUri
    self.playlistUri = playlistUri
  }
  
  static func from(protobuf: Com_Spotify_Searchview_Proto_OnDemand) -> SPSearchOnDemand {
    return SPSearchOnDemand(trackUri: protobuf.trackUri, playlistUri: protobuf.playlistUri)
  }
}
