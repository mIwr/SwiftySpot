//
//  BitShiftUtil.swift
//  SwiftySpot
//
//  Created by Developer on 04.10.2023.
//

public final class BitShiftUtil {
    
    fileprivate init() {}
    
    public static func rol<T: BinaryInteger>(_ val: T, _ bitCount: Int) -> T {
        if (bitCount <= 0) {
            return val
        }
        let normalizedCount = bitCount % val.bitWidth
        let t1: T = val << normalizedCount
        let t2: T = val >> (val.bitWidth - normalizedCount)
        return t1 | t2
    }
    
    public static func ror<T: BinaryInteger>(_ val: T, _ bitCount: Int) -> T {
        if (bitCount <= 0) {
            return val
        }
        let normalizedCount = bitCount % val.bitWidth
        let t1: T = val >> normalizedCount
        let t2: T = val << (val.bitWidth - normalizedCount)
        return t1 | t2
    }
}
