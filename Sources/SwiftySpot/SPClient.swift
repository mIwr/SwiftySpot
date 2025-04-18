//
//  SPClient.swift
//  SwiftySpot
//
//  Created by Developer on 08.09.2023.
//

import Foundation

///Spotify API client
public class SPClient {
    ///Version code of module
    public static let version: String = Bundle(for: SPClient.self).infoDictionary?["CFBundleShortVersionString"] as? String ?? "1.0"
    ///Version build number of module
    public static let buildNum: String = Bundle(for: SPClient.self).infoDictionary?["CFBundleVersion"] as? String ?? "1"
    
    ///Spotify version
    public var appVersionCode: String
    ///Spotify web version
    public var webAppVersionCode: String
    ///Spotify client ID
    public var clientId: String
    ///Spotify client validation key
    public var clientValidationKey: String
    ///Device info
    public var device: SPDevice
    ///Client token protobuf obj
    var clToken: SPClientToken
    ///Client token creation timestamp (UTC+0)
    var clTokenCreateTsUTC: Int64
    ///Guest authorization session
    var guestAuthSession: SPAuthSession
    ///Authorized session protobuf obj
    var authSession: SPAuthToken
    ///Authorized timestamp (UTC+0)
    var authTokenCreateTsUTC: Int64
    ///Spotify access points
    var apHosts: [String]
    ///Spotify dealer hosts
    var dealerHosts: [String]
    ///Spotify API access points
    var spclientHosts: [String]
    ///Spotify DRM application certificate raw bytes data
    var wdvCert: Data?
    ///Spotify account info
    var profile: SPProfile?
    ///User collections repository (without like/dislike)
    var collectionsStorage: [String: SPCollectionController]
    ///User artists collection
    var likedDislikedArtistsStorage: SPLikeController
    ///User albums collection
    var likedDislikedAlbumsStorage: SPLikeController
    ///User tracks collection
    var likedDislikedTracksStorage: SPLikeController
    ///Spotify artists meta repository
    public var artistsMetaStorage: SPMetaInfoController<SPMetadataArtist>
    ///Spotify albums meta repository
    public var albumsMetaStorage: SPMetaInfoController<SPMetadataAlbum>
    ///Spotify playlists meta repository
    public var playlistsMetaStorage: SPMetaInfoController<SPPlaylist>
    ///Spotify tracks meta repository
    public var tracksMetaStorage: SPMetaInfoController<SPMetadataTrack>
    ///Spotify lyrics info repository
    public var lyricsStorage: SPMetaInfoController<SPLyrics>
    ///Spotify download info repository
    public var downloadInfoStorage: SPDownloadInfoController
    
