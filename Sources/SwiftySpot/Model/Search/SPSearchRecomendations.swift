//
//  SPRecomendations.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Search recomendations
public class SPSearchRecomendations {

  ///Object type
  public let type: Int
  ///Search items
  public let entities: [SPSearchEntity]

  public init(type: Int, entities: [SPSearchEntity]) {
    self.type = type
    self.entities = entities
  }

  static func from(protobuf: Com_Spotify_Searchview_Proto_Recommendations) -> SPSearchRecomendations {
    var items: [SPSearchEntity] = []
    for item in protobuf.entities {
      let parsed = SPSearchEntity.from(protobuf: item)
      items.append(parsed)
    }
    return SPSearchRecomendations(type: Int(protobuf.type), entities: items)
  }
}
