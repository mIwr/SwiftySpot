//
//  SPWdvSeektable.swift
//  SwiftySpot
//
//  Created by developer on 04.06.2024.
//

import Foundation

///Spotify track DRM meta
public class SPWDVSeektable: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case version = "seektable_version"
        case pssh
        case offset
        case timescale
        case segments
        case encoderDelaySamples = "encoder_delay_samples"
        case paddingSamples = "padding_samples"
        case indexRange = "index_range"
    }
    
    ///Seektable version
    public let version: String
    ///Protection System Specific Header base64 string
    public let pssh: String
    ///TODO
    public let offset: UInt32
    ///TODO
    public let timescale: UInt32
    ///TODO
    public let segments: [[UInt32]]
    ///TODO
    public let encoderDelaySamples: UInt32
    ///TODO
    public let paddingSamples: UInt32
    ///TODO
    public let indexRange: [UInt32]
    
    public init(version: String, pssh: String, offset: UInt32, timescale: UInt32, segments: [[UInt32]], encoderDelaySamples: UInt32, paddingSamples: UInt32, indexRange: [UInt32]) {
        self.version = version
        self.pssh = pssh
        self.offset = offset
        self.timescale = timescale
        self.segments = segments
        self.encoderDelaySamples = encoderDelaySamples
        self.paddingSamples = paddingSamples
        self.indexRange = indexRange
    }
    
    required public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.version = (try? container.decode(String.self, forKey: .version)) ?? ""
        self.pssh = try container.decode(String.self, forKey: .pssh)
        self.offset = (try? container.decode(UInt32.self, forKey: .offset)) ?? 0
        self.timescale = (try? container.decode(UInt32.self, forKey: .timescale)) ?? 0
        self.segments = (try? container.decode([[UInt32]].self, forKey: .segments)) ?? []
        self.encoderDelaySamples = (try? container.decode(UInt32.self, forKey: .encoderDelaySamples)) ?? 0
        self.paddingSamples = (try? container.decode(UInt32.self, forKey: .paddingSamples)) ?? 0
        self.indexRange = (try? container.decode([UInt32].self, forKey: .indexRange)) ?? []
    }
}
