//
//  TrackFullInfoScreen.swift
//  RhythmRider
//
//  Created by developer on 02.11.2023.
//

import SwiftUI
import SwiftySpot

struct TrackFullInfoScreen: View {
    
    fileprivate let _trackInfo: SPMetadataTrack
    
    @Binding var presented: Bool
    
    init(_trackInfo: SPMetadataTrack, presented: Binding<Bool>) {
        self._trackInfo = _trackInfo
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
                        Text(_trackInfo.name)
                            .font(.headline).fontWeight(.semibold)
                            .foregroundColor(Color(R.color.primary))
                    })
                    .frame(maxWidth: .infinity, alignment: .leading)
                    if (!_trackInfo.artists.isEmpty) {
                        _textBlockInfo(category: R.string.localizable.trackInfoArtists(), value: _trackInfo.artists.map({ artist in
                            return artist.name
                        }).joined(separator: " • "))
                        Divider()
                    }
                    if let safeAlbum = _trackInfo.album {
                        _textBlockInfo(category: R.string.localizable.trackInfoAlbumName(), value: safeAlbum.name)
                        Divider()
                        if (safeAlbum.releaseTsUTC != 0) {
                            _textBlockInfo(category: R.string.localizable.trackInfoReleaseYear(), value: String(safeAlbum.releaseYear))
                            Divider()
                        }
                        if (_trackInfo.artists.isEmpty && !safeAlbum.artists.isEmpty) {
                            _textBlockInfo(category: R.string.localizable.trackInfoArtists(), value: _trackInfo.artists.map({ artist in
                                return artist.name
                            }).joined(separator: " • "))
                            Divider()
                        }
                    }
                    if (_trackInfo.durationInMs != 0) {
                        _textBlockInfo(category: R.string.localizable.trackInfoDuration(), value: DateUtil.formattedTrackTime(Double(_trackInfo.durationInMs) / 1000))
                        Divider()
                    }
                    _textBlockInfo(category: "ID", value: _trackInfo.id)
                    Divider()
                    _textBlockInfo(category: "Global ID", value: StringUtil.bytesToHexString(_trackInfo.globalID))
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
    return TrackFullInfoScreen(_trackInfo: trackInfo, presented: $shown)
}
