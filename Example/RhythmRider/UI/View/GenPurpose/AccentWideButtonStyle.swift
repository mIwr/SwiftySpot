//
//  AccentWideButtonStyle.swift
//  RhythmRider
//
//  Created by Developer on 16.10.2023.
//

import SwiftUI

struct AccentWideButtonStyle: ButtonStyle {

  func makeBody(configuration: Configuration) -> some View {
          configuration.label
              .padding()
              .frame(minWidth: 0, maxWidth: .infinity, minHeight: Constants.defaultButtonHeight, maxHeight: Constants.defaultButtonHeight)
              .background(Color(R.color.accent))
              .cornerRadius(Constants.defaultButtonHeight)
      }
}
