//
//  SPLikeController.swift
//  SwiftySpot
//
//  Created by developer on 20.10.2023.
//

import Foundation

public class SPLikeController {
    
    fileprivate var _liked: SPCollectionController
    public var liked: SPCollectionController {
        get {
            return _liked
        }
    }
    
    fileprivate var _disliked: SPCollectionController
    public var disliked: SPCollectionController {
        get {
            return _disliked
        }
    }
    
    public init(liked: SPCollectionController, disliked: SPCollectionController) {
        _liked = liked
        _disliked = disliked
    }
    
    func updateFromPage(_ page: SPCollectionPage, liked: Bool) {
        var antipod: SPCollectionController
        if (liked) {
            _liked.updateFromPage(page)
            antipod = _disliked
        } else {
            _disliked.updateFromPage(page)
            antipod = _liked
        }
        for item in page.items {
            if (item.removed) {
                continue
            }
            //Remove element on antipod collection (element contains on both collections)
            antipod.removeIfContains(uri: item.uri)
        }
    }
    
    func updateFromDelta(_ delta: SPCollectionDelta, liked: Bool) {
        var antipod: SPCollectionController
        if (liked) {
            _liked.updateFromDelta(delta)
            antipod = _disliked
        } else {
            _disliked.updateFromDelta(delta)
            antipod = _liked
        }
        for item in delta.items {
            if (item.removed) {
                continue
            }
            //Remove element on antipod collection (element contains on both collections)
            antipod.removeIfContains(uri: item.uri)
        }
    }
    
    func updateFromCollection(_ collection: [SPCollectionItem], liked: Bool) {
        var antipod: SPCollectionController
        if (liked) {
            _liked.updateFromCollection(collection)
            antipod = _disliked
        } else {
            _disliked.updateFromCollection(collection)
            antipod = _liked
        }
        for item in collection {
            if (item.removed) {
                continue
            }
            //Remove element on antipod collection (element contains on both collections)
            antipod.removeIfContains(uri: item.uri)
        }
    }
    
    func removeAll() {
        _liked.reset()
        _disliked.reset()
    }
}
