//
//  SPCryptoUtil.swift
//  SwiftySpot
//
//  Created by Developer on 07.09.2023.
//

import Foundation
#if canImport(CommonCrypto)
import CommonCrypto //SwiftPM can't import it
#else
import CryptoSwift
#endif

final class SPCryptoUtil {
    
    fileprivate init() {}
    
#if canImport(CommonCrypto)
    static func hmacSha1(key: [UInt8], msg: [UInt8]) -> [UInt8] {
        let msgData = Data(msg)
        let keyData = Data(key)
        var hmacData = Data(count: Int(CC_SHA1_DIGEST_LENGTH))
        let hmacStatus = hmacData.withUnsafeMutableBytes{ hmacPtr in
            guard let hmacAddr = hmacPtr.baseAddress else {return kCCParamError}
            let hmacBuffPtr: UnsafeMutablePointer<UInt8> = hmacAddr.assumingMemoryBound(to: UInt8.self)
            let hmacRawPtr = UnsafeMutableRawPointer(hmacBuffPtr)
            return msgData.withUnsafeBytes { msgPtr in
                guard let msgAddr = msgPtr.baseAddress else {return kCCParamError}
                let msgBuffPtr: UnsafePointer<UInt8> = msgAddr.assumingMemoryBound(to: UInt8.self)
                let msgRawPtr = UnsafeRawPointer(msgBuffPtr)
                return keyData.withUnsafeBytes { keyPtr in
                    guard let keyAddr = keyPtr.baseAddress else {return kCCParamError}
                    let keyBuffPtr: UnsafePointer<UInt8> = keyAddr.assumingMemoryBound(to: UInt8.self)
                    let keyRawPtr = UnsafeRawPointer(keyBuffPtr)
                    CCHmac(CCHmacAlgorithm(kCCHmacAlgSHA1), keyRawPtr, key.count, msgRawPtr, msg.count, hmacRawPtr)
                    return kCCSuccess
                }
            }
        }
        if (Int(hmacStatus) != kCCSuccess) {
            print("HMAC-SHA1 error: \(hmacStatus)")
        }

        return [UInt8].init(hmacData)
    }
#else
static func hmacSha1(key: [UInt8], msg: [UInt8]) -> [UInt8] {
    do {
        let hmacEng = HMAC(key: key, variant: .sha1)
        return try hmacEng.authenticate(msg)
    } catch {
#if DEBUG
        print(error)
#endif
    }
    return []
}
#endif
    
#if canImport(CommonCrypto)
    static func sha1(buffer: [UInt8]) -> [UInt8] {
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
    static func sha1(buffer: [UInt8]) -> [UInt8] {
        var data = Data(buffer)
        guard let safeHash = SPSHA1.hash(from: &data) else {return []}
        var digest:[UInt8] = []
        for hashPart in safeHash {
            let val = Int32(truncatingIfNeeded: hashPart)
            let bytes = SPBinaryUtil.getBytes(val)
            digest.append(contentsOf: bytes)
        }
        return digest
    }
#endif
    
    static func sha1String(buffer: [UInt8]) -> String {
        let digest: [UInt8] = sha1(buffer: buffer)
        var digestHex = ""
        for index in 0..<Int(digest.count) {
            digestHex += String(format: "%02x", digest[index])
        }
        return digestHex
    }
    static func hmacSha1String(key: [UInt8], msg: [UInt8]) -> String {
        let digest = hmacSha1(key: key, msg: msg)
        var digestHex = ""
        for index in 0..<Int(digest.count) {
            digestHex += String(format: "%02x", digest[index])
        }
        return digestHex
    }
}
