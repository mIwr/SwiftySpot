//
//  SPSearchResult.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

///Search result data
public class SPSearchResult {

  ///Search matches items
  public let hits: [SPSearchEntity]
  ///Recomendation items according search result
  public let recomendations: SPSearchRecomendations?
  ///Found entity types
  public let entityTypes: [SPSearchEntityType]
  ///Search next page token
  public let nextPageToken: String
  ///UI banner
  public let banner: SPBannerContent?
  ///Related search queries
  public let related: [SPSearchRelated]
  ///Search suggestion
  public let autocomplete: [SPSearchAutocompleteQuery]

  public init(hits: [SPSearchEntity], recomendations: SPSearchRecomendations?, entityTypes: [SPSearchEntityType], nextPageToken: String, banner: SPBannerContent?, related: [SPSearchRelated], autocomplete: [SPSearchAutocompleteQuery]) {
    self.hits = hits
    self.recomendations = recomendations
    self.entityTypes = entityTypes
    self.nextPageToken = nextPageToken
    self.banner = banner
    self.related = related
    self.autocomplete = autocomplete
  }

  static func from(protobuf: SPSearchMainViewResponse) -> SPSearchResult {
    var hits: [SPSearchEntity] = []
    for item in protobuf.hits {
      let parsed = SPSearchEntity.from(protobuf: item)
      hits.append(parsed)
    }
    var entityTypes: [SPSearchEntityType] = []
    let bytes = [UInt8].init(protobuf.entityTypes)
    for b in bytes {
      guard let parsed = SPSearchEntityType(rawValue: b) else { continue }
      entityTypes.append(parsed)
    }
    let recomendations = SPSearchRecomendations.from(protobuf: protobuf.recommendations)
    return SPSearchResult(hits: hits, recomendations: recomendations, entityTypes: entityTypes, nextPageToken: protobuf.nextPageToken, banner: protobuf.banner, related: protobuf.relatedSearches, autocomplete: protobuf.autocompleteQueries)
  }
}
