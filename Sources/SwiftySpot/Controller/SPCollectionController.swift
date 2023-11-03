//
//  SPCollectionController.swift
//  SwiftySpot
//
//  Created by developer on 20.10.2023.
//

import Foundation

///User collection processor
public class SPCollectionController {
    
    public static let defaultPageSize: UInt = 60
    public static let likedArtistsCollectionName = "artist"
    public static let dislikedArtistsCollectionName = "artistban"
    public static let likedTracksAndAlbumsCollectionName = "collection"
    public static let dislikedTracksAndAlbumsCollectionName = "ban"
    public static let likedShowCollectionName = "show"
    public static let likedListenLaterCollectionName = "listenlater"
    
    ///Collection name
    public let name: String
    fileprivate var _syncToken: String
    ///Collection last update ID
    public var syncToken: String {
        get {
            return _syncToken
        }
    }
    fileprivate var _pageSize: UInt
    ///Collection page size. Refreshes after each page update
    public var pageSize: UInt {
        get {
            return _pageSize
        }
    }
    fileprivate var _nextPageToken: String?
    ///Collection next page ID
    public var nextPageToken: String? {
        get {
            return _nextPageToken
        }
    }
    ///Can download next page flag
    public var canLoadNextPage: Bool {
        get {
            guard let safeNextPageToken = _nextPageToken else {return false}
            return !safeNextPageToken.isEmpty
        }
    }
    fileprivate var _dict: [String: SPCollectionItem]
    ///Ordered by added timestamp (descending) collection items
    public var orderedItems: [SPCollectionItem] {
        get {
            return _dict.values.sorted { lhs, rhs in
                return lhs.addedTs > rhs.addedTs
            }
        }
    }
    ///Collection items count
    public var itemsCount: Int {
        get {
            return _dict.count
        }
    }
    
    ///Collection item update events channel name
    fileprivate let notificationChannel: Notification.Name
    
    init(name: String, notificationChannel: Notification.Name = .SPCollectionItemUpdate, syncToken: String = "", pageSize: UInt = SPCollectionController.defaultPageSize, nextPageToken: String? = nil, initValues: [SPCollectionItem] = []) {
        self.name = name
        self.notificationChannel = notificationChannel
        _syncToken = syncToken
        _pageSize = pageSize
        _nextPageToken = nextPageToken
        _dict = [:]
        for item in initValues {
            if (item.removed) {
                continue
            }
            _dict[item.uri] = item
        }
    }
    
    public func find(uri: String) -> SPCollectionItem? {
        guard let item = _dict[uri] else {return nil}
        if (item.removed) {
            _dict.removeValue(forKey: uri)
            let notification = Notification(name: notificationChannel, object: item)
            DispatchQueue.main.async {
                NotificationCenter.default.post(notification)
            }
            return nil
        }
        return item
    }
    
    func removeIfContains(uri: String) {
        guard let found = find(uri: uri) else {return}
        _dict.removeValue(forKey: found.uri)
        let notificationObj = SPCollectionItem(uri: uri, addedTs: found.addedTs, removed: true)
        let notification = Notification(name: notificationChannel, object: notificationObj)
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
    
    func updateFromPage(_ page: SPCollectionPage) {
        _syncToken = page.syncToken
        _pageSize = page.pageSize
        _nextPageToken = page.nextPageToken
        updateFromCollection(page.items)
    }
    
    func updateFromDelta(_ delta: SPCollectionDelta) {
        _syncToken = delta.syncToken
        updateFromCollection(delta.items)
    }
    
    func updateFromCollection(_ collection: [SPCollectionItem]) {
        for item in collection {
            if (item.removed) {
                if (_dict.contains(where: { (k,v) in
                    return k == item.uri
                })) {
                    _dict.removeValue(forKey: item.uri)
                    let notification = Notification(name: notificationChannel, object: item)
                    DispatchQueue.main.async {
                        NotificationCenter.default.post(notification)
                    }
                }
                continue
            }
            _dict[item.uri] = item
            let notification = Notification(name: notificationChannel, object: item)
            DispatchQueue.main.async {
                NotificationCenter.default.post(notification)
            }
        }
    }
    
    func reset() {
        _syncToken = ""
        _pageSize = SPCollectionController.defaultPageSize
        _nextPageToken = nil
        _dict.removeAll()
    }
}

extension SPCollectionController {
    fileprivate static let _collectionItemEventName = "SPCollectionItemUpdate"
    fileprivate static let _artistLikeEventName = "SPArtistLikeUpdate"
    fileprivate static let _artistDislikeEventName = "SPArtistDislikeUpdate"
    fileprivate static let _albumLikeEventName = "SPAlbumLikeUpdate"
    fileprivate static let _albumDislikeEventName = "SPAlbumDislikeUpdate"
    fileprivate static let _trackLikeEventName = "SPTrackLikeUpdate"
    fileprivate static let _trackDislikeEventName = "SPTrackDislikeUpdate"
    
