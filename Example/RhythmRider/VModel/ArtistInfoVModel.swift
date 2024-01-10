//
//  ArtistInfoVModel.swift
//  RhythmRider
//
//  Created by developer on 18.12.2023.
//

import SwiftySpot
import SwiftUI

class ArtistInfoVModel {
    
    fileprivate(set) var artist: SPMetadataArtist
    
    fileprivate(set) var topTracks: ItemsVModel<SPMetadataTrack>
    fileprivate(set) var albums: ItemsVModel<SPMetadataAlbum>
    fileprivate(set) var singles: ItemsVModel<SPMetadataAlbum>
    fileprivate(set) var appears: ItemsVModel<SPMetadataAlbum>
    fileprivate(set) var compilations: ItemsVModel<SPMetadataAlbum>
    
    var orderedUrisSeqHash: Int {
        get {
            return PlaybackController.calculatePlaySeqHash(topTracks.orderedUris)
        }
    }
    
    var orderedPlaybackSeq: [PlaybackTrack] {
        get {
            var res: [PlaybackTrack] = []
            for uri in topTracks.orderedUris {
                guard let meta = topTracks.details[uri] else {continue}
                res.append(PlaybackTrack(uri: uri, trackMeta: meta))
            }
            return res
        }
    }
    
    init(artist: SPMetadataArtist, orderedTrackUris: [String] = [], topTracksDetails: [String: SPMetadataTrack] = [:], orderedAlbumUris: [String] = [], orderedSingleUris: [String] = [], orderedAppearUris: [String] = [], orderedCompilationUris: [String] = [], albumsDetails: [String: SPMetadataAlbum] = [:]) {
        self.artist = artist
        topTracks = ItemsVModel(orderedUris: orderedTrackUris, details: topTracksDetails)
        var buffMap: [String: SPMetadataAlbum] = [:]
        for uri in orderedAlbumUris {
            guard let safeDetails = albumsDetails[uri] else {
                continue
            }
            buffMap[uri] = safeDetails
        }
        albums = ItemsVModel(orderedUris: orderedAlbumUris, details: buffMap)
        buffMap.removeAll()
        for uri in orderedSingleUris {
            guard let safeDetails = albumsDetails[uri] else {
                continue
            }
            buffMap[uri] = safeDetails
        }
        singles = ItemsVModel(orderedUris: orderedSingleUris, details: buffMap)
        buffMap.removeAll()
        for uri in orderedAppearUris {
            guard let safeDetails = albumsDetails[uri] else {
                continue
            }
            buffMap[uri] = safeDetails
        }
        appears = ItemsVModel(orderedUris: orderedAppearUris, details: buffMap)
        buffMap.removeAll()
        for uri in orderedCompilationUris {
            guard let safeDetails = albumsDetails[uri] else {
                continue
            }
            buffMap[uri] = safeDetails
        }
        compilations = ItemsVModel(orderedUris: orderedCompilationUris, details: buffMap)
    }
    
    func updateArtist(_ artist: SPMetadataArtist) {
        self.artist = artist
        albums.setUris(artist.albums.map({ album in
            return album.uri
        }))
        singles.setUris(artist.singles.map({ album in
            return album.uri
        }))
        appears.setUris(artist.appears.map({ album in
            return album.uri
        }))
        compilations.setUris(artist.compilations.map({ album in
            return album.uri
        }))
    }
    
    func updateAlbumsDetails(_ details: [String: SPMetadataAlbum]) {
        let albumUrisSet = albums.uris
        let singleUrisSet = singles.uris
        let appearUrisSet = appears.uris
        let compilationUrisSet = compilations.uris
        for entry in details {
            if (albumUrisSet.contains(entry.key)) {
                albums.updateDetails([entry.key: entry.value])
            }
            if (singleUrisSet.contains(entry.key)) {
                singles.updateDetails([entry.key: entry.value])
            }
            if (appearUrisSet.contains(entry.key)) {
                appears.updateDetails([entry.key: entry.value])
            }
            if (compilationUrisSet.contains(entry.key)) {
                compilations.updateDetails([entry.key: entry.value])
            }
        }
    }
    
    func refreshAlbumsOrderByReleaseDate() {
        if (!albums.orderedUris.isEmpty) {
            refreshOrderByReleaseDate(items: &albums)
        }
        
        if (!singles.orderedUris.isEmpty) {
            refreshOrderByReleaseDate(items: &singles)
        }
        if (!appears.orderedUris.isEmpty) {
            refreshOrderByReleaseDate(items: &appears)
        }
        if (!compilations.orderedUris.isEmpty) {
            refreshOrderByReleaseDate(items: &compilations)
        }
    }
    
    fileprivate func refreshOrderByReleaseDate(items: inout ItemsVModel<SPMetadataAlbum>) {
        var arr = items.orderedSeq
        arr.sort { a, b in
            return a.releaseTsUTC > b.releaseTsUTC
        }
        items.setUris(arr.map({ album in
            return album.uri
        }))
    }
}
