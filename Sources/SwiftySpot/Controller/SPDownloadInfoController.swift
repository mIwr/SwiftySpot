//
//  SPDownloadInfoController.swift
//  SwiftySpot
//
//  Created by developer on 25.10.2023.
//

///Spotify objects download info processor
public class SPDownloadInfoController {
    
    fileprivate var _di: [String: SPDownloadInfo]
    ///Download info dictionary. Key is hexFileId
    public var downloadInfos: [String: SPDownloadInfo] {
        get {
            return _di
        }
    }
    fileprivate var _intents: [String: SPPlayIntentData]
    ///Play intents  dictionary. Key is hexFileId
    public var playIntents: [String: SPPlayIntentData] {
        get {
            return _intents
        }
    }
    
    public init(di: [String : SPDownloadInfo], intents: [String:SPPlayIntentData]) {
        self._di = di
        self._intents = intents
        refreshDownloadInfo()
    }
    
    ///Find download info and play intent pair by hexFileId key
    public func find(hexFileId: String) -> (SPDownloadInfo?, SPPlayIntentData?) {
        var di = _di[hexFileId]
        if (di?.active == false || di?.directLinks.isEmpty == true) {
            di = nil
            _di.removeValue(forKey: hexFileId)
        }
        let intent = _intents[hexFileId]
        return (di, intent)
    }
    
    ///Removes expired download info instances
    public func refreshDownloadInfo() {
        let keys = _di.keys
        for key in keys {
            guard let safeVal = _di[key] else {continue}
            if (safeVal.active) {
                continue
            }
            _di.removeValue(forKey: key)
        }
    }
    
    public func updateDownloadInfo(_ di: [SPDownloadInfo]) {
        for item in di {
            _di[item.hexFileId] = item
        }
    }
    
    public func updatePlayIntents(_ intents: [String: SPPlayIntentData]) {
        for entry in intents {
            _intents[entry.key] = entry.value
        }
    }
    
    public func removeAll() {
        _di.removeAll()
        _intents.removeAll()
    }
}
