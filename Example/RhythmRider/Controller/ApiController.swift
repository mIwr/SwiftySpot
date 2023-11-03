//
//  ApiController.swift
//  RhythmRider
//
//  Created by Developer on 13.10.2023.
//

import Foundation
import SwiftySpot

class ApiController: ObservableObject {

  @Published fileprivate(set) var client: SPClient

  init(_ client: SPClient) {
    self.client = client
  }
}
