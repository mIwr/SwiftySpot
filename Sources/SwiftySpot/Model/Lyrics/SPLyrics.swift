//
//  SPLyrics.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2023.
//

import Foundation

///Represents lyrics info for defined object
public class SPLyrics {
    
    public let target: SPTypedObj
    
    enum CodingKeys: String, CodingKey {
        case target = "target"
        case colorData = "colorData"
        case vocalRemoval = "vocalRemoval"
        case vocalRemovalColorData = "vocalRemovalColorData"
        case syncType = "syncType"
        case content = "lines"
        case provider = "provider"
        case providerID = "providerID"
        case providerDisplayName = "providerDisplayName"
        case syncLyricsUri = "syncLyricsUri"
        case alternatives = "alternatives"
        case lang = "language"
        case rtlLang = "rtl"
        case showUpsell = "showUpsell"
    }
    
    ///Lyrics content view colors info
    public let colorData: SPLyricsColorData
    ///TODO
    public let vocalRemoval: Bool
    ///TODO
    public let vocalRemovalColorData: SPLyricsColorData?
    
    public let syncType: SPLyricsSyncType
    ///Lyrics lines
    public let content: [SPLyricsLine]
    ///Lyrics provider
    public let provider: String
    ///Lyrics provider ID
    public let providerID: String
    ///Lyrics provider display name
    public let providerDisplayName: String
    public let syncLyricsUri: String
    ///Lyrics alternative variants
    public let alternatives: [SPLyricsAlternative]
    ///Lyrics language code
    public let lang: String
    ///Language type is Right-To-Left
    public let rtlLang: Bool
    ///TODO
    public let showUpsell: Bool
    
    public var formattedLyricsLines: [String] {
        if (content.isEmpty) {
            return []
        }
        var lines: [String] = [String].init(repeating: "", count: content.count)
        if (syncType == .unsynced) {
            for i in 0...lines.count - 1 {
                lines[i] = content[i].text
            }
        } else {
            for i in 0...lines.count - 1 {
                lines[i] = content[i].syncedFormattedText
            }
        }
        return lines
    }
    
    public var formattedFullLyricsText: String {
        var text = ""
        for line in formattedLyricsLines {
            text += line + "\n"
        }
        return text
    }
    
    public init(target: SPTypedObj, colorData: SPLyricsColorData, vocalRemoval: Bool, vocalRemovalColorData: SPLyricsColorData?, syncType: SPLyricsSyncType, content: [SPLyricsLine], provider: String, providerID: String, providerDisplayName: String, syncLyricsUri: String, alternatives: [SPLyricsAlternative], lang: String, rtlLang: Bool, showUpsell: Bool) {
        self.target = target
        self.colorData = colorData
        self.vocalRemoval = vocalRemoval
        self.vocalRemovalColorData = vocalRemovalColorData
        self.syncType = syncType
        self.content = content
        self.provider = provider
        self.providerID = providerID
        self.providerDisplayName = providerDisplayName
        self.syncLyricsUri = syncLyricsUri
        self.alternatives = alternatives
        self.lang = lang
        self.rtlLang = rtlLang
        self.showUpsell = showUpsell
    }
    
    static func from(protobuf: Com_Spotify_Lyrics_Endpointretrofit_Proto_ColorLyricsResponse, target: SPTypedObj) -> SPLyrics {
        let colorData = SPLyricsColorData.from(protobuf: protobuf.colorData)
        var lines: [SPLyricsLine] = []
        for line in protobuf.lyrics.lines {
            lines.append(SPLyricsLine.from(protobuf: line))
        }
        var alternatives: [SPLyricsAlternative] = []
        for alternative in protobuf.lyrics.alternatives {
            alternatives.append(SPLyricsAlternative.from(protobuf: alternative))
        }
        var vocalRemovalColorData: SPLyricsColorData? = nil
        if (protobuf.hasVocalRemovalColorData) {
            vocalRemovalColorData = SPLyricsColorData.from(protobuf: protobuf.vocalRemovalColorData)
        }
        let syncType = SPLyricsSyncType.from(protobuf: protobuf.lyrics.syncType)
        return SPLyrics(target: target, colorData: colorData, vocalRemoval: protobuf.vocalRemoval, vocalRemovalColorData: vocalRemovalColorData, syncType: syncType, content: lines, provider: protobuf.lyrics.provider, providerID: protobuf.lyrics.providerLyricsID, providerDisplayName: protobuf.lyrics.providerDisplayName, syncLyricsUri: protobuf.lyrics.syncLyricsUri, alternatives: alternatives, lang: protobuf.lyrics.lang, rtlLang: protobuf.lyrics.rtlLang, showUpsell: protobuf.lyrics.showUpsell)
    }
    
    static func from(json: [String: Any], target: SPTypedObj) -> SPLyrics? {
        guard let safeSyncType = json[CodingKeys.syncType.rawValue] as? String, let safeLinesArr = json[CodingKeys.content.rawValue] as? [[String: Any]] else {
            return nil
        }
        let syncType = SPLyricsSyncType.from(jsonKey: safeSyncType) ?? .unsynced
        var lines: [SPLyricsLine] = []
        for dict in safeLinesArr {
            do {
                let data = try JSONSerialization.data(withJSONObject: dict)
                let parsed = try JSONDecoder().decode(SPLyricsLine.self, from: data)
                lines.append(parsed)
            } catch {
                #if DEBUG
                print("Unable to parse lyrics line", error)
                #endif
                continue
            }
        }
        let colorData = SPLyricsColorData(bg: 0, text: 0, highlightText: 0)
        
        return SPLyrics(target: target, colorData: colorData, vocalRemoval: false, vocalRemovalColorData: nil, syncType: syncType, content: lines, provider: "MusixMatch", providerID: "", providerDisplayName: "MusixMatch", syncLyricsUri: "", alternatives: [], lang: "", rtlLang: false, showUpsell: false)
    }
}
