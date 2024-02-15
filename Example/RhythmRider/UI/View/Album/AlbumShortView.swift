//
//  AlbumShortView.swift
//  RhythmRider
//
//  Created by developer on 18.12.2023.
//

import SwiftUI

struct AlbumShortView: View {
    
    let uri: String
    let name: String
    let img: UIImage?
    let releaseYear: UInt16
    
    init(uri: String, name: String, img: UIImage?, releaseYear: UInt16) {
        self.uri = uri
        self.name = name
        self.img = img
        self.releaseYear = releaseYear
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4, content: {
            Image(uiImage: img ?? R.image.cover() ?? UIImage())
                .resizable()
                .frame(width: 128, height: 128)
                .cornerRadius(12)
            Text(name)
                .font(.headline.weight(.semibold))
                .multilineTextAlignment(.leading)
                .foregroundColor(Color(R.color.primary))
            Text(String(releaseYear))
                .font(.body)
                .multilineTextAlignment(.leading)
                .foregroundColor(Color(R.color.secondary))
        })
        .frame(maxWidth: 128)
    }
}

#Preview {
    AlbumShortView(uri: "sp:213", name: "Some album long-long-long-long name", img: nil, releaseYear: 2023)
}
