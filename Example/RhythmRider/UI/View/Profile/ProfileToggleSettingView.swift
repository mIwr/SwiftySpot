//
//  ProfileSliderSettingView.swift
//  RhythmRider
//
//  Created by developer on 31.10.2023.
//

import SwiftUI

struct ProfileToggleSettingView: View {
    
    fileprivate let _title: String
    fileprivate let _subtitle: String?
    fileprivate let _onChanged: ((Bool) -> Void)?
    @State var value: Bool
    
    init(title: String, subtitle: String?, initValue: Bool, onChanged: ((Bool) -> Void)?) {
        _title = title
        _subtitle = subtitle
        _value = State(initialValue: initValue)
        _onChanged = onChanged
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4, content: {
            Toggle(isOn: $value, label: {
                Text(_title)
                    .font(.body).fontWeight(.regular)
                    .multilineTextAlignment(.leading)
                    .foregroundColor(Color(R.color.primary))
            })
            .onChange(of: value, perform: { newVal in
                _onChanged?(newVal)
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
    return ProfileToggleSettingView(title: "Toggle slider", subtitle: "Toggle subtitle about property info", initValue: false, onChanged: nil)
}
