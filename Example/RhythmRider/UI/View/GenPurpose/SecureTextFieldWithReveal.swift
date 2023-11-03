//
//  SecureTextFieldWithReveal.swift
//  RhythmRider
//
//  Created by Developer on 10.10.2023.
//

import SwiftUI

struct SecureTextFieldWithReveal: View {

  @State fileprivate var _showPassword = false
  let key: String
  @Binding var text: String

  var body: some View {
      HStack {
        ZStack(alignment: .trailing) {
            TextField(key, text: $text)
                .textContentType(.password)
                .opacity(_showPassword ? 1 : 0)
            SecureField(key, text: $text)
                .textContentType(.password)
                .opacity(_showPassword ? 0 : 1)
            Button(action: {
              _showPassword = !_showPassword
            }, label: {
              Image(_showPassword ? R.image.icEye : R.image.icEyeOff)
                .resizable()
                .scaledToFit()
                .frame(width: 20, height: 20)
                .foregroundColor(Color(R.color.primary))
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 8))
              })
          }
      }
  }
}

#Preview {
    @State var text = ""
    return SecureTextFieldWithReveal(key: "Hint text", text: $text)
        .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        .textFieldStyle(.roundedBorder)
}