    ///Uninitialized unauthorized state ctor
    ///- Parameter appVersionCode: Spotify client version code
    ///- Parameter webAppVersionCode: Spotify web client version code
    ///- Parameter clientId: Spotify client ID
    ///- Parameter clValidationKey: Spotify client validation key
    ///- Parameter playIntentToken: Spotify PlayPlayReq token
    ///- Parameter device: Device info
    ///- Parameter artistsMeta: Artists info for meta repository
    ///- Parameter albumsMeta: Albums info for meta repository
    ///- Parameter playlistsMeta: Playlists info for meta repository
    ///- Parameter tracksMeta: Tracks info for meta repository
    ///- Parameter lyricsInfo: Lyrics info for repository
    ///- Returns: SPClient instance on unauthorized state
    public init(appVersionCode: String = SPConstants.appVersionCode, webAppVersionCode: String = SPConstants.webAppVersionCode, clientId: String = SPConstants.androidClID, clValidationKey: String = SPConstants.clValidationKey, device: SPDevice, artistsMeta: [String: SPMetadataArtist] = [:], albumsMeta: [String: SPMetadataAlbum] = [:], playlistsMeta: [String: SPPlaylist] = [:], tracksMeta: [String: SPMetadataTrack] = [:], lyricsInfo: [String: SPLyrics] = [:]) {
        self.appVersionCode = appVersionCode
        self.webAppVersionCode = webAppVersionCode
        self.clientId = clientId
        self.clientValidationKey = clValidationKey
        self.device = device
        clToken = SPClientToken()
        clTokenCreateTsUTC = 0
        guestAuthSession = SPAuthSession()
        authSession = SPAuthToken()
        authTokenCreateTsUTC = 0
        apHosts = []
        dealerHosts = []
        spclientHosts = []
        wdvCert = nil
        collectionsStorage = [:]
        likedDislikedArtistsStorage = SPLikeController(liked: SPCollectionController(name: SPCollectionController.likedArtistsCollectionName, notificationChannel: .SPArtistLikeUpdate), disliked: SPCollectionController(name: SPCollectionController.dislikedArtistsCollectionName, notificationChannel: .SPArtistDislikeUpdate))
        likedDislikedAlbumsStorage = SPLikeController(liked: SPCollectionController(name: SPCollectionController.likedTracksAndAlbumsCollectionName, notificationChannel: .SPAlbumLikeUpdate), disliked: SPCollectionController(name: SPCollectionController.dislikedTracksAndAlbumsCollectionName, notificationChannel: .SPAlbumDislikeUpdate))
        likedDislikedTracksStorage = SPLikeController(liked: SPCollectionController(name: SPCollectionController.likedTracksAndAlbumsCollectionName, notificationChannel: .SPTrackLikeUpdate), disliked: SPCollectionController(name: SPCollectionController.dislikedTracksAndAlbumsCollectionName, notificationChannel: .SPTrackDislikeUpdate))
        artistsMetaStorage = SPMetaInfoController<SPMetadataArtist>(initItems: artistsMeta, keyValidator: SPNavigateUriUtil.validateArtistUri, updateItemNotificationBuilder: SPMetaInfoController<SPMetadataArtist>.buildArtistMetaUpdateNotification)
        albumsMetaStorage = SPMetaInfoController<SPMetadataAlbum>(initItems: albumsMeta, keyValidator: SPNavigateUriUtil.validateAlbumUri, updateItemNotificationBuilder: SPMetaInfoController<SPMetadataAlbum>.buildAlbumMetaUpdateNotification)
        playlistsMetaStorage = SPMetaInfoController<SPPlaylist>(initItems: playlistsMeta, keyValidator: SPNavigateUriUtil.validatePlaylistUri, updateItemNotificationBuilder: SPMetaInfoController<SPPlaylist>.buildPlaylistMetaUpdateNotification)
        tracksMetaStorage = SPMetaInfoController<SPMetadataTrack>(initItems: tracksMeta, keyValidator: SPNavigateUriUtil.validateTrackUri, updateItemNotificationBuilder: SPMetaInfoController<SPMetadataTrack>.buildTrackMetaUpdateNotification)
        lyricsStorage = SPMetaInfoController<SPLyrics>(initItems: lyricsInfo, keyValidator: { key in
            return true
        }, updateItemNotificationBuilder: SPMetaInfoController<SPLyrics>.buildLyricsUpdateNotification)
        downloadInfoStorage = SPDownloadInfoController(di: [:], seektables: [:], intents: [:])
    }
    
