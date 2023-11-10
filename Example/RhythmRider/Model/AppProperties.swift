//
//  Properties.swift
//  RhythmRider
//
//  Created by Developer on 21.05.2021.
//

import Foundation
import SwiftySpot

class AppProperties: Codable, ObservableObject
{
    fileprivate static let _plistFilename = Constants.PSEUDO_BUNDLE_ID
    
    var deviceId: String
    @Published fileprivate var _flags: BitBool8
    
    var trafficEconomy: Bool {
        get { return _flags.getFlagPropertyValue(for: 0) }
        set { _flags.setFlagPropertyValue(for: 0, value: newValue) }
    }
    
    var playbackSkipDisliked: Bool {
        get { return _flags.getFlagPropertyValue(for: 1) }
        set { _flags.setFlagPropertyValue(for: 1, value: newValue) }
    }
    
#if DEBUG
    init() {
        _flags = BitBool8(initVal: 0)
        deviceId = SPDevice.generateRandomDeviceId()
    }
#endif
    
    init(flags: BitBool8 = BitBool8(initVal: 0), deviceId: [UInt8] = [])
    {
        _flags = flags
        if (deviceId.isEmpty || deviceId.count < SPDevice.defaultDeviceIdBytesCount) {
            self.deviceId = SPDevice.generateRandomDeviceId()
            save()
        } else {
            self.deviceId = StringUtil.bytesToHexString(deviceId)
        }
    }
    
    ///Save application properties with default filename (bundle id)
    func save()
    {
        save(plistFilename: AppProperties._plistFilename)
    }
    
    ///Save application properties with specific filename
    func save(plistFilename: String)
    {
        if !PlistWrapper.savePropertyList(self, filename: plistFilename)
        {
#if DEBUG
            print("Application properties not saved")
#endif
        }
    }
    
    ///Load application properties with default filename (bundle id)
    class func load() -> AppProperties
    {
        return load(plistFilename: AppProperties._plistFilename)
    }
    
    ///Load application properties with specific filename
    class func load(plistFilename: String) -> AppProperties
    {
        if let loadedProperties: AppProperties = PlistWrapper.parsePropertyList(filename: plistFilename)
        {
            return loadedProperties
        }
        let properties = AppProperties()
        properties.save(plistFilename: plistFilename)
        return properties
    }
}
