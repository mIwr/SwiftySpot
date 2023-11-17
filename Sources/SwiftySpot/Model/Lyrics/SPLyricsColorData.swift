//
//  SPLyricsColorData.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2023.
//

///Represents color parameters for lyrics content view
public class SPLyricsColorData: Decodable {
    
    ///View background color
    public let bg: Int32
    ///Text general color
    public let text: Int32
    ///Currently playing lyrics text color
    public let highlightText: Int32
    
    public init(bg: Int32, text: Int32, highlightText: Int32) {
        self.bg = bg
        self.text = text
        self.highlightText = highlightText
    }
    
    static func from(protobuf: Com_Spotify_Lyrics_Endpointretrofit_Proto_ColorData) -> SPLyricsColorData {
        return SPLyricsColorData(bg: protobuf.background, text: protobuf.text, highlightText: protobuf.highlightText)
    }
}
