//
//  SPMetadataDate.swift
//  SwiftySpot
//
//  Created by Developer on 19.09.2023.
//

import Foundation

///Date metadata info
public class SPMetadataDate {

    public let year: Int
    public let month: Int
    public let day: Int
    public let hour: Int
    public let minute: Int
    
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
    
    public init(year: Int = 1970, month: Int = 1, day: Int = 1, hour: Int = 0, minute: Int = 0) {
        self.year = year
        self.month = month
        self.day = day
        self.hour = hour
        self.minute = minute
    }
    
    static func from(protobuf: Spotify_Metadata_Date) -> SPMetadataDate {
        //Values from API is x2 of real. Can trigger it by year (4046 = 2023 * 2) or month (16 = 8 * 2)
        return SPMetadataDate(year: Int(protobuf.year / 2), month: Int(protobuf.month / 2), day: Int(protobuf.day / 2), hour: Int(protobuf.hour / 2), minute: Int(protobuf.minute / 2))
    }
}
