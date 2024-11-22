//
//  SPLocaleUtil.swift
//  SwiftySpot
//
//  Created by developer on 22.11.2024.
//

import Foundation

final class SPLocaleUtil {
    
    fileprivate init() {}
    
    static func getCurrLocaleRegionCode() -> String? {
        #if targetEnvironment(simulator) || targetEnvironment(macCatalyst) || os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
        if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            return Locale.current.region?.identifier
        }
        #endif
        return Locale.current.regionCode
    }
    
    static func getCurrLocaleLangCode() -> String? {
        var langCode: String?
        #if targetEnvironment(simulator) || targetEnvironment(macCatalyst) || os(macOS) || os(iOS) || os(watchOS) || os(tvOS) || os(visionOS)
        if #available(macOS 13, iOS 16, tvOS 16, watchOS 9, *) {
            langCode = Locale.current.language.languageCode?.identifier(.alpha2)
        } else {
            langCode = Locale.current.regionCode
        }
        #else
        langCode = Locale.current.regionCode
        #endif
        let regionCode = getCurrLocaleRegionCode()
        if var safeLangCode = langCode {
            if let safeRegionCode = regionCode {
                safeLangCode += "_" + safeRegionCode
            }
            return safeLangCode
        }
        return regionCode
    }
}
