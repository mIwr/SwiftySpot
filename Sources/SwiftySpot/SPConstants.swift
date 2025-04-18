//
//  Constants.swift
//  SwiftySpot
//
//  Created by Developer on 07.09.2023.
//

public final class SPConstants {
    
    fileprivate init() {}
    
    public static let appBundleId = "com.spotify.music"
    public static let appVersionCode = "9.0.36.134"
    public static let webAppVersionCode = "1.2.63.4.gfa6bbd6f"
    
    public static let webPlatform = "WebPlayer"
    ///Android client ID
    @available(*, deprecated, message: "Use Android or iOS client ID instead")
    public static var clID: String {
        get {
            return androidClID
        }
    }
    ///Android client ID
    public static let androidClID = "9a8d2f0ce77a4e248bb71fefcb557637"
    ///iOS client ID
    public static let iOSClID = "58bd3c95768941ea9eb4350aaa033eb3"
    ///Web client ID
    public static let webClID = "d8a5ed958d274c2e8ee717e6a4b0971d"
    ///Client validation key
    public static let clValidationKey = "142b583129b2df829de3656f9eb484e6"
    
    ///Default spotify private back-end
    public static let defaultSpClientHost = "https://gew1-spclient.spotify.com/"
    public static let defaultShareHost = "https://open.spotify.com/"
    ///Default spotify previews cdn
    public static let defaultCdnHeadsHost = "https://heads-ak-spotify-com.akamaized.net/"
    ///Reserve spotify preview cdn
    public static let defaultPreviewCdnHost = "https://p.scdn.co/"
    ///Reserve spotify image cdn
    public static let defaultImgCdnHost = "https://i.scdn.co/"
    
    ///Navigation uri base prefix
    public static let genUriPrefix = "spotify:"
    ///Artist navigation uri prefix
    public static let artistUriPrefix = genUriPrefix + "artist:"
    ///Album navigation uri prefix
    public static let albumUriPrefix = genUriPrefix + "album:"
    ///Playlist navigation uri prefix
    public static let playlistUriPrefix = genUriPrefix + "playlist:"
    ///Track navigation uri prefix
    public static let trackUriPrefix = genUriPrefix + "track:"
    ///User profile navigation uri prefix
    public static let userUriPrefix = genUriPrefix + "user:"
    ///Genre navigation uri prefix
    public static let genreUriPrefix = genUriPrefix + "genre:"
    ///Show or podcast navigation uri prefix
    public static let showUriPrefix = genUriPrefix + "show:"
    ///Search navigation uri prefix
    public static let searchUriPrefix = genUriPrefix + "search:"
}
