//
//  BinaryIntExt.swift
//  SwiftySpot
//
//  Created by developer on 03.11.2023.
//

public final class SPByteViewProvider {
    
    fileprivate init() {}
    
    @inlinable
    public static func getLEndianBytes<T: BinaryInteger>(_ val: T) -> Array<UInt8> {
        let size = MemoryLayout.size(ofValue: val)
        var res = Array<UInt8>.init(repeating: 0, count: size)
        if (val is Int8) {
            //Int8 max value is 0x7F -> transform to UInt8 and restart
            let int8Val = Int8(val)
            return getLEndianBytes(UInt8(bitPattern: int8Val))
        }
        let mask: T = 0xFF
        var mutable = val
        for i in (0..<size) {
          res[i] = UInt8(mutable & mask)
            mutable >>= 8
        }
        return res
    }
}

///Bytes view representation for binary integer values
public protocol BinaryIntegerByteView {
    ///Big-Endian bytes view
    var beBytes: [UInt8] {
         get
    }
    
    ///Little-Endian bytes view
    var leBytes: [UInt8] {
        get
    }
}

extension UInt64: BinaryIntegerByteView {
    public var beBytes: [UInt8] {
        get {
            return leBytes.reversed()
        }
    }
    
    public var leBytes: [UInt8] {
        get {
            return SPByteViewProvider.getLEndianBytes(self)
        }
    }
}

extension UInt32: BinaryIntegerByteView {
    public var beBytes: [UInt8] {
        get {
            return leBytes.reversed()
        }
    }
    
    public var leBytes: [UInt8] {
        get {
            return SPByteViewProvider.getLEndianBytes(self)
        }
    }
}

extension UInt16: BinaryIntegerByteView {
    public var beBytes: [UInt8] {
        get {
            return leBytes.reversed()
        }
    }
    
    public var leBytes: [UInt8] {
        get {
            return SPByteViewProvider.getLEndianBytes(self)
        }
    }
}

extension UInt8: BinaryIntegerByteView {
    public var beBytes: [UInt8] {
        get {
            return [self]
        }
    }
    
    public var leBytes: [UInt8] {
        get {
            return beBytes
        }
    }
}

extension Int8: BinaryIntegerByteView {
    public var beBytes: [UInt8] {
        get {
            let uVal = UInt8(bitPattern: self)
            return [uVal]
        }
    }
    
    public var leBytes: [UInt8] {
        get {
            return beBytes
        }
    }
}

extension Int16: BinaryIntegerByteView {
    public var beBytes: [UInt8] {
        get {
            return leBytes.reversed()
        }
    }
    
    public var leBytes: [UInt8] {
        get {
            let uVal = UInt16(bitPattern: self)
            return uVal.leBytes
        }
    }
}

extension Int32: BinaryIntegerByteView {
    public var beBytes: [UInt8] {
        get {
            return leBytes.reversed()
        }
    }
    
    public var leBytes: [UInt8] {
        get {
            let uVal = UInt32(bitPattern: self)
            return uVal.leBytes
        }
    }
}

extension Int64: BinaryIntegerByteView {
    public var beBytes: [UInt8] {
        get {
            return leBytes.reversed()
        }
    }
    
    public var leBytes: [UInt8] {
        get {
            let uVal = UInt64(bitPattern: self)
            return uVal.leBytes
        }
    }
}
