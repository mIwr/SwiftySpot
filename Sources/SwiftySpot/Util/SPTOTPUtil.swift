//
//  SPTotpUtil.swift
//  SwiftySpot
//
//  Created by developer on 17.04.2025.
//

import Foundation

final class SPTOTPUtil {
    
    fileprivate static let _basisBytes: [UInt8] = [0x0c, 0x38, 0x4c, 0x21, 0x58, 0x2c, 0x58, 0x21, 0x4e, 0x4e, 0x0b, 0x42, 0x16, 0x16, 0x37, 0x45, 0x36]

    fileprivate init() {}
    
    static func retrieveSecret(basisBytes: [UInt8] = _basisBytes) -> [UInt8] {
        var secretBytesStr = ""
        //Transform basis bytes
        for i in 0...basisBytes.count - 1 {
            let transformed = basisBytes[i] ^ UInt8(i % 33 + 9)
            secretBytesStr += String(transformed)
        }
        //Each transformed byte to string and join
        guard let secretBytesStrData = secretBytesStr.data(using: .utf8) else {
            return []
        }
        let transformBytes = [UInt8].init(secretBytesStrData)
        return transformBytes
    }
    
    static func generate(serverTs: Int64, digits: Int = 6, timerInterval: Int = 30) -> String {
        let secret = retrieveSecret()
        let counterVal = Int64(floor(TimeInterval(serverTs) / TimeInterval(timerInterval)))
        let hmac = SPCryptoUtil.hmacSha1(key: secret, msg: SPBinaryUtil.getBytes(counterVal, bigEndian: true))
        // Get last 4 bits of hash as offset
        let offset = Int((hmac.last ?? 0x00) & 0x0f)
        guard var number: UInt32 = SPBinaryUtil.getVal(hmac, offset: offset, bigEndian: true) else {
            return ""
        }
        // Mask most significant bit
        number &= 0x7fffffff
        // Modulo number by 10^(digits)
        number = number % UInt32(pow(10, Float(digits)))
        // Convert int to string
        let strNum = String(number)
        // Return string if adding leading zeros is not required
        if strNum.count == digits {
            return strNum
        }
        // Add zeros to start of string if not present and return
        let prefixedZeros = String(repeatElement("0", count: (digits - strNum.count)))
        return (prefixedZeros + strNum)
    }
}
