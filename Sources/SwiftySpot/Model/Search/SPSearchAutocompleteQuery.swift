//
//  SPSearchAutocompleteQuery.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Search suggestion
public class SPSearchAutocompleteQuery: SPTypedObj {
    ///Suggestion snippet
    public let snippet: SPSearchSnippet
    ///Suggestion text
    public let chipText: String
    
    public var query: String {
        get {
            var res = ""
            for segment in snippet.segments {
                res += segment.segVal + " "
            }
            if (!res.isEmpty) {
                res.removeLast()
                return res
            }
            return id.replacingOccurrences(of: "+", with: " ")
        }
    }
    
    public init(uri: String, snippet: SPSearchSnippet, chipText: String) {
        self.snippet = snippet
        self.chipText = chipText
        super.init(uri: uri)
    }
    
    static func from(protobuf: Com_Spotify_Searchview_Proto_AutocompleteQuery) -> SPSearchAutocompleteQuery {
        let snippet = SPSearchSnippet.from(protobuf: protobuf.snippet)
        return SPSearchAutocompleteQuery(uri: protobuf.uri, snippet: snippet, chipText: protobuf.chipText)
    }
}
