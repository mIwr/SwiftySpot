//
//  AlbumsVModel.swift
//  RhythmRider
//
//  Created by developer on 18.12.2023.
//

import Foundation
import SwiftySpot

class ItemsVModel<T: SPID> {
    
    fileprivate(set) var orderedUris: [String]
    fileprivate(set) var details: [String: T]
    
    var orderedSeq: [T] {
        get {
            var res: [T] = []
            for uri in orderedUris {
                guard let meta = details[uri] else {continue}
                res.append(meta)
            }
            return res
        }
    }
    
    var uris: Set<String> {
        get {
            let set = Set<String>(orderedUris)
            return set
        }
    }
    
    var noInfoUris: Set<String> {
        get {
            var set = Set<String>()
            for uri in orderedUris {
                if (details.contains(where: { (k,v) in
                    return uri == k
                })) {
                    continue
                }
                set.insert(uri)
            }
            return set
        }
    }
    
    var orderedNoInfoUris: [String] {
        var res: [String] = []
        for uri in orderedUris {
            if (details.contains(where: { (k,v) in
                uri == k
            })) {
                continue
            }
            res.append(uri)
        }
        return res
    }
    
    init(orderedUris: [String] = [], details: [String: T] = [:]) {
        self.orderedUris = orderedUris
        self.details = details
    }
    
    func setUris(_ orderedUris: [String]) {
        self.orderedUris = orderedUris
    }
    
    func appendUris(_ orderedUris: [String]) {
        self.orderedUris.append(contentsOf: orderedUris)
    }
    
    func updateDetails(_ details: [String: T]) {
        for entry in details {
            self.details[entry.key] = entry.value
        }
    }
    
    func resetDetails() {
        details.removeAll()
    }
    
    func resetSeq() {
        orderedUris = []
        resetDetails()
    }
}
