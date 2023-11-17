//
//  Constants.swift
//  SwiftySpot
//
//  Created by Developer on 07.09.2023.
//

public final class SPConstants {
    fileprivate init() {}
    
    public static let appBundleId = "com.spotify.music"
    public static let appVersionCode = "8.8.66.563"
    ///Client ID
    public static let clID = "9a8d2f0ce77a4e248bb71fefcb557637"
    ///Client validation key
    public static let clValidationKey = "142b583129b2df829de3656f9eb484e6"
    
    ///Default spotify private back-end
    public static let defaultSpClientHost = "https://gew1-spclient.spotify.com/"
    public static let defaultShareHost = "https://open.spotify.com/"
    ///Default spotify previews cdn
    public static let defaultCdnHeadsHost = "https://heads-ak-spotify-com.akamaized.net/"
    ///Reserve spotify preview cdn
    public static let defaultPreviewCdnHost = "https://p.scdn.co/"
    
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
    ///Search navigation uri prefix
    public static let searchUriPrefix = genUriPrefix + "search:"
}
