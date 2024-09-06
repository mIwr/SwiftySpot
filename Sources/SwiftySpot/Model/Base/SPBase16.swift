//
//  SPBase16.swift
//  SwiftySpot
//
//  Created by developer on 03.11.2023.
//

///Base16 (hex) utils
public final class SPBase16 {
    
    fileprivate static let _alphabet = Set<Character>(["0", "1", "2", "3", "4", "5", "6", "7", "8", "9", "A", "B", "C", "D", "E", "F"])
    fileprivate static let _decodeMap: Array<UInt8> = [
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 255, 255, 255,
        255, 255, 255, 255, 10, 11, 12, 13, 14, 15, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255,
        255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 255, 10, 11, 12, 13, 14, 15
    ]// ["A"] -> 10, ["a"] -> 10
    
    fileprivate init() {}
    
    ///Try parse byte array from hex string
    public static func tryDecode(_ hex: String) -> [UInt8]? {
        if (hex.isEmpty) {
            return []
        }
        var mutable = hex.uppercased()
        for ch in mutable {
            if (!_alphabet.contains(ch)) {
                return nil
            }
        }
        if (mutable.count % 2 == 1) {
            mutable.insert("0", at: mutable.startIndex)
        }
        let bytesCount = mutable.count / 2
        var res = [UInt8].init(repeating: 0, count: bytesCount)
        let strBytes: Array<UInt8> = Array(mutable.utf8)
        var index = 0
        while index + 1 < strBytes.count {
            let high = _decodeMap[Int(strBytes[index])]
            let low = _decodeMap[Int(strBytes[index + 1])]
            if (high >= 16 || low >= 16) {
                return nil
            }
            res[index / 2] = high * 16 + low
            index += 2
        }
        return res
    }
    
    ///Parse byte array from hex string. If finds incorrect char, replaces to '0'
    public static func decode(_ hex: String) -> [UInt8] {
        var mutable: String = ""
        for ch in hex.uppercased() {
            if (!_alphabet.contains(ch)) {
                mutable += "0"
                continue
            }
            mutable.insert(ch, at: mutable.endIndex)
        }
        return tryDecode(mutable) ?? []
    }
    
    ///Converts byte array to hex string
    public static func encode(_ buff: [UInt8]) -> String {
        var res = ""
        for item in buff {
            res += String(format: "%02x", item)
        }
        return res
    }
}

protocol BinaryIntegerBase16View {
    var hex: String {
        get
    }
}

extension UInt64: BinaryIntegerBase16View {
    var hex: String {
        get {
            return String(format: "%02x", self)
        }
    }
}

extension UInt32: BinaryIntegerBase16View {
    var hex: String {
        get {
            return String(format: "%02x", self)
        }
    }
}

extension UInt16: BinaryIntegerBase16View {
    var hex: String {
        get {
            return String(format: "%02x", self)
        }
    }
}

extension UInt8: BinaryIntegerBase16View {
    var hex: String {
        get {
            return String(format: "%02x", self)
        }
    }
}

extension Int8: BinaryIntegerBase16View {
    var hex: String {
        get {
            return String(format: "%02x", self)
        }
    }
}

extension Int16: BinaryIntegerBase16View {
    var hex: String {
        get {
            return String(format: "%02x", self)
        }
    }
}

extension Int32: BinaryIntegerBase16View {
    var hex: String {
        get {
            return String(format: "%02x", self)
        }
    }
}

extension Int64: BinaryIntegerBase16View {
    var hex: String {
        get {
            return String(format: "%02x", self)
        }
    }
}
