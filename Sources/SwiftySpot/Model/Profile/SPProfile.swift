//
//  SPProfile.swift
//  SwiftySpot
//
//  Created by Developer on 20.09.2023.
//

import Foundation

///Profile info
public class SPProfile: SPBaseObj, Decodable {

  enum CodingKeys: String, CodingKey {
    case id
    case type
    case email
    case displayName = "display_name"
    case birthdate
    case extUrls = "external_urls"
    case href
    case images
    case country
    case product
    case explicitContent = "explicit_content"
    case policies
  }

  ///Profile ID (username)
  public let id: String
  ///Profile type. 'user', for example
  public let type: String
  public var username: String {
    get {
      return id
    }
  }
  ///Profile navigation uri
  public var uri: String {
    get {
      return "spotify:" + type + ":" + id
    }
  }
  ///Profile mail
  public let email: String
  ///Profile display name
  public let displayName: String
  ///Birthdate stock formatted string
  public let birthdate: String
  ///Birthdate date instance
  public var bDate: Date? {
    get {
      return SPDateUtil.fromBirthdateFormat(birthdate)
    }
  }
  ///Profile external links
  public let extUrls: [String: String]
  ///Spotify profile url
  public let href: String
  ///Profile avas
  public let images: [String]
  ///Profile country code. 'DE' (Germany), for example
  public let country: String
  ///Subscription type. 'free' (no active subscription), for example
  public let product: String
  ///API product type code
  public var productType: Int {
    get {
      if (product.lowercased() == "free") {
        return 0
      }
      //TODO check for account with subscription
      return 1
    }
  }
  ///Profile explicit settings
  public let explicitContent: SPExplicit
  ///Profile policies
  public let policies: SPPolicies?

  public init(id: String, type: String, email: String, displayName: String, birthdate: String, extUrls: [String : String], href: String, images: [String], country: String, product: String, explicitContent: SPExplicit, policies: SPPolicies?) {
    self.id = id
    self.type = type
    self.email = email
    self.displayName = displayName
    self.birthdate = birthdate
    self.extUrls = extUrls
    self.href = href
    self.images = images
    self.country = country
    self.product = product
    self.explicitContent = explicitContent
    self.policies = policies
  }
}
