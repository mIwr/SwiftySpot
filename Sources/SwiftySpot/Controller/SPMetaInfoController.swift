//
//  SPMetaInfoController.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2023.
//

import Foundation

///Metadata processor
public class SPMetaInfoController<T> {
    
    fileprivate var _items: [String: T]
    ///Metadata items
    public var items: [T] {
        get {
            return [T].init(_items.values)
        }
    }
    
    let keyValidator: (String) -> Bool
    let updateItemNotificationBuilder: (T) -> Notification
    
    init(initItems: [String: T], keyValidator: @escaping (String) -> Bool, updateItemNotificationBuilder: @escaping (T) -> Notification) {
        self._items = initItems
        self.keyValidator = keyValidator
        self.updateItemNotificationBuilder = updateItemNotificationBuilder
    }
    
    public func find(uri: String) -> T? {
        if (!keyValidator(uri)) {
            return nil
        }
        return _items[uri]
    }
    
    public func find(uris: Set<String>) -> [T] {
        var res: [T] = []
        for uri in uris {
            guard let found = find(uri: uri) else {continue}
            res.append(found)
        }
        return res
    }
    
    public func findAsDict(uris: Set<String>) -> [String: T] {
        var res: [String: T] = [:]
        for uri in uris {
            guard let found = find(uri: uri) else {continue}
            res[uri] = found
        }
        return res
    }
    
    func update(_ dict: [String: T]) {
        for entry in dict {
            _items[entry.key] = entry.value
            let notification = updateItemNotificationBuilder(entry.value)
            DispatchQueue.main.async {
                NotificationCenter.default.post(notification)
            }
        }
    }
    
    public func remove(uris: Set<String>) {
        for uri in uris {
            _ = _items.removeValue(forKey: uri)
        }
    }
}

extension SPMetaInfoController {
    static func buildArtistMetaUpdateNotification(meta: SPMetadataArtist) -> Notification {
        return Notification(name: .SPArtistMetaUpdate, object: meta)
    }
    
    static func buildAlbumMetaUpdateNotification(meta: SPMetadataAlbum) -> Notification {
        return Notification(name: .SPAlbumMetaUpdate, object: meta)
    }
    
    static func buildPlaylistMetaUpdateNotification(meta: SPPlaylist) -> Notification {
        return Notification(name: .SPPlaylistMetaUpdate, object: meta)
    }
    
    static func buildTrackMetaUpdateNotification(meta: SPMetadataTrack) -> Notification {
        return Notification(name: .SPTrackMetaUpdate, object: meta)
    }
    
    static func buildLyricsUpdateNotification(lyrics: SPLyrics) -> Notification {
        return Notification(name: .SPLyricsUpdate, object: lyrics)
    }
}

extension Notification.Name {
    fileprivate static let _artistMetaEventName = "SPArtistMetaUpdate"
    fileprivate static let _albumMetaEventName = "SPAlbumMetaUpdate"
    fileprivate static let _playlistMetaEventName = "SPPlaylistMetaUpdate"
    fileprivate static let _trackMetaEventName = "SPTrackMetaUpdate"
    fileprivate static let _lyricsEventName = "SPLyricsUpdate"
    
    ///Artist metadata update event. Payload contains in notification.object with type 'SPMetadataArtist'
    public static let SPArtistMetaUpdate = Notification.Name(_artistMetaEventName)
    ///Album metadata update event. Payload contains in notification.object with type 'SPMetadataAlbum'
    public static let SPAlbumMetaUpdate = Notification.Name(_albumMetaEventName)
    ///Playlist metadata update event. Payload contains in notification.object with type 'SPPlaylist'
    public static let SPPlaylistMetaUpdate = Notification.Name(_playlistMetaEventName)
    ///Track metadata update event. Payload contains in notification.object with type 'SPMetadataTrack'
    public static let SPTrackMetaUpdate = Notification.Name(_trackMetaEventName)
    ///Lyrics update event. Payload contains in notification.object with type 'SPLyrics'
    public static let SPLyricsUpdate = Notification.Name(_lyricsEventName)
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
    
    public func tryParseLyricsUpdate() -> (Bool, SPLyrics?) {
        if let lyrics = object as? SPLyrics, name == Notification.Name.SPLyricsUpdate {
            return (true, lyrics)
        }
        return (false, nil)
    }
}
