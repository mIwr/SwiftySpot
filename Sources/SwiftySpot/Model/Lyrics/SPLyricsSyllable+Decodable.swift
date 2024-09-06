//
//  SPLyricsSyllable.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2023.
//

extension SPLyricsSyllable: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case startTimeMs = "startTimeMs"
        case charsCount = "charsCount"
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
        if let safeCharsCount = try? container.decode(Int64.self, forKey: .charsCount) {
            self.numChars = safeCharsCount
        } else if let safeCharsCountStr = try? container.decode(String.self, forKey: .charsCount), let safeCharsCountConverted = Int64(safeCharsCountStr) {
            self.numChars = safeCharsCountConverted
        } else {
            self.numChars = 0
        }
    }
}
