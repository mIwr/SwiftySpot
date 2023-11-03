//
//  SPSearchEntity.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

import Foundation

///Search result general entity object
public class SPSearchEntity: SPTypedObj {
    ///Entity name
    public let name: String
    ///Entity cover image navigation uri
    public let imgUri: String
    ///Entity as artist info
    public let artist: SPSearchArtist?
    ///Entity as track info
    public let track: SPSearchTrack?
    ///Entity as album info
    public let album: SPSearchAlbum?
    ///Entity as playlist info
    public let playlist: SPSearchPlaylist?
    ///Entity as genre info
    public let genre: SPSearchGenre?
    ///Entity as audio show info
    public let show: SPSearchAudioShow?
    ///Entity as profile info
    public let profile: SPSearchProfile?
    ///Entity as audiobook info
    public let audiobook: SPSearchAudiobook?
    ///Entity as search suggestion
    public let autocomplete: SPSearchAutocompleteQuery?
    ///Meta info
    public let serpMeta: String
    
    public init(uri: String, name: String, imgUri: String, artist: SPSearchArtist?, track: SPSearchTrack?, album: SPSearchAlbum?, playlist: SPSearchPlaylist?, genre: SPSearchGenre?, show: SPSearchAudioShow?, profile: SPSearchProfile?, audiobook: SPSearchAudiobook?, autocomplete: SPSearchAutocompleteQuery?, serpMeta: String) {
        self.name = name
        self.imgUri = imgUri
        self.artist = artist
        self.track = track
        self.album = album
        self.playlist = playlist
        self.genre = genre
        self.show = show
        self.profile = profile
        self.audiobook = audiobook
        self.autocomplete = autocomplete
        self.serpMeta = serpMeta
        super.init(uri: uri)
    }
    
    static func from(protobuf: Com_Spotify_Searchview_Proto_Entity) -> SPSearchEntity {
        var artist: SPSearchArtist?
        var track: SPSearchTrack?
        var album: SPSearchAlbum?
        var playlist: SPSearchPlaylist?
        var genre: SPSearchGenre?
        var show: SPSearchAudioShow?
        var profile: SPSearchProfile?
        var audiobook: SPSearchAudiobook?
        var autocomplete: SPSearchAutocompleteQuery?
        if case .artist? = protobuf.info {
            artist = SPSearchArtist.from(protobuf: protobuf.artist)
        } else if case .track? = protobuf.info {
            track = SPSearchTrack.from(protobuf: protobuf.track)
        } else if case .album? = protobuf.info {
            album = SPSearchAlbum.from(protobuf: protobuf.album)
        } else if case .playlist? = protobuf.info {
            playlist = SPSearchPlaylist.from(protobuf: protobuf.playlist)
        } else if case .genre? = protobuf.info {
            genre = SPSearchGenre.from(protobuf: protobuf.genre)
        } else if case .show? = protobuf.info {
            show = SPSearchAudioShow.from(protobuf: protobuf.show)
        } else if case .profile? = protobuf.info {
            profile = SPSearchProfile.from(protobuf: protobuf.profile)
        } else if case .audiobook? = protobuf.info {
            audiobook = SPSearchAudiobook.from(protobuf: protobuf.audiobook)
        } else if case .autocompleteQuery? = protobuf.info {
            autocomplete = SPSearchAutocompleteQuery.from(protobuf: protobuf.autocompleteQuery)
        }
        return SPSearchEntity(uri: protobuf.uri, name: protobuf.name, imgUri: protobuf.imageUri, artist: artist, track: track, album: album, playlist: playlist, genre: genre, show: show, profile: profile, audiobook: audiobook, autocomplete: autocomplete, serpMeta: protobuf.serpMetadata)
    }
}

extension SPSearchEntity {
    ///Generated from search info about artist
    public var generatedArtistMeta: SPMetadataArtist? {
        get {
            guard let safeArtist = artist else {
                return nil
            }
            return safeArtist.asMetaObj(uri: uri, name: name)
        }
    }
    
    ///Generated from search info about album
    public var generatedAlbumMeta: SPMetadataAlbum? {
        get {
            guard let safeAlbum = album else {
                return nil
            }
            return safeAlbum.asMetaObj(uri: uri, name: name)
        }
    }
    
    ///Generated from search info about track
    public var generatedTrackMeta: SPMetadataTrack? {
        get {
            guard let safeTrack = track else {
                return nil
            }
            return safeTrack.asMetaObj(uri: uri, name: name)
        }
    }
}
