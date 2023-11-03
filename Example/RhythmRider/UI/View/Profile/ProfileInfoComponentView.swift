//
//  ProfileInfoComponentView.swift
//  RhythmRider
//
//  Created by developer on 31.10.2023.
//

import SwiftUI

struct ProfileInfoComponentView: View {
    
    fileprivate let category: String
    fileprivate let value: String
    
    init(category: String, value: String) {
        self.category = category
        self.value = value
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0, content: {
            Text(category)
                .font(.caption).fontWeight(.semibold)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color(R.color.secondary))
            Text(value)
                .font(.body).fontWeight(.regular)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color(R.color.primary))
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 12, trailing: 8))
        .background(Color(R.color.bgSecondary))
        .cornerRadius(12.0)
    }
}

#Preview {
    ProfileInfoComponentView(category: "Some category", value: "Category Value")
}
