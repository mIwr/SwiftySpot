//
//  SPMetadataLicensor.swift
//  SwiftySpot
//
//  Created by Developer on 20.09.2023.
//

extension SPMetadataLicensor {
    
  ///Licensor UUID bytes
  public var uuidBytes: [UInt8]{
      return [UInt8].init(self.uuid)
  }
}
