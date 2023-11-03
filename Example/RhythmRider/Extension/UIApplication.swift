//
//  UIApplication.swift
//  RhythmRider
//
//  Created by Developer on 10.10.2023.
//

import SwiftUI

extension UIApplication {
  func endEditing() {
    sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
  }
}
