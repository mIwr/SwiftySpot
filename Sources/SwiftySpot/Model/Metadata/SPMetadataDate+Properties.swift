//
//  SPMetadataDate.swift
//  SwiftySpot
//
//  Created by Developer on 19.09.2023.
//

import Foundation

extension SPMetadataDate {
    
    //Values from API is x2 of real. Can trigger it by year (4046 = 2023 * 2) or month (16 = 8 * 2)
    
    public var year: Int {
        get {
            return Int(stockYear / 2)
        }
    }
    
    public var month: Int {
        get {
            return Int((stockMonth / 2) % 12)
        }
    }
    
    public var day: Int {
        get {
            return Int((stockDay / 2) % 31)
        }
    }
    
    public var hour: Int {
        get {
            return Int((stockHour / 2) % 24)
        }
    }
    
    public var minute: Int {
        get {
            return Int((stockMinute / 2) % 60)
        }
    }
    
    public var date: Date? {
        let date = Calendar.current.date(from: DateComponents(year: year, month: month, day: day, hour: hour, minute: minute, second: 0))
        return date
    }
    
    public var timestamp: Int64 {
        get {
            guard let dt = date else {return 0}
            let val = Int64(dt.timeIntervalSince1970)
            return val
        }
    }
}
