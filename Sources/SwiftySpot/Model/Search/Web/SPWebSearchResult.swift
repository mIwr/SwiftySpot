//
//  SPWebSearchResult.swift
//  SwiftySpot
//
//  Created by developer on 15.11.2024.
//

import Foundation

public class SPWebSearchResult: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case artists
        case albums = "albumsV2"
        case episodes
        case genres
        case playlists
        case podcasts
        case tracks = "tracksV2"
        case users
        case topResults = "topResultsV2"
    }
    
    ///Found artists
    public let artists: [SPWebSearchArtist]
    ///Total count of found artists
    public let totalArtits: Int
    ///Found albums
    public let albums: [SPWebSearchAlbum]
    ///Total count of found albums
    public let totalAlbums: Int
    ///Found playlists
    public let playlists: [SPWebSearchPlaylist]
    ///Total count of found playlists
    public let totalPlaylists: Int
    ///Found tracks
    public let tracks: [SPWebSearchTrack]
    ///Total count of found tracks
    public let totalTracks: Int
    ///Found user profiles
    public let users: [SPWebSearchProfile]
    ///Total count of found user profiles
    public let totalUsers: Int
    ///Found audio shows and podcasts
    public let podcasts: [SPWebSearchAudioShow]
    ///Total count of found podcasts
    public let totalPodcasts: Int
    ///Search top results
    public let topResults: SPWebSearchTopResults
    public var totalTopResults: Int {
        get {
            return topResults.items.count
        }
    }
    
    //+ genres, episodes, chipOrder
    
    public init() {
        self.artists = []
        self.totalArtits = 0
        self.albums = []
        self.totalAlbums = 0
        self.playlists = []
        self.totalPlaylists = 0
        self.tracks = []
        self.totalTracks = 0
        self.users = []
        self.totalUsers = 0
        self.podcasts = []
        self.totalPodcasts = 0
        self.topResults = SPWebSearchTopResults(items: [])
    }
    
    public init(artists: [SPWebSearchArtist], totalArtits: Int, albums: [SPWebSearchAlbum], totalAlbums: Int, playlists: [SPWebSearchPlaylist], totalPlaylists: Int, tracks: [SPWebSearchTrack], totalTracks: Int, users: [SPWebSearchProfile], totalUsers: Int, podcasts: [SPWebSearchAudioShow], totalPodcasts: Int, topResults: SPWebSearchTopResults) {
        self.artists = artists
        self.totalArtits = totalArtits
        self.albums = albums
        self.totalAlbums = totalAlbums
        self.playlists = playlists
        self.totalPlaylists = totalPlaylists
        self.tracks = tracks
        self.totalTracks = totalTracks
        self.users = users
        self.totalUsers = totalUsers
        self.podcasts = podcasts
        self.totalPodcasts = totalPodcasts
        self.topResults = topResults
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        if let safeArtistsWrapper = try? container.decodeIfPresent(SPWebSearchResultEntry<SPWebSearchArtistWrapper>.self, forKey: .artists) {
            self.artists = safeArtistsWrapper.items.map({ wrapper in
                return wrapper.data
            })
            self.totalArtits = safeArtistsWrapper.total
        } else {
            self.artists = []
            self.totalArtits = 0
        }
        if let safeAlbumsWrapper = try? container.decodeIfPresent(SPWebSearchResultEntry<SPWebSearchAlbumWrapper>.self, forKey: .albums) {
            self.albums = safeAlbumsWrapper.items.map({ wrapper in
                return wrapper.data
            })
            self.totalAlbums = safeAlbumsWrapper.total
        } else {
            self.albums = []
            self.totalAlbums = 0
        }
        if let safePlaylistsWrapper = try? container.decodeIfPresent(SPWebSearchResultEntry<SPWebSearchPlaylistWrapper>.self, forKey: .playlists) {
            self.playlists = safePlaylistsWrapper.items.map({ wrapper in
                return wrapper.data
            })
            self.totalPlaylists = safePlaylistsWrapper.total
        } else {
            self.playlists = []
            self.totalPlaylists = 0
        }
        if let safeTracksWrapper = try? container.decodeIfPresent(SPWebSearchResultEntry<SPWebSearchResultEntryItem<SPWebSearchTrackWrapper>>.self, forKey: .tracks) {
            self.tracks = safeTracksWrapper.items.map({ entry in
                return entry.item.data
            })
            self.totalTracks = safeTracksWrapper.total
        } else {
            self.tracks = []
            self.totalTracks = 0
        }
        if let safeUsersWrapper = try? container.decodeIfPresent(SPWebSearchResultEntry<SPWebSearchProfileWrapper>.self, forKey: .users) {
            self.users = safeUsersWrapper.items.map({ wrapper in
                return wrapper.data
            })
            self.totalUsers = safeUsersWrapper.total
        } else {
            self.users = []
            self.totalUsers = 0
        }
        if let safePodcastsWrapper = try? container.decodeIfPresent(SPWebSearchResultEntry<SPWebSearchPodcastWrapper>.self, forKey: .podcasts) {
            self.podcasts = safePodcastsWrapper.items.map({ wrapper in
                return wrapper.data
            })
            self.totalPodcasts = safePodcastsWrapper.total
        } else {
            self.podcasts = []
            self.totalPodcasts = 0
        }
        //+ genres, episodes, chipOrder
        //TODO fix by tests results
        self.topResults = (try? container.decodeIfPresent(SPWebSearchTopResults.self, forKey: .topResults)) ?? SPWebSearchTopResults(items: [])
    }
}

