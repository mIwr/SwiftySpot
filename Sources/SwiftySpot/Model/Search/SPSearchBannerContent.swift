//
//  SPSearchBannerContent.swift
//  SwiftySpot
//
//  Created by Developer on 26.09.2023.
//

///Restful banner on search
public class SPSearchBannerContent {
  ///Banner ID
  public let id: String
  ///Banner title
  public let title: String
  ///Banner description text
  public let desc: String
  ///Action button title
  public let btnTitle: String
  ///Action button url launch on press
  public let url: String

  public init(id: String, title: String, desc: String, btnTitle: String, url: String) {
    self.id = id
    self.title = title
    self.desc = desc
    self.btnTitle = btnTitle
    self.url = url
  }

  static func from(protobuf: Com_Spotify_Searchview_Proto_BannerContent) -> SPSearchBannerContent {
    return SPSearchBannerContent(id: protobuf.id, title: protobuf.title, desc: protobuf.desc, btnTitle: protobuf.buttonTitle, url: protobuf.url)
  }
}
