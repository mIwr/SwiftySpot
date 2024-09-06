//
//  SPMetadataAudioFormat.swift
//  SwiftySpot
//
//  Created by Developer on 19.09.2023.
//

extension SPMetadataAudioFormat {
    
    ///Tested manually on tracks and its formats with free plan
    public var availableFree: Bool {
        switch(self) {
        case .oggVorbis96: return true
        case .oggVorbis160: return true
        case .mp396: return true
        case .mp4128: return true
        case .mp4128Dual: return true
        default: return false
        }
    }
    
    public var oggVorbis: Bool {
        switch(self) {
        case .oggVorbis96: return true
        case .oggVorbis160: return true
        case .oggVorbis320: return true
        default: return false
        }
    }
    
    public var mp3: Bool {
        switch(self) {
        case .mp396: return true
        case .mp3160: return true
        case .mp3160Enc: return true
        case .mp3256: return true
        case .mp3320: return true
        default: return false
        }
    }
}
