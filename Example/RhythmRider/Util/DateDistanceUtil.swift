//
//  DateDeltaUtil.swift
//  RhythmRider
//
//  Created by Developer on 16.10.2023.
//

import Foundation

class DateDistanceUtil {
  fileprivate static let _secondsInDay = 86400

  fileprivate init() {}

  static func fomrattedDistanceDescription(dateDelta: Date) -> String {
    let distance = Int(dateDelta.distance(to: Date()))
    if (distance < _secondsInDay) {
      return R.string.localizable.generalToday()
    }
    if (distance < _secondsInDay * 2) {
      return R.string.localizable.generalYesterday()
    }
    let dtFormatter = DateFormatter()
    dtFormatter.dateFormat = "dd.MM"
    let str = dtFormatter.string(from: dateDelta)
    return str
  }
}
