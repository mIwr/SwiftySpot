//
//  SPLyricsLine.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2023.
//

///Represents a single lyrics line with timestamp, text info and syllables
extension SPLyricsLine: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case startTimeMs = "startTimeMs"
        case text = "words"
        case syllables = "syllables"
    }
    
    public var formattedStartTime: String {
        get {
            var temp = startTimeMs / 1000
            var secs = String(temp % 60)
            if (secs.count < 2) {
                secs = "0" + secs
            }
            temp /= 60
            var minutes = String(temp % 60)
            if (minutes.count < 2) {
                minutes = "0" + minutes
            }
            temp /= 60
            if (temp == 0) {
                return minutes + ":" + secs
            }
            return String(temp) + ":" + minutes + ":" + secs
        }
    }
    public var formattedStartTimeWithMs: String {
        get {
            let millis = startTimeMs % 1000
            return formattedStartTime + "." + String(millis)
        }
    }
    
    public var syncedFormattedText: String {
        get {
            return formattedStartTime + " " + text
        }
    }
    
    public init(startTimeMs: Int64, text: String, syllables: [SPLyricsSyllable]) {
        self.startTimeMs = startTimeMs
        self.text = text
        self.syllables = syllables
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let safeStartTimeMs = try? container.decode(Int64.self, forKey: .startTimeMs) {
            self.startTimeMs = safeStartTimeMs
        } else if let safeTimeMsStr = try? container.decode(String.self, forKey: .startTimeMs), let safeTimeMsConverted = Int64(safeTimeMsStr) {
            self.startTimeMs = safeTimeMsConverted
        } else {
            self.startTimeMs = 0
        }
        self.text = try container.decode(String.self, forKey: .text)
        self.syllables = try container.decode([SPLyricsSyllable].self, forKey: .syllables)
    }
}
