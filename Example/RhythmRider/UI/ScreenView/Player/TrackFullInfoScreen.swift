//
//  TrackFullInfoScreen.swift
//  RhythmRider
//
//  Created by developer on 02.11.2023.
//

import SwiftUI
import SwiftySpot

struct TrackFullInfoScreen: View {
    
    @State var id: String
    @State var hexGID: String
    @State var name: String
    @State var artists: String
    @State var albumName: String?
    @State var albumReleaseYear: UInt16?
    @State var durationInMs: Int32
    
    @Binding var presented: Bool
    
    init(_ trackInfo: SPMetadataTrack, presented: Binding<Bool>) {
        _id = State(initialValue: trackInfo.id)
        _hexGID = State(initialValue: trackInfo.hexGlobalID)
        _name = State(initialValue: trackInfo.name)
        _artists = State(initialValue: trackInfo.artists.map({ artist in
            return artist.name
        }).joined(separator: " • "))
        _albumName = State(initialValue: trackInfo.album?.name)
        _albumReleaseYear = State(initialValue: trackInfo.album?.releaseYear)
        _durationInMs = State(initialValue: trackInfo.durationInMs)
        _presented = presented
    }
    
    var body: some View {
        ZStack(alignment: Alignment(horizontal: .center, vertical: .bottom)) {
            ScrollView(.vertical, showsIndicators: false) {
                VStack(alignment: .center, spacing: 12) {
                    HStack(alignment: .center, spacing: 4, content: {
                        Image(R.image.cover)
                            .resizable()
                            .frame(width: 80, height: 80, alignment: .center)
                            .cornerRadius(12)
                        Text(name)
                            .font(.headline).fontWeight(.semibold)
                            .foregroundColor(Color(R.color.primary))
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    if (!artists.isEmpty) {
                        _textBlockInfo(category: R.string.localizable.trackInfoArtists(), value: artists)
                        Divider()
                    }
                    if let safeAlbumName = albumName {
                        _textBlockInfo(category: R.string.localizable.trackInfoAlbumName(), value: safeAlbumName)
                        Divider()
                    }
                    if let safeAlbumReleaseYear = albumReleaseYear {
                        _textBlockInfo(category: R.string.localizable.trackInfoReleaseYear(), value: String(safeAlbumReleaseYear))
                        Divider()
                    }
                    if (durationInMs != 0) {
                        _textBlockInfo(category: R.string.localizable.trackInfoDuration(), value: SPDateUtil.formattedTrackTime(Double(durationInMs) / 1000))
                        Divider()
                    }
                    _textBlockInfo(category: "ID", value: id)
                    Divider()
                    _textBlockInfo(category: "Global ID", value: hexGID)
                    Divider()
                }
                .padding(EdgeInsets(top: 16, leading: 0, bottom: Constants.defaultButtonHeight + 16, trailing: 0))
            }
            Button(action: {
                presented = false
            }, label: {
                Text(R.string.localizable.generalClose())
                    .font(.headline)
                    .foregroundColor(Color(R.color.primary))
            })
            .buttonStyle(AccentWideButtonStyle())
        }
        .padding(EdgeInsets(top: 16, leading: 16, bottom: 16, trailing: 16))
    }
    
    fileprivate func _textBlockInfo(category: String, value: String) -> some View {
        VStack(alignment: .leading, spacing: 4, content: {
            Text(category)
                .font(.caption).fontWeight(.semibold)
                .foregroundColor(Color(R.color.secondary))
            Text(value)
                .font(.body).fontWeight(.regular)
                .foregroundColor(Color(R.color.primary))
        })
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(EdgeInsets(top: 8, leading: 12, bottom: 8, trailing: 12))
        .background(Color(R.color.bgSecondary))
        .cornerRadius(12.0)
    }
}

#Preview {
    @State var shown = true
    let trackInfo = SPMetadataTrack(gid: [], name: "Track name")
    return TrackFullInfoScreen(trackInfo, presented: $shown)
}
