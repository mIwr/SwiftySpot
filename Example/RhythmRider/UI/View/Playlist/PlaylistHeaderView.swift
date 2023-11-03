//
//  PlaylistHeaderView.swift
//  RhythmRider
//
//  Created by Developer on 09.10.2023.
//

import SwiftUI
import SwiftySpot

struct PlaylistHeaderView: View {
    
    let title: String
    let desc: String?
    let img: UIImage?
    let tracksCount: Int
    
    var body: some View {
        let safeImg = img ?? R.image.cover() ?? UIImage()
        var name = title
        var subname = ""
        if let safeDesc = desc {
            if (name.isEmpty) {
                name = safeDesc
            } else {
                subname = safeDesc
            }
        }
        return VStack(alignment: .center, spacing: 8)
        {
            Image(uiImage: safeImg)
                .resizable()
                .frame(width: 104, height: 104)
                .cornerRadius(12)
            Text(name)
                .font(.title3.weight(.semibold))
                .multilineTextAlignment(.center)
            if (!subname.isEmpty) {
                Text(subname)
                    .font(.headline.weight(.regular))
                    .multilineTextAlignment(.center)
            }
            Text(R.string.localizable.generalTracks() + " - " + String(tracksCount))
                .font(.headline)
                .foregroundColor(.gray)
                .multilineTextAlignment(.center)
        }
        .frame(maxWidth: .infinity)
    }
}

#Preview {
    PlaylistHeaderView(title: "Playlist name", desc: "Playlist description", img: R.image.previewCover(), tracksCount: 20)
}
