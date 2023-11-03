//
//  Published.swift
//  RhythmRider
//
//  Created by Developer on 13.10.2023.
//

import Foundation

extension Published: Decodable where Value: Decodable {
  public init(from decoder: Decoder) throws {
    self.init(initialValue: try .init(from: decoder))
  }
}

extension Published:Encodable where Value:Decodable {

    private var valueChild:Any? {
        let mirror = Mirror(reflecting: self)
        if let valueChild = mirror.descendant("value") {
            return valueChild
        }

        //iOS 14 does things differently...
        if let valueChild = mirror.descendant("storage","value") {
            return valueChild
        }

        //iOS 14 does this too...
        if let valueChild = mirror.descendant("storage","publisher","subject","currentValue") {
            return valueChild
        }

        return nil
    }

    public func encode(to encoder: Encoder) throws {

        guard let valueChild = valueChild else {
            fatalError("Mirror Mirror on the wall - why no value y'all : \(self)")
        }

        if let value = valueChild as? Encodable {
            do {
                try value.encode(to: encoder)
                return
            } catch let error {
                assertionFailure("Failed encoding: \(self) - \(error)")
            }
        }
        else {
            assertionFailure("Decodable Value not decodable. Odd \(self)")
        }
    }
}
