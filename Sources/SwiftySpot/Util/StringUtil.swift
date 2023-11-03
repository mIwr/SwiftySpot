//
//  StringUtil.swift
//  SwiftySpot
//
//  Created by Developer on 07.09.2023.
//

///String utils
public final class StringUtil {
    
    fileprivate init() {}

  ///Parse byte array from hex string
    public static func hexStringToBytes(_ hex: String) -> [UInt8] {
        return SPBase16.decode(hex)
    }

  ///Convert byte array to hex string
    public static func bytesToHexString(_ buff: [UInt8]) -> String {
        return SPBase16.encode(buff)
    }
}
