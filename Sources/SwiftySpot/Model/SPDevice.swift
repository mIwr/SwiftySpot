//
//  Device.swift
//  SwiftySpot
//
//  Created by Developer on 07.09.2023.
//

import Foundation

///Represents device info for requests
public class SPDevice {

  public static let defaultDeviceIdBytesCount = 8

  ///Device operating system name (Android, iOS and others)
  public let os: String
  ///iOS flag
  public var iOS: Bool {
    get {
      let lowercased = os.lowercased()
      return lowercased == "ios" || lowercased == "iphone" || lowercased == "ipados" || lowercased == "ipad"
    }
  }
  ///Android flag
  public var android: Bool {
    get { return os.lowercased() == "android"}
  }
  ///OS version code (17.0.0, for example)
  public let osVersionCode: String
  ///OS version number (17, for example)
  public let osVersionNumber: Int32
  ///CPU abi (armv8, x86_64)
  public let cpuAbi: String
  ///Device manufacturer name (Apple, Samsung and others)
  public let manufacturer: String
  ///Device model name
  public let model: String
  ///Device ID (8 bytes)
  public let deviceId: String

  public init(os: String, osVer: String, osVerNum: Int32, cpuAbi: String, manufacturer: String, model: String, deviceId: String) {
    self.os = os
    self.osVersionCode = osVer
    self.osVersionNumber = osVerNum
    self.cpuAbi = cpuAbi
    self.model = model
    self.manufacturer = manufacturer
    self.deviceId = deviceId
  }

  public init(os: String, osVer: String, osVerNum: Int32, cpuAbi: String, manufacturer: String, model: String) {
    self.os = os
    self.osVersionCode = osVer
    self.osVersionNumber = osVerNum
    self.cpuAbi = cpuAbi
    self.model = model
    self.manufacturer = manufacturer
    self.deviceId = SPDevice.generateRandomDeviceId()
  }

  ///Generates correct device ID format for client
  public static func generateRandomDeviceId() -> String {
    var buff: [UInt8] = [UInt8].init(repeating: 0, count: defaultDeviceIdBytesCount)
    for i in 0...defaultDeviceIdBytesCount - 1 {
      guard let rnd: Int = (0...255).randomElement() else {
        continue
      }
      buff[i] = UInt8(rnd)
    }
    let hex = StringUtil.bytesToHexString(buff)
    return hex
  }
}
