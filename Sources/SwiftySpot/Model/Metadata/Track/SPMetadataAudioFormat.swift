//
//  SPMetadataAudioFormat.swift
//  SwiftySpot
//
//  Created by Developer on 19.09.2023.
//

public enum SPMetadataAudioFormat: Int8 {
    case UNKNOWN = -2
    case OGG_VORBIS_96 = 0
    ///Used by default on official client with free plan
    case OGG_VORBIS_160 = 1
    case OGG_VORBIS_320 = 2
    case MP3_256 = 3
    case MP3_320 = 4
    case MP3_160 = 5
    case MP3_96 = 6
    case MP3_160_ENC = 7
    case AAC_24 = 8
    case AAC_48 = 9
    case MP4_128 = 10
    case MP4_128_DUAL = 11
    case MP4_128_CBCS = 12
    case MP4_256 = 13
    case MP4_256_DUAL = 14
    case MP4_256_CBCS = 15
    case FLAC_FLAC = 16
    case MP4_FLAC = 17
    case XHE_AAC_24 = 18
    case XHE_AAC_16 = 19
    case XHE_AAC_12 = 20
    case FLAC_FLAC_24BIT = 22
}

extension SPMetadataAudioFormat {
    static func from(protobuf: Spotify_Metadata_AudioFormat) -> SPMetadataAudioFormat {
        switch (protobuf) {
        case .oggVorbis96: return .OGG_VORBIS_96
        case .oggVorbis160: return .OGG_VORBIS_160
        case .oggVorbis320: return .OGG_VORBIS_320
        case .mp3256: return .MP3_256
        case .mp3320: return .MP3_320
        case .mp3160: return .MP3_160
        case .mp396: return .MP3_96
        case .mp3160Enc: return .MP3_160_ENC
        case .aac24: return .AAC_48
        case .aac48: return .AAC_48
        case .mp4128: return .MP4_128
        case .mp4128Dual: return .MP4_128_DUAL
        case .mp4128Cbcs: return .MP4_128_CBCS
        case .mp4256: return .MP4_256
        case .mp4256Dual: return .MP4_256_DUAL
        case .mp4256Cbcs: return .MP4_256_CBCS
        case .flacFlac: return .FLAC_FLAC
        case .mp4Flac: return .MP4_FLAC
        case .xheAac24: return .XHE_AAC_24
        case .xheAac16: return .XHE_AAC_16
        case .xheAac12: return .XHE_AAC_12
        case .flacFlac24Bit: return .FLAC_FLAC_24BIT
            
        case .UNRECOGNIZED:
            #if DEBUG
            print("Unknown audio format type " + String(protobuf.rawValue))
            #endif
            return .UNKNOWN
        }
    }
    
    
    ///Tested manually on tracks and its formats with free plan
    public var availableFree: Bool {
        switch(self) {
        case .OGG_VORBIS_96: return true
        case .OGG_VORBIS_160: return true
        case .MP3_96: return true
        default: return false
        }
    }
    
    public var oggVorbis: Bool {
        switch(self) {
        case .OGG_VORBIS_96: return true
        case .OGG_VORBIS_160: return true
        case .OGG_VORBIS_320: return true
        default: return false
        }
    }
    
    public var mp3: Bool {
        switch(self) {
        case .MP3_96: return true
        case .MP3_160: return true
        case .MP3_160_ENC: return true
        case .MP3_256: return true
        case .MP3_320: return true
        default: return false
        }
    }
}
