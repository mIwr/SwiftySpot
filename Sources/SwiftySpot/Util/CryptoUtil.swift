//
//  CryptoUtil.swift
//  SwiftySpot
//
//  Created by Developer on 07.09.2023.
//

import Foundation
#if canImport(CommonCrypto)
import CommonCrypto //SwiftPM can't import it
#endif

public final class CryptoUtil {
    
    fileprivate init() {}
    
    #if canImport(CommonCrypto)
    public static func sha1(buffer: [UInt8]) -> [UInt8] {
        var digest: [UInt8] = [UInt8].init(repeating: 0, count: Int(CC_SHA1_DIGEST_LENGTH))
        let data = Data(buffer)
        data.withUnsafeBytes{ (unsafePointer) -> Void in
            guard let addr = unsafePointer.baseAddress else {return}
            let bufferPointer: UnsafePointer<UInt8> = addr.assumingMemoryBound(to: UInt8.self)
            let rawPtr = UnsafeRawPointer(bufferPointer)
            CC_SHA1(rawPtr, CC_LONG(data.count), &digest)
        }
        return digest
    }
    #else
    //TODO find fast standalone SHA1
    public static func sha1(buffer: [UInt8]) -> [UInt8] {
        var data = Data(buffer)
        guard let safeHash = SPSHA1.hash(from: &data) else {return []}
        var digest:[UInt8] = []
        for hashPart in safeHash {
            let val = Int32(truncatingIfNeeded: hashPart)
            let bytes = BitConvertUtil.getBytes(val)
            digest.append(contentsOf: bytes)
        }
        return digest
    }
    #endif
    
    public static func sha1String(buffer: [UInt8]) -> String {
        let digest: [UInt8] = sha1(buffer: buffer)
        var digestHex = ""
        for index in 0..<Int(digest.count) {
            digestHex += String(format: "%02x", digest[index])
        }
        return digestHex
    }
}
