//
//  SPMetaController.swift
//  SwiftySpot
//
//  Created by developer on 20.10.2023.
//

import Foundation

///Metadata processor
public class SPMetaController {
    
    fileprivate var _artists: [String: SPMetadataArtist]
    ///Artists metadata
    public var cachedArtistsMeta: [SPMetadataArtist] {
        get {
            return [SPMetadataArtist].init(_artists.values)
        }
    }
    
    fileprivate var _albums: [String: SPMetadataAlbum]
    ///Albums metadata
    public var cachedAlbumsMeta: [SPMetadataAlbum] {
        get {
            return [SPMetadataAlbum].init(_albums.values)
        }
    }
    
    fileprivate var _playlists: [String: SPPlaylist]
    ///Playlists metadata
    public var cachedPlaylists: [SPPlaylist] {
        get {
            return [SPPlaylist].init(_playlists.values)
        }
    }
    
    fileprivate var _tracks: [String: SPMetadataTrack]
    ///Tracks metadata
    public var cachedTracksMeta: [SPMetadataTrack] {
        get {
            return [SPMetadataTrack].init(_tracks.values)
        }
    }
    
    init(artists: [String : SPMetadataArtist], albums: [String : SPMetadataAlbum], tracks: [String : SPMetadataTrack], playlists: [String: SPPlaylist]) {
        self._artists = artists
        self._albums = albums
        self._playlists = playlists
        self._tracks = tracks
    }
    
    public func findArtist(uri: String) -> SPMetadataArtist? {
        if (!SPNavigateUriUtil.validateArtistUri(uri)) {
            return nil
        }
        return _artists[uri]
    }
    
    public func findArtists(uris: Set<String>) -> [SPMetadataArtist] {
        var res: [SPMetadataArtist] = []
        for uri in uris {
            guard let found = findArtist(uri: uri) else {continue}
            res.append(found)
        }
        return res
    }
    
    func updateArtists(_ dict: [String: SPMetadataArtist]) {
        for entry in dict {
            _artists[entry.key] = entry.value
            notifyArtistMetaUpdate(entry.value)
        }
    }
    
    public func findAlbum(uri: String) -> SPMetadataAlbum? {
        if (!SPNavigateUriUtil.validateAlbumUri(uri)) {
            return nil
        }
        return _albums[uri]
    }
    
    public func findAlbums(uris: Set<String>) -> [SPMetadataAlbum] {
        var res: [SPMetadataAlbum] = []
        for uri in uris {
            guard let found = findAlbum(uri: uri) else {continue}
            res.append(found)
        }
        return res
    }
    
    func updateAlbums(_ dict: [String: SPMetadataAlbum]) {
        for entry in dict {
            _albums[entry.key] = entry.value
            notifyAlbumMetaUpdate(entry.value)
        }
    }
    
    public func findPlaylist(uri: String) -> SPPlaylist? {
        if (!SPNavigateUriUtil.validatePlaylistUri(uri)) {
            return nil
        }
        return _playlists[uri]
    }
    
    public func findPlaylists(uris: Set<String>) -> [SPPlaylist] {
        var res: [SPPlaylist] = []
        for uri in uris {
            guard let found = findPlaylist(uri: uri) else {continue}
            res.append(found)
        }
        return res
    }
    
    func updatePlaylists(_ dict: [String: SPPlaylist]) {
        for entry in dict {
            _playlists[entry.key] = entry.value
            notifyPlaylistMetaUpdate(entry.value)
        }
    }
    
    public func findTrack(uri: String) -> SPMetadataTrack? {
        if (!SPNavigateUriUtil.validateTrackUri(uri)) {
            return nil
        }
        return _tracks[uri]
    }
    
    public func findTracks(uris: Set<String>) -> [String: SPMetadataTrack] {
        var res: [String: SPMetadataTrack] = [:]
        for uri in uris {
            guard let found = findTrack(uri: uri) else {continue}
            res[uri] = found
        }
        return res
    }
    
    func updateTracks(_ dict: [String: SPMetadataTrack]) {
        for entry in dict {
            _tracks[entry.key] = entry.value
            notifyTrackMetaUpdate(entry.value)
        }
    }
}

extension SPMetaController {
    fileprivate static let _artistMetaEventName = "SPArtistMetaUpdate"
    fileprivate static let _albumMetaEventName = "SPAlbumMetaUpdate"
    fileprivate static let _playlistMetaEventName = "SPPlaylistMetaUpdate"
    fileprivate static let _trackMetaEventName = "SPTrackMetaUpdate"
    
    func notifyArtistMetaUpdate(_ meta: SPMetadataArtist) {
        let notification = Notification(name: .SPArtistMetaUpdate, object: meta)
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
    
    func notifyAlbumMetaUpdate(_ meta: SPMetadataAlbum) {
        let notification = Notification(name: .SPAlbumMetaUpdate, object: meta)
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
    
    func notifyPlaylistMetaUpdate(_ meta: SPPlaylist) {
        let notification = Notification(name: .SPPlaylistMetaUpdate, object: meta)
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
    
    func notifyTrackMetaUpdate(_ meta: SPMetadataTrack) {
        let notification = Notification(name: .SPTrackMetaUpdate, object: meta)
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
}

extension Notification.Name {
    ///Artist metadata update event. Payload contains in notification.object with type 'SPMetadataArtist'
    public static let SPArtistMetaUpdate = Notification.Name(SPMetaController._artistMetaEventName)
    ///Album metadata update event. Payload contains in notification.object with type 'SPMetadataAlbum'
    public static let SPAlbumMetaUpdate = Notification.Name(SPMetaController._albumMetaEventName)
    ///Playlist metadata update event. Payload contains in notification.object with type 'SPPlaylist'
    public static let SPPlaylistMetaUpdate = Notification.Name(SPMetaController._playlistMetaEventName)
    ///Track metadata update event. Payload contains in notification.object with type 'SPMetadataTrack'
    public static let SPTrackMetaUpdate = Notification.Name(SPMetaController._trackMetaEventName)
}

extension Notification {
    public func tryParseArtistMetaUpdate() -> (Bool, SPMetadataArtist?) {
        if let meta = object as? SPMetadataArtist, name == Notification.Name.SPArtistMetaUpdate {
            return (true, meta)
        }
        return (false, nil)
    }
    
    public func tryParseAlbumMetaUpdate() -> (Bool, SPMetadataAlbum?) {
        if let meta = object as? SPMetadataAlbum, name == Notification.Name.SPAlbumMetaUpdate {
            return (true, meta)
        }
        return (false, nil)
    }
    
    public func tryParsePlaylistMetaUpdate() -> (Bool, SPPlaylist?) {
        if let meta = object as? SPPlaylist, name == Notification.Name.SPPlaylistMetaUpdate {
            return (true, meta)
        }
        return (false, nil)
    }
    
    public func tryParseTrackMetaUpdate() -> (Bool, SPMetadataTrack?) {
        if let meta = object as? SPMetadataTrack, name == Notification.Name.SPTrackMetaUpdate {
            return (true, meta)
        }
        return (false, nil)
    }
}
