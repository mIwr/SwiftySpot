//
//  SPWebDate.swift
//  SwiftySpot
//
//  Created by developer on 13.11.2024.
//

import Foundation

public struct SPDateTime: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case year
        case month
        case day
        case hour
        case minute
    }
    
    public let year: UInt16
    public let month: UInt8
    public let day: UInt8
    public let hour: UInt8
    public let minute: UInt8
    
    public var timestampSince1970: Int64 {
        let dtComponents = DateComponents(calendar: Calendar.current, timeZone: TimeZone(secondsFromGMT: 0), year: Int(year), month: Int(month), day: Int(day), hour: Int(hour), minute: Int(minute))
        let ts = dtComponents.date?.timeIntervalSince1970 ?? 0.0
        return Int64(ts)
    }
    
    public init(year: UInt16, month: UInt8 = 1, day: UInt8 = 1, hour: UInt8 = 0, minute: UInt8 = 0) {
        self.year = year
        self.month = month % 12
        self.day = day % 31
        self.hour = hour % 24
        self.minute = minute % 60
    }
    
    public init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.year = try container.decode(UInt16.self, forKey: .year)
        var buff = (try? container.decodeIfPresent(UInt8.self, forKey: .month)) ?? 1
        self.month = buff % 12
        buff = (try? container.decodeIfPresent(UInt8.self, forKey: .day)) ?? 1
        self.day = buff % 31
        buff = (try? container.decodeIfPresent(UInt8.self, forKey: .hour)) ?? 0
        self.hour = buff % 24
        buff = (try? container.decodeIfPresent(UInt8.self, forKey: .minute)) ?? 0
        self.minute = buff % 60
    }
    
    static func from(protobuf: SPMetadataDate) -> SPDateTime {
        return SPDateTime(year: UInt16(protobuf.year), month: UInt8(protobuf.month), day: UInt8(protobuf.day), hour: UInt8(protobuf.hour), minute: UInt8(protobuf.minute))
    }
}
