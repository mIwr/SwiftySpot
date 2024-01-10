//
//  AlbumsCollectionView.swift
//  RhythmRider
//
//  Created by developer on 10.01.2024.
//

import SwiftUI
import SwiftySpot

struct AlbumsCollectionView: View {
    
    let collection: ItemsVModel<SPMetadataAlbum>
    
    init(collection: ItemsVModel<SPMetadataAlbum>) {
        self.collection = collection
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .center, spacing: 12.0) {
                ForEach(0...collection.orderedUris.count - 1, id: \.self) { index in
                    let uri = collection.orderedUris[index]
                    let safeAlbum = collection.details[uri] ?? SPMetadataAlbum(gid: [], name: "N/A", uri: uri, releaseTsUTC: 0)
                    AlbumShortView(uri: uri, name: safeAlbum.name, img: nil, releaseYear: safeAlbum.releaseYear)
                }
            }
            .padding(EdgeInsets(top: 0, leading: 16, bottom: 0, trailing: 16))
        }
    }
}

#Preview {
    AlbumsCollectionView(collection: ItemsVModel<SPMetadataAlbum>(orderedUris: ["sp:123", "sp:1234"], details: [
        "sp:123": SPMetadataAlbum(gid: [], name: "Album name 1"),
        "sp:124": SPMetadataAlbum(gid: [], name: "Album name 2")
    ]))
}
