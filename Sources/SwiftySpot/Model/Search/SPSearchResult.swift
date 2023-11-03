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
  public let banner: SPSearchBannerContent?
  ///Related search queries
  public let related: [SPSearchRelated]
  ///Search suggestion
  public let autocomplete: [SPSearchAutocompleteQuery]

  public init(hits: [SPSearchEntity], recomendations: SPSearchRecomendations?, entityTypes: [SPSearchEntityType], nextPageToken: String, banner: SPSearchBannerContent?, related: [SPSearchRelated], autocomplete: [SPSearchAutocompleteQuery]) {
    self.hits = hits
    self.recomendations = recomendations
    self.entityTypes = entityTypes
    self.nextPageToken = nextPageToken
    self.banner = banner
    self.related = related
    self.autocomplete = autocomplete
  }

  static func from(protobuf: Com_Spotify_Searchview_Proto_MainViewResponse) -> SPSearchResult {
    var hits: [SPSearchEntity] = []
    for item in protobuf.hits {
      let parsed = SPSearchEntity.from(protobuf: item)
      hits.append(parsed)
    }
    var recomendations: SPSearchRecomendations?
    if (protobuf.hasRecommendations && protobuf.recommendations.type > 0) {
      recomendations = SPSearchRecomendations.from(protobuf: protobuf.recommendations)
    }
    var entityTypes: [SPSearchEntityType] = []
    let bytes = [UInt8].init(protobuf.entityTypes)
    for b in bytes {
      guard let parsed = SPSearchEntityType(rawValue: b) else { continue }
      entityTypes.append(parsed)
    }
    var banner: SPSearchBannerContent?
    if (protobuf.hasBanner && !protobuf.banner.url.isEmpty) {
      banner = SPSearchBannerContent.from(protobuf: protobuf.banner)
    }
    var related: [SPSearchRelated] = []
    for item in protobuf.relatedSearches {
      let parsed = SPSearchRelated.from(protobuf: item)
      related.append(parsed)
    }
    var autocomplete: [SPSearchAutocompleteQuery] = []
    for item in protobuf.autocompleteQueries {
      let parsed = SPSearchAutocompleteQuery.from(protobuf: item)
      autocomplete.append(parsed)
    }
    return SPSearchResult(hits: hits, recomendations: recomendations, entityTypes: entityTypes, nextPageToken: protobuf.nextPageToken, banner: banner, related: related, autocomplete: autocomplete)
  }
}
