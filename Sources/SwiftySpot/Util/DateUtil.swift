//
//  DateUtil.swift
//  SwiftySpot
//
//  Created by Developer on 07.09.2023.
//

import Foundation

public final class DateUtil
{
    fileprivate init() {}
    
    ///Returns MM-dd-yyyy string representation of defined date
    public static func dateFormat(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "MM-dd-yyyy"
        return formatter.string(from: date)
    }
    
    ///Returns EEE, dd MMM yyyy HH:mm:ss z string representation of 'now' date
    public static func dateHeader() -> String {
        let formatter = DateFormatter()
        let date = Date()//sdf.setTimeZone(TimeZone.getTimeZone("GMT"));
        formatter.dateFormat = "EEE, dd MMM yyyy HH:mm:ss z"
        return formatter.string(from: date)
    }
    
    ///Returns yyyy-MM-ddTHH:mm:ssZ string representation of defined date
    public static func isoFormat(date: Date) -> String
    {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withInternetDateTime
        return formatter.string(from: date)
    }
    
    ///Returns yyyy-MM-ddTHH:mm:ssZ string representation of 'now' date
    public static func isoFormat() -> String
    {
        return isoFormat(date: Date())
    }
    
    ///Returns yyyy-MM-ddTHH:mm:ssZ date representation from string
    public static func fromIsoFormat(dateStr: String) -> Date?
    {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = .withInternetDateTime
        return formatter.date(from: dateStr)
    }
    
    ///Try parse yyyy-MM-dd string as date instance
    public static func fromBirthdateFormat(_ birthdate: String) -> Date? {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        return formatter.date(from: birthdate)
    }
    
    ///Converts the time interval (hours, minutes, seconds) to formats:  H:mm:ss if hours > 0 or m:ss if hours = 0
    public static func formattedTrackTime(_ timeInS: TimeInterval) -> String {
        var intVal = Int(timeInS.rounded())
        var res = ""
        if (intVal >= 3600) {
            res += String(intVal / 60) + ":"
        }
        intVal = intVal % 3600
        
        if (intVal >= 60) {
            res += String(intVal / 60) + ":"
        } else {
            if (res.isEmpty)
            {
                res += "0:"
            } else {
                res += "00:"
            }
        }
        intVal = intVal % 60
        
        if (intVal >= 10) {
            res += String(intVal)
        } else {
            res += "0" + String(intVal)
        }
        return res
    }
}
