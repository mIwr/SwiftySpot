//
//  LoadingScreen.swift
//  RhythmRider
//
//  Created by developer on 20.10.2023.
//

import SwiftUI

struct LoadingView: View {
    var body: some View {
        VStack(alignment: /*@START_MENU_TOKEN@*/.center/*@END_MENU_TOKEN@*/, spacing: /*@START_MENU_TOKEN@*/nil/*@END_MENU_TOKEN@*/, content: {
            Spacer(minLength: 16)
            ProgressView().progressViewStyle(.circular)
            Spacer(minLength: 16)
        })
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    LoadingView()
}