extension SPWebSearchResult {
    
    public func asSearchResultEntities() -> [SPSearchEntity] {
        var res: [SPSearchEntity] = []
        res.append(contentsOf: topResults.items)
        res.append(contentsOf: artists.map({ artist in
            return artist.asSearchObj()
        }))
        res.append(contentsOf: albums.map({ album in
            return album.asSearchObj()
        }))
        res.append(contentsOf: playlists.map({ playlist in
            return playlist.asSearchObj()
        }))
        res.append(contentsOf: tracks.map({ track in
            return track.asSearchObj()
        }))
        res.append(contentsOf: users.map({ user in
            return user.asSearchObj()
        }))
        res.append(contentsOf: podcasts.map({ podcast in
            return podcast.asSearchObj()
        }))
        return res
    }
    
}

class SPWebSearchResultWrapper: Decodable {
    
    let data: SPWebSearchResultContainerV2
    
    init(data: SPWebSearchResultContainerV2) {
        self.data = data
    }
    
    enum CodingKeys: CodingKey {
        case data
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode(SPWebSearchResultContainerV2.self, forKey: .data)
    }
}

class SPWebSearchResultContainerV2: Decodable {
    
    let searchV2: SPWebSearchResult
    
    init(searchV2: SPWebSearchResult) {
        self.searchV2 = searchV2
    }
    
}

class SPWebSearchResultEntry<T: Decodable>: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case items
        case total = "totalCount"
    }
    
    let items: [T]
    let total: Int
    
    init(items: [T], total: Int) {
        self.items = items
        self.total = total
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let wrappers = try container.decode([T].self, forKey: .items)
        self.items = wrappers.map({ wrapper in
            return wrapper
        })
        self.total = (try? container.decodeIfPresent(Int.self, forKey: .total)) ?? items.count
    }
}

class SPWebSearchResultEntryItem<T: Decodable>: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case item
        case matches = "matchedFields"
    }
    
    let item: T
    //let matches:Array<>
    
    public init(item: T) {
        self.item = item
    }
    
    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.item = try container.decode(T.self, forKey: .item)
    }
}

class SPWebSearchResultEntryWrapper<T: Decodable>: SPWebSearchResultEntryMetaWrapper {
    
    enum CodingKeys: String, CodingKey {
        case data
    }
    
    let data: T
    
    init(typename: String, data: T) {
        self.data = data
        super.init(typename: typename)
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.data = try container.decode(T.self, forKey: .data)
        try super.init(from: decoder)
    }
}

class SPWebSearchResultEntryMetaWrapper: Decodable {
    
    enum CodingKeys: String, CodingKey {
        case typename = "__typename"
    }
    
    let typename: String
    
    init(typename: String) {
        self.typename = typename
    }
    
    public required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.typename = try container.decode(String.self, forKey: .typename)
    }
}
