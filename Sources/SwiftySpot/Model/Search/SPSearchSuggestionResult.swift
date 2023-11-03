//
//  SPSearchSuggestionResult.swift
//  SwiftySpot
//
//  Created by developer on 01.11.2023.
//

///Search suggestions data
public class SPSearchSuggestionResult {
    
    ///Search suggestions
    public let hits: [SPSearchEntity]
    ///Search suggestion
    public let autocomplete: [SPSearchAutocompleteQuery]
    
    public init(hits: [SPSearchEntity], autocomplete: [SPSearchAutocompleteQuery]) {
        self.hits = hits
        self.autocomplete = autocomplete
    }
    
    static func from(protobuf: Com_Spotify_Searchview_Proto_AutocompleteViewResponse) -> SPSearchSuggestionResult {
        var hits: [SPSearchEntity] = []
        for item in protobuf.hits {
          let parsed = SPSearchEntity.from(protobuf: item)
          hits.append(parsed)
        }
        var autocomplete: [SPSearchAutocompleteQuery] = []
        for item in protobuf.autocompleteQueries {
          let parsed = SPSearchAutocompleteQuery.from(protobuf: item)
          autocomplete.append(parsed)
        }
        
        return SPSearchSuggestionResult(hits: hits, autocomplete: autocomplete)
    }
}