    ///Initialized unauthorized state ctor
    ///- Parameter appVersionCode: Spotify client version code
    ///- Parameter webAppVersionCode: Spotify web client version code
    ///- Parameter clientId: Spotify client ID
    ///- Parameter clValidationKey: Spotify client validation key
    ///- Parameter playIntentToken: Spotify PlayPlayReq token
    ///- Parameter device: Device info
    ///- Parameter clToken: Client token
    ///- Parameter clTokenExpiresInS: Client token lifetime duration is seconds
    ///- Parameter clTokenCreateTsUTC: Client token creation timestamp (UTC+0)
    ///- Parameter artistsMeta: Artists info for meta repository
    ///- Parameter albumsMeta: Albums info for meta repository
    ///- Parameter playlistsMeta: Playlists info for meta repository
    ///- Parameter tracksMeta: Tracks info for meta repository
    ///- Parameter lyricsInfo: Lyrics info for repository
    ///- Returns: SPClient instance on unauthorized state
    public init(appVersionCode: String = SPConstants.appVersionCode, webAppVersionCode: String = SPConstants.webAppVersionCode, clientId: String = SPConstants.androidClID, clValidationKey: String = SPConstants.clValidationKey, device: SPDevice, clToken: String, clTokenExpires: Int32, clTokenRefreshAfter: Int32, clTokenCreateTsUTC: Int64, artistsMeta: [String: SPMetadataArtist] = [:], albumsMeta: [String: SPMetadataAlbum] = [:], playlistsMeta: [String: SPPlaylist] = [:], tracksMeta: [String: SPMetadataTrack] = [:], lyricsInfo: [String: SPLyrics] = [:]) {
        self.appVersionCode = appVersionCode
        self.webAppVersionCode = webAppVersionCode
        self.clientId = clientId
        self.clientValidationKey = clValidationKey
        self.device = device
        self.clToken = SPClientToken()
        self.clToken.val = clToken
        self.clToken.expiresInS = clTokenExpires
        self.clToken.refreshAfterS = clTokenRefreshAfter
        self.clTokenCreateTsUTC = clTokenCreateTsUTC
        guestAuthSession = SPAuthSession()
        authSession = SPAuthToken()
        authTokenCreateTsUTC = 0
        apHosts = []
        dealerHosts = []
        spclientHosts = []
        wdvCert = nil
        collectionsStorage = [:]
        likedDislikedArtistsStorage = SPLikeController(liked: SPCollectionController(name: SPCollectionController.likedArtistsCollectionName, notificationChannel: .SPArtistLikeUpdate), disliked: SPCollectionController(name: SPCollectionController.dislikedArtistsCollectionName, notificationChannel: .SPArtistDislikeUpdate))
        likedDislikedAlbumsStorage = SPLikeController(liked: SPCollectionController(name: SPCollectionController.likedTracksAndAlbumsCollectionName, notificationChannel: .SPAlbumLikeUpdate), disliked: SPCollectionController(name: SPCollectionController.dislikedTracksAndAlbumsCollectionName, notificationChannel: .SPAlbumDislikeUpdate))
        likedDislikedTracksStorage = SPLikeController(liked: SPCollectionController(name: SPCollectionController.likedTracksAndAlbumsCollectionName, notificationChannel: .SPTrackLikeUpdate), disliked: SPCollectionController(name: SPCollectionController.dislikedTracksAndAlbumsCollectionName, notificationChannel: .SPTrackDislikeUpdate))
        artistsMetaStorage = SPMetaInfoController<SPMetadataArtist>(initItems: artistsMeta, keyValidator: SPNavigateUriUtil.validateArtistUri, updateItemNotificationBuilder: SPMetaInfoController<SPMetadataArtist>.buildArtistMetaUpdateNotification)
        albumsMetaStorage = SPMetaInfoController<SPMetadataAlbum>(initItems: albumsMeta, keyValidator: SPNavigateUriUtil.validateAlbumUri, updateItemNotificationBuilder: SPMetaInfoController<SPMetadataAlbum>.buildAlbumMetaUpdateNotification)
        playlistsMetaStorage = SPMetaInfoController<SPPlaylist>(initItems: playlistsMeta, keyValidator: SPNavigateUriUtil.validatePlaylistUri, updateItemNotificationBuilder: SPMetaInfoController<SPPlaylist>.buildPlaylistMetaUpdateNotification)
        tracksMetaStorage = SPMetaInfoController<SPMetadataTrack>(initItems: tracksMeta, keyValidator: SPNavigateUriUtil.validateTrackUri, updateItemNotificationBuilder: SPMetaInfoController<SPMetadataTrack>.buildTrackMetaUpdateNotification)
        lyricsStorage = SPMetaInfoController<SPLyrics>(initItems: lyricsInfo, keyValidator: { key in
            return true
        }, updateItemNotificationBuilder: SPMetaInfoController<SPLyrics>.buildLyricsUpdateNotification)
        downloadInfoStorage = SPDownloadInfoController(di: [:], seektables: [:], intents: [:])
    }
    
