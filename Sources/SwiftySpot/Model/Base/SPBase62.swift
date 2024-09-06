//
//  Base62Util.swift
//  SwiftySpot
//
//  Created by developer on 30.10.2023.
//

import Foundation

public final class SPBase62 {
    
    fileprivate static let _alphabet: Array<Character> = [
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
        "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
        "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
    ]
    fileprivate static let _alphabetInversed: Array<Character> = [
        "0", "1", "2", "3", "4", "5", "6", "7", "8", "9",
        "a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m",
        "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z",
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
        "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
    ]
    fileprivate static let _alphabetSize: UInt64 = UInt64(_alphabet.count)
    fileprivate static let _decodeMap: Array<UInt8> = [
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 255, 255, 255,
        255, 255, 255, 255, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25, 26, 27, 28,
        29, 30, 31, 32, 33, 34, 35, 255, 255, 255, 255, 255, 255, 36, 37, 38, 39, 40, 41, 42, 43, 44,
        45, 46, 47, 48, 49, 50, 51, 52, 53, 54, 55, 56, 57, 58, 59, 60, 61,
    ]// ["A"] -> 10 [0..9,A..Z,a..z]
    fileprivate static let _decodeMapInversed: Array<UInt8> = [
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 255, 255, 255,
        255, 255, 255, 255, 36, 37, 38, 39, 40, 41, 42, 43, 44, 45, 46, 47, 48, 49, 50, 51, 52, 53, 54,
        55, 56, 57, 58, 59, 60, 61, 255, 255, 255, 255, 255, 255, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19,
        20, 21, 22, 23, 24, 25, 26, 27, 28, 29, 30, 31, 32, 33, 34, 35
    ]// ["A"] -> 10 [0..9,a..z,A..Z]
    
    fileprivate static let _base62Pow10 = SPUInt128(pow(Double(_alphabet.count), 10))//<=10 base62 digits
    fileprivate static let _base62Pow20 = _base62Pow10 * _base62Pow10//<=20 base62 digits
    
    fileprivate init() {}
    
    /// Encodes an UInt128 value as Base62 string value.
    /// - Parameter num: An UIn128 value that should be encoded.
    /// - Parameter inversedAlphabet: Use inversed base62 alphabet basis
    /// - Returns: A base62 encoded string.
    public static func encode(num: SPUInt128, inversedAlphabet: Bool = false) -> String {
        if (inversedAlphabet) {
            return encode(num: num, alphabet: _alphabetInversed)
        }
        return encode(num: num, alphabet: _alphabet)
    }
    
    fileprivate static func encode(num: SPUInt128, alphabet: Array<Character>) -> String {
        //u128 will be have 22 bas62 digits
        var mutableNum = num
        var nlow = UInt64(mutableNum % _base62Pow10)
        var res = ""
        //process 0-20 base62 digits
        for _ in 0...1 {
            for _ in 0...9 {
                let alphabetIndex = Int(nlow % _alphabetSize)
                res.insert(alphabet[alphabetIndex], at: res.startIndex)
                nlow /= _alphabetSize
            }
            mutableNum /= _base62Pow10
            nlow = UInt64(mutableNum % _base62Pow10)
        }
        //process 21-22 base62 digits
        for _ in 0...1 {
            let alphabetIndex = Int(nlow % _alphabetSize)
            res.insert(alphabet[alphabetIndex], at: res.startIndex)
            nlow /= _alphabetSize
        }
        return res
    }
    
    /// Decodes Base62 string value to an UInt128 value.
    /// - Parameter string: A string value that should be decoded.
    /// - Parameter inversedAlphabet: Use inversed base62 decode map
    /// - Returns: A base62 decoded UInt128 value.
    public static func decode(string: String, inversedAlphabet: Bool = false) -> SPUInt128 {
        if (inversedAlphabet) {
            return decode(string: string, decodeMap: _decodeMapInversed)
        }
        return decode(string: string, decodeMap: _decodeMap)
    }

    fileprivate static func decode(string: String, decodeMap: Array<UInt8>) -> SPUInt128 {
        if (string.isEmpty) {
            return 0
        }
        let validateSet = Set<Character>(_alphabet)
        for ch in string {
            if (!validateSet.contains(ch)) {
                return 0
            }
        }
        let reversed = String(string.reversed())
        let strBytes: Array<UInt8> = Array(reversed.utf8)
        var sectionBuff: UInt64 = 0
        var endIndex = 10
        if (strBytes.count < endIndex) {
            endIndex = strBytes.count
        }
        for i in 0...endIndex - 1 {
            let digit = strBytes[endIndex - 1 - i]
            let num = UInt64(decodeMap[Int(digit)])
            if (num > 61) {
                continue
            }
            sectionBuff = sectionBuff * _alphabetSize + num
        }
        if (endIndex < 10) {
            return SPUInt128(sectionBuff)
        }
        var res = SPUInt128(sectionBuff)
        sectionBuff = 0
        endIndex += 10
        if (strBytes.count < endIndex) {
            endIndex = strBytes.count
        }
        for i in 10...endIndex - 1 {
            let digit = strBytes[endIndex - 1 - i + 10]
            let num = UInt64(decodeMap[Int(digit)])
            if (num > 61) {
                continue
            }
            sectionBuff = sectionBuff * _alphabetSize + num
        }
        res += _base62Pow10.multiplied(by: sectionBuff)
        if (endIndex < 20) {
            return res
        }
        sectionBuff = 0
        endIndex += 2
        if (strBytes.count < endIndex) {
            endIndex = strBytes.count
        }
        for i in 20...endIndex - 1 {
            let digit = strBytes[endIndex - 1 - i + 20]
            let num = UInt64(decodeMap[Int(digit)])
            if (num > 61) {
                continue
            }
            sectionBuff = sectionBuff * _alphabetSize + num
        }
        var overflowCheck = _base62Pow20.multipliedReportingOverflow(by: SPUInt128(high: 0, low: sectionBuff))
        if (overflowCheck.overflow) {
            #if DEBUG
            print("Decoding " + string + " overflow error: " + String(sectionBuff) + " * " + String(_base62Pow20))
            #endif
        }
        overflowCheck = res.addingReportingOverflow(overflowCheck.partialValue)
        if (overflowCheck.overflow) {
            #if DEBUG
            print("Decoding " + string + " overflow error: " + String(res) + " + " + String(overflowCheck.partialValue))
            #endif
        }
        return res < overflowCheck.partialValue ? overflowCheck.partialValue : res
    }
}
