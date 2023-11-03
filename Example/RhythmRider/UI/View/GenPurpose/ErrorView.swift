//
//  ErrorScreen.swift
//  RhythmRider
//
//  Created by developer on 20.10.2023.
//

import SwiftUI

struct ErrorView: View {
    
    let title: String
    let subtitle: String
    let refreshAction: () -> Void
    
    init(title: String, subtitle: String, refreshAction: @escaping () -> Void) {
        self.title = title
        self.subtitle = subtitle
        self.refreshAction = refreshAction
    }
    
    init(title: String, refreshAction: @escaping () -> Void) {
        self.title = title
        self.subtitle = ""
        self.refreshAction = refreshAction
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            Spacer(minLength: 24)
            Image(R.image.icAlertCircle)
                .resizable()
                .frame(width: 64, height: 64)
                .padding(EdgeInsets(top: 0, leading: 0, bottom: 12, trailing: 0))
                .foregroundColor(Color(R.color.primary))
            Text(title)
                .font(.headline).fontWeight(.semibold)
                .multilineTextAlignment(.center)
            if (!subtitle.isEmpty) {
                Text(subtitle)
                    .foregroundColor(Color(R.color.secondary))
                    .multilineTextAlignment(.center)
            }
            Spacer(minLength: 24)
            Button(action: refreshAction) {
                Text(R.string.localizable.generalRefresh)
                    .font(.headline).fontWeight(.semibold)
            }
            .buttonStyle(AccentWideButtonStyle())
        }
    }
}

#Preview {
    ErrorView(title: "Some error title", subtitle: "Error subtitle info") {
        
    }
}