    ///Authorized state ctor
    ///- Parameter appVersionCode: Spotify client version code
    ///- Parameter webAppVersionCode: Spotify web client version code
    ///- Parameter clientId: Spotify client ID
    ///- Parameter clValidationKey: Spotify client validation key
    ///- Parameter playIntentToken: Spotify PlayPlayReq token
    ///- Parameter device: Device info
    ///- Parameter clToken: Client token
    ///- Parameter clTokenExpiresInS: Client token lifetime duration is seconds
    ///- Parameter clTokenCreateTsUTC: Client token creation timestamp (UTC+0)
    ///- Parameter authToken: Authorization token
    ///- Parameter authExpiresInS: Authorization token lifetime duration in seconds
    ///- Parameter username: Username for refresh authorization token
    ///- Parameter storedCred: Stored credentials data for refresh authorization token
    ///- Parameter authTokenCreateTsUTC: Authorization token creation timestamp (UTC+0)
    ///- Parameter artistsMeta: Artists info for meta repository
    ///- Parameter albumsMeta: Albums info for meta repository
    ///- Parameter playlistsMeta: Playlists info for meta repository
    ///- Parameter tracksMeta: Tracks info for meta repository
    ///- Parameter lyricsInfo: Lyrics info for repository
    ///- Parameter likedDislikedArtists: User liked/disliked artist collections
    ///- Parameter likedDislikedTracks User liked/disliked track collections
    ///- Parameter userCollections: User collections, without like/dislike
    ///- Parameter downloadInfos: Download infos dictionary. Key is hexFileId
    ///- Parameter playIntents: Play intents dictionary. Key is hexFileId
    ///- Returns: SPClient instance on authorized state
    public init(appVersionCode: String = SPConstants.appVersionCode, webAppVersionCode: String = SPConstants.webAppVersionCode, clientId: String = SPConstants.androidClID, clValidationKey: String = SPConstants.clValidationKey, device: SPDevice, clToken: String, clTokenExpires: Int32, clTokenRefreshAfter: Int32, clTokenCreateTsUTC: Int64, authToken: String, authExpiresInS: Int32, username: String, storedCred: [UInt8], authTokenCreateTsUTC: Int64, artistsMeta: [String: SPMetadataArtist] = [:], albumsMeta: [String: SPMetadataAlbum] = [:], playlistsMeta: [String: SPPlaylist] = [:], tracksMeta: [String: SPMetadataTrack] = [:], lyricsInfo: [String: SPLyrics] = [:], likedDislikedArtists: SPLikeController? = nil, likedDislikedAlbums: SPLikeController? = nil, likedDislikedTracks: SPLikeController? = nil, userCollections: [String: SPCollectionController] = [:], downloadInfos: [String: SPDownloadInfo] = [:], seektables: [String: SPWDVSeektable] = [:], playIntents: [String: SPPlayIntentResponse] = [:]) {
        self.appVersionCode = appVersionCode
        self.webAppVersionCode = webAppVersionCode
        self.clientId = clientId
        self.clientValidationKey = clValidationKey
        self.device = device
        self.clToken = SPClientToken()
        self.clToken.val = clToken
        self.clToken.expiresInS = clTokenExpires
        self.clToken.refreshAfterS = clTokenRefreshAfter
        self.clTokenCreateTsUTC = clTokenCreateTsUTC
        guestAuthSession = SPAuthSession()
        authSession = SPAuthToken()
        authSession.token = authToken
        authSession.expiresInS = authExpiresInS
        authSession.username = username
        authSession.storedCredential = Data(storedCred)
        self.authTokenCreateTsUTC = authTokenCreateTsUTC
        apHosts = []
        dealerHosts = []
        spclientHosts = []
        wdvCert = nil
        artistsMetaStorage = SPMetaInfoController<SPMetadataArtist>(initItems: artistsMeta, keyValidator: SPNavigateUriUtil.validateArtistUri, updateItemNotificationBuilder: SPMetaInfoController<SPMetadataArtist>.buildArtistMetaUpdateNotification)
        albumsMetaStorage = SPMetaInfoController<SPMetadataAlbum>(initItems: albumsMeta, keyValidator: SPNavigateUriUtil.validateAlbumUri, updateItemNotificationBuilder: SPMetaInfoController<SPMetadataAlbum>.buildAlbumMetaUpdateNotification)
        playlistsMetaStorage = SPMetaInfoController<SPPlaylist>(initItems: playlistsMeta, keyValidator: SPNavigateUriUtil.validatePlaylistUri, updateItemNotificationBuilder: SPMetaInfoController<SPPlaylist>.buildPlaylistMetaUpdateNotification)
        tracksMetaStorage = SPMetaInfoController<SPMetadataTrack>(initItems: tracksMeta, keyValidator: SPNavigateUriUtil.validateTrackUri, updateItemNotificationBuilder: SPMetaInfoController<SPMetadataTrack>.buildTrackMetaUpdateNotification)
        lyricsStorage = SPMetaInfoController<SPLyrics>(initItems: lyricsInfo, keyValidator: { key in
            return true
        }, updateItemNotificationBuilder: SPMetaInfoController<SPLyrics>.buildLyricsUpdateNotification)
        self.likedDislikedArtistsStorage = likedDislikedArtists ?? SPLikeController(liked: SPCollectionController(name: SPCollectionController.likedArtistsCollectionName, notificationChannel: .SPArtistLikeUpdate), disliked: SPCollectionController(name: SPCollectionController.dislikedArtistsCollectionName, notificationChannel: .SPArtistDislikeUpdate))
        self.likedDislikedAlbumsStorage = likedDislikedAlbums ?? SPLikeController(liked: SPCollectionController(name: SPCollectionController.likedTracksAndAlbumsCollectionName, notificationChannel: .SPAlbumLikeUpdate), disliked: SPCollectionController(name: SPCollectionController.dislikedTracksAndAlbumsCollectionName, notificationChannel: .SPAlbumDislikeUpdate))
        self.likedDislikedTracksStorage = likedDislikedArtists ?? SPLikeController(liked: SPCollectionController(name: SPCollectionController.likedTracksAndAlbumsCollectionName, notificationChannel: .SPTrackLikeUpdate), disliked: SPCollectionController(name: SPCollectionController.dislikedTracksAndAlbumsCollectionName, notificationChannel: .SPTrackDislikeUpdate))
        collectionsStorage = userCollections
        self.downloadInfoStorage = SPDownloadInfoController(di: downloadInfos, seektables: seektables, intents: playIntents)
    }
}
