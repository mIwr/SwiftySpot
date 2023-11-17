//
//  SPLyricsSyllable.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2023.
//

///Represents syllable of the lyrics line
public class SPLyricsSyllable: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case startTimeMs = "startTimeMs"
        case charsCount = "charsCount"
    }
    
    ///Syllable start timestamp in millis during playback
    public let startTimeMs: Int64
    ///Syllable chars count
    public let charsCount: Int64
    
    public init(startTimeMs: Int64, charsCount: Int64) {
        self.startTimeMs = startTimeMs
        self.charsCount = charsCount
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let safeStartTimeMs = try? container.decode(Int64.self, forKey: .startTimeMs) {
            self.startTimeMs = safeStartTimeMs
        } else if let safeTimeMsStr = try? container.decode(String.self, forKey: .startTimeMs), let safeTimeMsConverted = Int64(safeTimeMsStr) {
            self.startTimeMs = safeTimeMsConverted
        } else {
            self.startTimeMs = 0
        }
        if let safeCharsCount = try? container.decode(Int64.self, forKey: .charsCount) {
            self.charsCount = safeCharsCount
        } else if let safeCharsCountStr = try? container.decode(String.self, forKey: .charsCount), let safeCharsCountConverted = Int64(safeCharsCountStr) {
            self.charsCount = safeCharsCountConverted
        } else {
            self.charsCount = 0
        }
    }
    
    static func from(protobuf: Com_Spotify_Lyrics_Endpointretrofit_Proto_Syllable) -> SPLyricsSyllable {
        return SPLyricsSyllable(startTimeMs: protobuf.startTimeMs, charsCount: protobuf.numChars)
    }
}
