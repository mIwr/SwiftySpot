//
//  SPCollectionPage.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

///Collection data page
public class SPCollectionPage {

  ///Collection state ID for synchronizing
  public let syncToken: String
  fileprivate let _nextPageToken: String?
  ///Collection next page ID. May be nil, if page is the last or single
  public var nextPageToken: String? {
    get {
      guard let tk = _nextPageToken, !tk.isEmpty else { return nil }
      return tk
    }
  }
  ///Collection items
  public let items: [SPCollectionItem]
  ///Page size paramter for collection
  public let pageSize: UInt

  public init(syncToken: String, nextPageToken: String?, items: [SPCollectionItem], pageSise: UInt) {
    self.syncToken = syncToken
    _nextPageToken = nextPageToken
    self.items = items
    self.pageSize = pageSise
  }

  static func from(protobuf: Com_Spotify_Collection2_V2_Proto_PageResponse, pageSize: UInt) -> SPCollectionPage {
    var items: [SPCollectionItem] = []
    for item in protobuf.items {
      items.append(SPCollectionItem.from(protobuf: item))
    }
    return SPCollectionPage(syncToken: protobuf.syncToken, nextPageToken: protobuf.nextPageToken, items: items, pageSise: pageSize)
  }
}
