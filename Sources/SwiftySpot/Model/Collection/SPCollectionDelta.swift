//
//  SPCollectionDelta.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

///Collection, which represent data comparing with actual collection (remote) and current (local) by sync token
public class SPCollectionDelta {
  ///Local collection may be update flag
  public let updatePossible: Bool
  ///Actual collection state ID for synchronizing
  public let syncToken: String
  ///Collection items
  public let items: [SPCollectionItem]

  public init(updatePossible: Bool, syncToken: String, items: [SPCollectionItem]) {
    self.updatePossible = updatePossible
    self.syncToken = syncToken
    self.items = items
  }

  static func from(protobuf: Com_Spotify_Collection2_V2_Proto_DeltaResponse) -> SPCollectionDelta {
    var items: [SPCollectionItem] = []
    for item in protobuf.items {
      items.append(SPCollectionItem.from(protobuf: item))
    }
    return SPCollectionDelta(updatePossible: protobuf.deltaUpdatePossible, syncToken: protobuf.syncToken, items: items)
  }
}
