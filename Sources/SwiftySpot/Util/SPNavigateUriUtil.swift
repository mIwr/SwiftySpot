//
//  SPNavigateUriUtil.swift
//  SwiftySpot
//
//  Created by Developer on 21.09.2023.
//

///Navigation uri uitls
public final class SPNavigateUriUtil {
    
    fileprivate init() {}
    
    ///Generate navigation uri with kind 'spotify:artist:{artistID}'
    public static func generateArtistUri(id: String) -> String {
        return SPConstants.artistUriPrefix + id
    }
    public static func validateArtistUri(_ uri: String) -> Bool {
        return uri.hasPrefix(SPConstants.artistUriPrefix)
    }
    ///Generate navigation uri with kind 'spotify:album:{albumID}'
    public static func generateAlbumUri(id: String) -> String {
        return SPConstants.albumUriPrefix + id
    }
    public static func validateAlbumUri(_ uri: String) -> Bool {
        return uri.hasPrefix(SPConstants.albumUriPrefix)
    }
    ///Generate navigation uri with kind 'spotify:playlist:{playlistID}'
    public static func generatePlaylistUri(id: String) -> String {
        return SPConstants.playlistUriPrefix + id
    }
    public static func validatePlaylistUri(_ uri: String) -> Bool {
        return uri.hasPrefix(SPConstants.playlistUriPrefix)
    }
    ///Generate navigation uri with kind 'spotify:track:{trackID}'
    public static func generateTrackUri(id: String) -> String {
        return SPConstants.trackUriPrefix + id
    }
    public static func validateTrackUri(_ uri: String) -> Bool {
        return uri.hasPrefix(SPConstants.trackUriPrefix)
    }
    ///Generate navigation uri with kind 'spotify:user:{UserID or Username}'
    public static func generateUserUri(username: String) -> String {
        return SPConstants.userUriPrefix + username
    }
    public static func validateUserUri(_ uri: String) -> Bool {
        return uri.hasPrefix(SPConstants.userUriPrefix)
    }
    public static func extractUsernameFromUserUri(_ uri: String) -> String {
        return uri.replacingOccurrences(of: SPConstants.userUriPrefix, with: "")
    }
    public static func validateSearchUri(_ uri: String) -> Bool {
        return uri.hasPrefix(SPConstants.searchUriPrefix)
    }
    public static func extractSearchQuery(uri: String) -> String {
        if (!validateSearchUri(uri)) {
            return ""
        }
        let query = uri.replacingOccurrences(of: SPConstants.searchUriPrefix, with: "").replacingOccurrences(of: "+", with: " ")
        return query
    }
}
