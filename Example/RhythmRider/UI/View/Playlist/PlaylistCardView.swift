//
//  PlaylistCardView.swift
//  RhythmRider
//
//  Created by Developer on 16.10.2023.
//

import SwiftUI

struct PlaylistCardView: View {
    
    let uri: String
    let title: String
    let subtitle: String
    let img: UIImage?
    
    var body: some View {
        let radius = 12.0
        let sizeComponent = 160.0
        var name = title
        if (name.isEmpty) {
            name = subtitle
        }
        return VStack(alignment: .trailing, spacing: 8) {
            Text(name)
                .font(.headline).foregroundColor(Color(R.color.primary))
                .multilineTextAlignment(.trailing)
                .padding(EdgeInsets(top: 0, leading: 16, bottom: 12, trailing: 8))
        }
        .frame(width: sizeComponent, height: sizeComponent, alignment: .bottomTrailing)
        .background(Color(R.color.bgSecondary))
        .cornerRadius(radius)
    }
}

#Preview {
    ScrollView(.horizontal, showsIndicators: false) {
        HStack(alignment: .top, spacing: 12) {
          PlaylistCardView(uri: "uri", title: "Playlist name", subtitle: "Playlist subtitle", img: nil)
          PlaylistCardView(uri: "uri", title: "Playlist name", subtitle: "", img: nil)
            PlaylistCardView(uri: "uri", title: "", subtitle: "Playlist long-long subtitle", img: nil)
          PlaylistCardView(uri: "uri", title: "Playlist long-long name", subtitle: "Playlist subtitle", img: nil)
          PlaylistCardView(uri: "uri", title: "Playlist long-long name", subtitle: "Playlist long-long subtitle", img: nil)
        }
    }
    .frame(maxHeight: .infinity, alignment: .top)
}
