//
//  SPBase32.swift
//  SwiftySpot
//
//  Created by developer on 17.04.2025.
//

///Base32  utils
public final class SPBase32 {
    
    fileprivate static let _alphabet: Array<Character> = [
        "A", "B", "C", "D", "E", "F", "G", "H", "I", "J", "K", "L", "M",
        "N", "O", "P", "Q", "R", "S", "T", "U", "V", "W", "X", "Y", "Z",
        "2", "3", "4", "5", "6", "7",
    ]
    fileprivate static let _alphabetSize: UInt64 = UInt64(_alphabet.count)
    fileprivate static let _decodeMap: Array<UInt8> = [
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 26, 27, 28, 29, 30, 31, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18,
        19, 20, 21, 22, 23, 24, 25, 255, 255, 255, 255, 255, 255, 0, 1, 2, 3, 4, 5, 6, 7, 8,
        9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20, 21, 22, 23, 24, 25
    ]// ["B"] -> 1 [A..Z,a..z,2..7]
    
    fileprivate init() {}
    
    public static func encode(_ buff: [UInt8], padding: Bool = true) -> String {
        return encode(buff, alhpabet: _alphabet, padding: padding)
    }
    
    fileprivate static func encode(_ buff: [UInt8], alhpabet: Array<Character>, padding: Bool) -> String {
        if (buff.isEmpty) {
            return ""
        }
        var res = ""
        //regular encode
        var startIndex = 0
        while startIndex + 5 <= buff.count {
            res.insert(alhpabet[Int(buff[startIndex] >> 3)], at: res.endIndex)
            res.insert(alhpabet[Int((buff[startIndex] & 0b00000111) << 2 | buff[startIndex + 1] >> 6)], at: res.endIndex)
            res.insert(alhpabet[Int((buff[startIndex + 1] & 0b00111110) >> 1)], at: res.endIndex)
            res.insert(alhpabet[Int((buff[startIndex + 1] & 0b00000001) << 4 | buff[startIndex + 2] >> 4)], at: res.endIndex)
            res.insert(alhpabet[Int((buff[startIndex + 2] & 0b00001111) << 1 | buff[startIndex + 3] >> 7)], at: res.endIndex)
            res.insert(alhpabet[Int((buff[startIndex + 3] & 0b01111100) >> 2)], at: res.endIndex)
            res.insert(alhpabet[Int((buff[startIndex + 3] & 0b00000011) << 3 | buff[startIndex + 4] >> 5)], at: res.endIndex)
            res.insert(alhpabet[Int((buff[startIndex + 4] & 0b00011111))], at: res.endIndex)
            startIndex += 5
        }
        if (startIndex == buff.count) {
            return res
        }
        // encode last block
        var tempStr = ""
        var byte0, byte1, byte2, byte3, byte4: UInt8
            (byte0, byte1, byte2, byte3, byte4) = (0,0,0,0,0)
        switch (buff.count - startIndex) {
        case 4:
            byte3 = buff[startIndex + 3]
            tempStr.insert(alhpabet[Int((byte3 & 0b00000011) << 3 | byte4 >> 5)], at: tempStr.endIndex)
            tempStr.insert(alhpabet[Int((byte3 & 0b01111100) >> 2)], at: tempStr.endIndex)
            fallthrough
        case 3:
            byte2 = buff[startIndex + 2]
            tempStr.insert(alhpabet[Int((byte2 & 0b00001111) << 1 | byte3 >> 7)], at: tempStr.endIndex)
            fallthrough
        case 2:
            byte1 = buff[startIndex + 1]
            tempStr.insert(alhpabet[Int((byte1 & 0b00000001) << 4 | byte2 >> 4)], at: tempStr.endIndex)
            tempStr.insert(alhpabet[Int((byte1 & 0b00111110) >> 1)], at: tempStr.endIndex)
            fallthrough
        case 1:
            byte0 = buff[startIndex]
            tempStr.insert(alhpabet[Int((byte0 & 0b00000111) << 2 | byte1 >> 6)], at: tempStr.endIndex)
            tempStr.insert(alhpabet[Int(byte0 >> 3)], at: tempStr.endIndex)
        default: break
        }
        res += tempStr.reversed()
        tempStr = ""
        if (!padding) {
            return res
        }
        
        // padding
        let mod = buff.count % 5
        switch (mod) {
        case 0:
            fallthrough
        case 1:
            res += "=="
            fallthrough
        case 2:
            res += "="
            fallthrough
        case 3:
            res += "=="
            fallthrough
        case 4:
            res += "="
            fallthrough
        default:
            break
        }
        
        return res
    }
}
