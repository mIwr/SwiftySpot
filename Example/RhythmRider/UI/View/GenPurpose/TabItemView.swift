//
//  TabItemView.swift
//  RhythmRider
//
//  Created by Developer on 16.10.2023.
//

import SwiftUI

struct TabItemView: View {

  let title: String
  let img: Image

    var body: some View {
      VStack(alignment: .center, spacing: 4) {
        img
          .resizable()
          .frame(width: 32, height: 32)
        Text(title)
          .font(.headline).fontWeight(.semibold)
      }
    }
}

#Preview {
    TabItemView(title: "Some tab", img: Image(R.image.icAudio))
}
