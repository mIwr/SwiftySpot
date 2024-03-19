//
//  ProfileActionSettingView.swift
//  RhythmRider
//
//  Created by developer on 19.03.2024.
//

import SwiftUI

struct ProfileActionSettingView: View {
    
    fileprivate let _title: String
    fileprivate let _subtitle: String?
    fileprivate let _actionTitle: String
    fileprivate let _onActionPress: (() -> Void)?
    
    init(title: String, subtitle: String?, actionTitle: String, onActionPress: (() -> Void)?) {
        _title = title
        _subtitle = subtitle
        _actionTitle = actionTitle
        _onActionPress = onActionPress
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4, content: {
            HStack(content: {
                Text(_title)
                    .font(.body).fontWeight(.regular)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(R.color.primary))
                if let safeAction = _onActionPress {
                    Spacer(minLength: 8)
                    Button(action: safeAction) {
                        Text(_actionTitle)
                    }
                }
            })
            if let safeSub = _subtitle, !safeSub.isEmpty {
                Text(safeSub)
                    .font(.body).fontWeight(.regular)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(R.color.secondary))
            }
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 12, trailing: 8))
        .background(Color(R.color.bgSecondary))
        .cornerRadius(12.0)
    }
}

#Preview {
    VStack(content: {
        ProfileActionSettingView(title: "Some title", subtitle: "Subtitle info text content", actionTitle: "Action") {
            
        }
        ProfileActionSettingView(title: "Some long-long-long-long-long-long-long title", subtitle: "Subtitle info text content", actionTitle: "Action") {
            
        }
    })
}
