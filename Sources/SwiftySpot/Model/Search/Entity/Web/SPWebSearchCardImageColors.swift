//
//  SPWebSearchCardImageColor.swift
//  SwiftySpot
//
//  Created by developer on 14.10.2024.
//

import Foundation

public class SPWebSearchCardImageColors {
    
    public static let colorDarkKey = "colorDark"
    
    public let colors: [String: (hex: String, fallback: Bool)]
    
    public var colorDark: (hex: String, fallback: Bool)? {
        get {
            guard let safeColor = colors[SPWebSearchCardImageColors.colorDarkKey] else {
                return nil
            }
            return safeColor
        }
    }
    
    public init(colors: [String : (hex: String, fallback: Bool)]) {
        self.colors = colors
    }
}
