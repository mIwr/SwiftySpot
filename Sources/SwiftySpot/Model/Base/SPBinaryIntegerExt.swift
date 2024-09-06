//
//  BinaryIntExt.swift
//  SwiftySpot
//
//  Created by developer on 03.11.2023.
//

///Bytes view representation for binary integer values
protocol SPBinaryIntegerByteView {
    ///Big-Endian bytes view
    var beBytes: [UInt8] {
         get
    }
    
    ///Little-Endian bytes view
    var leBytes: [UInt8] {
        get
    }
}

extension UInt64: SPBinaryIntegerByteView {
    var beBytes: [UInt8] {
        get {
            return leBytes.reversed()
        }
    }
    
    var leBytes: [UInt8] {
        get {
            return SPBinaryUtil.getLEndianBytes(self)
        }
    }
}

extension UInt32: SPBinaryIntegerByteView {
    var beBytes: [UInt8] {
        get {
            return leBytes.reversed()
        }
    }
    
    var leBytes: [UInt8] {
        get {
            return SPBinaryUtil.getLEndianBytes(self)
        }
    }
}

extension UInt16: SPBinaryIntegerByteView {
    var beBytes: [UInt8] {
        get {
            return leBytes.reversed()
        }
    }
    
    var leBytes: [UInt8] {
        get {
            return SPBinaryUtil.getLEndianBytes(self)
        }
    }
}

extension UInt8: SPBinaryIntegerByteView {
    var beBytes: [UInt8] {
        get {
            return [self]
        }
    }
    
    var leBytes: [UInt8] {
        get {
            return beBytes
        }
    }
}

extension Int8: SPBinaryIntegerByteView {
    var beBytes: [UInt8] {
        get {
            let uVal = UInt8(bitPattern: self)
            return [uVal]
        }
    }
    
    var leBytes: [UInt8] {
        get {
            return beBytes
        }
    }
}

extension Int16: SPBinaryIntegerByteView {
    var beBytes: [UInt8] {
        get {
            return leBytes.reversed()
        }
    }
    
    var leBytes: [UInt8] {
        get {
            let uVal = UInt16(bitPattern: self)
            return uVal.leBytes
        }
    }
}

extension Int32: SPBinaryIntegerByteView {
    var beBytes: [UInt8] {
        get {
            return leBytes.reversed()
        }
    }
    
    var leBytes: [UInt8] {
        get {
            let uVal = UInt32(bitPattern: self)
            return uVal.leBytes
        }
    }
}

extension Int64: SPBinaryIntegerByteView {
    var beBytes: [UInt8] {
        get {
            return leBytes.reversed()
        }
    }
    
    var leBytes: [UInt8] {
        get {
            let uVal = UInt64(bitPattern: self)
            return uVal.leBytes
        }
    }
}
