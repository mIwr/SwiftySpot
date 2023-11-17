//
//  SPLyricsAlternative.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2023.
//

///Represents alternative lyrics variant
public class SPLyricsAlternative: Decodable {
    ///Lyrics language
    public let lang: String
    ///Lyrics lines
    public let content: [SPLyricsLine]
    ///Language type is Right-To-Left
    public let rtlLang: Bool
    
    public init(lang: String, content: [SPLyricsLine], rtlLang: Bool) {
        self.lang = lang
        self.content = content
        self.rtlLang = rtlLang
    }
    
    static func from(protobuf: Com_Spotify_Lyrics_Endpointretrofit_Proto_Alternative) -> SPLyricsAlternative {
        var lines: [SPLyricsLine] = []
        for line in protobuf.lines {
            lines.append(SPLyricsLine.from(protobuf: line))
        }
        return SPLyricsAlternative(lang: protobuf.language, content: lines, rtlLang: protobuf.rtlLang)
    }
}
