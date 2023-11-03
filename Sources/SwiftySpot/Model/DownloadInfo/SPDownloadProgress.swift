//
//  SPDownloadProgress.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Audio file chunks download progress
public class SPDownloadProgress {
    public static let defaultChunkSizeInBytes: UInt64 = 524288//512 kb
    
    ///Download link
    public let cdnLink: String
    ///Offset from the start of download object
    public let startOffset: UInt64
    ///Chunk size in bytes
    public let chunkSize: UInt64
    ///Download progress position
    public var position: UInt64 {
        return startOffset + chunkSize
    }
    ///Download object size in bytes
    public let total: UInt64
    ///Remains size in bytes
    public var remains: UInt64 {
        get {
            let delta: Int64 = Int64(total) - Int64(position)
            if (delta < 0) {
                return 0
            }
            return UInt64(delta)
        }
    }
    ///Chunk size for the next download iteration
    public var nextOptimalChunkSize: UInt64 {
        let remainsBytes = remains
        if (remainsBytes >= chunkSize) {
            return chunkSize
        }
        return remainsBytes
    }
    
    public init(cdnLink: String, startOffset: UInt64, chunkSize: UInt64, total: UInt64) {
        self.cdnLink = cdnLink
        self.startOffset = startOffset
        self.chunkSize = chunkSize
        self.total = total
    }
}