    func notifyCollectionItemUpdate(_ item: SPCollectionItem, collectionName: String) {
        let notification = Notification(name: .SPCollectionItemUpdate, object: (collectionName, item))
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
    
    func notifyArtistLikeUpdate(_ item: SPCollectionItem) {
        let notification = Notification(name: .SPArtistLikeUpdate, object: item)
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
    
    func notifyArtistDislikeUpdate(_ item: SPCollectionItem) {
        let notification = Notification(name: .SPArtistDislikeUpdate, object: item)
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
    
    func notifyAlbumLikeUpdate(_ item: SPCollectionItem) {
        let notification = Notification(name: .SPAlbumLikeUpdate, object: item)
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
    
    func notifyAlbumDislikeUpdate(_ item: SPCollectionItem) {
        let notification = Notification(name: .SPAlbumDislikeUpdate, object: item)
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
    
    func notifyTrackLikeUpdate(_ item: SPCollectionItem) {
        let notification = Notification(name: .SPTrackLikeUpdate, object: item)
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
    
    func notifyTrackDislikeUpdate(_ item: SPCollectionItem) {
        let notification = Notification(name: .SPTrackDislikeUpdate, object: item)
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
}

extension Notification.Name {
    ///Collection item update event. Payload contains in notification.object with type '(String, SPCollectionItem)'
    public static let SPCollectionItemUpdate = Notification.Name(SPCollectionController._collectionItemEventName)
    
    ///Artist like operation event. Payload contains in notification.object with type 'SPCollectionItem'
    public static let SPArtistLikeUpdate = Notification.Name(SPCollectionController._artistLikeEventName)
    ///Artist dislike operation event. Payload contains in notification.object with type 'SPCollectionItem'
    public static let SPArtistDislikeUpdate = Notification.Name(SPCollectionController._artistDislikeEventName)
    ///Album like operation event. Payload contains in notification.object with type 'SPCollectionItem'
    public static let SPAlbumLikeUpdate = Notification.Name(SPCollectionController._albumLikeEventName)
    ///Album dislike operation event. Payload contains in notification.object with type 'SPCollectionItem'
    public static let SPAlbumDislikeUpdate = Notification.Name(SPCollectionController._albumDislikeEventName)
    ///Track like operation event. Payload contains in notification.object with type 'SPCollectionItem'
    public static let SPTrackLikeUpdate = Notification.Name(SPCollectionController._trackLikeEventName)
    ///Track dislike operation event. Payload contains in notification.object with type 'SPCollectionItem'
    public static let SPTrackDislikeUpdate = Notification.Name(SPCollectionController._trackDislikeEventName)
}

extension Notification {
    public func tryParseCollectionItemUpdate() -> (Bool, (String, SPCollectionItem)?)  {
        if let item = object as? (String, SPCollectionItem), name == Notification.Name.SPCollectionItemUpdate {
            return (true, item)
        }
        return (false, nil)
    }
    
    public func tryParseArtistLikeUpdate() -> (Bool, SPCollectionItem?) {
        if let item = object as? SPCollectionItem, name == Notification.Name.SPArtistLikeUpdate {
            return (true, item)
        }
        return (false, nil)
    }
    
    public func tryParseArtistDislikeUpdate() -> (Bool, SPCollectionItem?) {
        if let item = object as? SPCollectionItem, name == Notification.Name.SPArtistDislikeUpdate {
            return (true, item)
        }
        return (false, nil)
    }
    
    public func tryParseAlbumLikeUpdate() -> (Bool, SPCollectionItem?) {
        if let item = object as? SPCollectionItem, name == Notification.Name.SPAlbumLikeUpdate {
            return (true, item)
        }
        return (false, nil)
    }
    
    public func tryParseAlbumDislikeUpdate() -> (Bool, SPCollectionItem?) {
        if let item = object as? SPCollectionItem, name == Notification.Name.SPAlbumDislikeUpdate {
            return (true, item)
        }
        return (false, nil)
    }
    
    public func tryParseTrackLikeUpdate() -> (Bool, SPCollectionItem?) {
        if let item = object as? SPCollectionItem, name == Notification.Name.SPTrackLikeUpdate {
            return (true, item)
        }
        return (false, nil)
    }
    
    public func tryParseTrackDislikeUpdate() -> (Bool, SPCollectionItem?) {
        if let item = object as? SPCollectionItem, name == Notification.Name.SPTrackDislikeUpdate {
            return (true, item)
        }
        return (false, nil)
    }
}
