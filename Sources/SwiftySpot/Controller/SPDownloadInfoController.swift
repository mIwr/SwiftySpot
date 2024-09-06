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
    fileprivate var _wdvMeta: [String: SPWDVSeektable]
    ///Wdv meta dictionary. Key is hexFileId
    public var wdvMeta: [String: SPWDVSeektable] {
        get {
            return _wdvMeta
        }
    }
    fileprivate var _intents: [String: SPPlayIntentResponse]
    ///Play intents  dictionary. Key is hexFileId
    public var playIntents: [String: SPPlayIntentResponse] {
        get {
            return _intents
        }
    }
    
    public init(di: [String: SPDownloadInfo], seektables: [String: SPWDVSeektable], intents: [String: SPPlayIntentResponse]) {
        self._di = di
        self._wdvMeta = seektables
        self._intents = intents
        refreshDownloadInfo()
    }
    
    ///Find download info, linked play and wdv intents by file ID hex key
    public func find(hexFileId: String) -> (SPDownloadInfo?, SPPlayIntentResponse?, SPWDVSeektable?) {
        var di = _di[hexFileId]
        if (di?.active == false || di?.directLinks.isEmpty == true) {
            di = nil
            _di.removeValue(forKey: hexFileId)
        }
        let intent = _intents[hexFileId]
        let seektable = _wdvMeta[hexFileId]
        return (di, intent, seektable)
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
    
    public func updateSeektables(_ seektables: [String: SPWDVSeektable]) {
        for entry in seektables {
            _wdvMeta[entry.key] = entry.value
        }
    }
    
    public func updatePlayIntents(_ intents: [String: SPPlayIntentResponse]) {
        for entry in intents {
            _intents[entry.key] = entry.value
        }
    }
    
    public func removeAll() {
        _di.removeAll()
        _wdvMeta.removeAll()
        _intents.removeAll()
    }
}
