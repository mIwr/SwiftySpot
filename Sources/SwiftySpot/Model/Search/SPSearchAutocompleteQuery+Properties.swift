//
//  SPSearchAutocompleteQuery.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

extension SPSearchAutocompleteQuery {
    public var query: String {
        get {
            var res = ""
            for segment in snippet.segments {
                res += segment.value + " "
            }
            if (!res.isEmpty) {
                res.removeLast()
                return res
            }
            let typedObj = SPTypedObj(uri: uri)
            return typedObj.id.replacingOccurrences(of: "+", with: " ")
        }
    }
    
    public init(uri: String, snippet: SPSearchSnippet, chipText: String) {
        self.snippet = snippet
        self.chipText = chipText
        self.uri = uri
    }
}
