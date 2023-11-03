//
//  ConvertUtil.swift
//  SwiftySpot
//
//  Created by Developer on 07.09.2023.
//

import Foundation

///Binary integer utils
public final class BitConvertUtil {
    
    fileprivate init() {}
    
    ///Get bytes from value
    ///- Parameter val: value
    ///- Parameter bigEndian: Extract bytes as big endian order if true, otherwise - as little endian
    @inlinable
    public static func getBytes<T: BinaryInteger>(_ val: T, bigEndian: Bool = true) -> [UInt8] {
        let leBytes = SPByteViewProvider.getLEndianBytes(val)
        if (bigEndian) {
            return leBytes.reversed()
        }
        return leBytes
    }
    
    ///Get Binary Integer value from bytes
    ///- Parameter buffer: Byte array
    ///- Parameter offset: Byte array offset. Default value is 0
    ///- Parameter bigEndian: Extract bytes as Big-Endian order if true, otherwise - as Little-Endian
    @inlinable
    public static func getVal<T: BinaryInteger>(_ buffer: [UInt8], offset: Int = 0, bigEndian: Bool = true) -> T? {
        var res: T = T.zero
        let size = MemoryLayout.size(ofValue: res)
        if (buffer.isEmpty || offset < 0 || offset + size > buffer.count) {
            return nil
        }
        var bitOffset = 0
        if (bigEndian) {
            for i in 0...size - 1 {
                bitOffset = 8 * (size - 1 - i)
                res += T(buffer[offset + i]) << bitOffset
            }
        } else {
            for i in 0...size - 1 {
                bitOffset = 8 * i
                res += T(buffer[offset + i]) << bitOffset
            }
        }
        return res
    }
}
