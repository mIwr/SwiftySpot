//
//  SPMetadataArtist.swift
//  SwiftySpot
//
//  Created by Developer on 19.09.2023.
//

///Artist meta info
public class SPMetadataArtist: SPTypedObj {
    ///Artist name
    public let name: String
    ///Artist popularity
    public let popularity: Int32
    ///Top tracks short info by countries
    public let topTracks: [SPMetadataTopTracks]
    public var allTopTracks: [SPMetadataTrack] {
        get {
            var res: [SPMetadataTrack] = []
            for countryTracks in topTracks {
                res.append(contentsOf: countryTracks.items)
            }
            return res
        }
    }
    ///Artist albums
    public let albumGroup: [[SPMetadataAlbum]]
    public var albums: [SPMetadataAlbum] {
        get {
            return extractGroup(albumGroup)
        }
    }
    ///Artist singles
    public let singleGroup: [[SPMetadataAlbum]]
    public var singles: [SPMetadataAlbum] {
        get {
            return extractGroup(singleGroup)
        }
    }
    ///Artist compilations
    public let compilationGroup: [[SPMetadataAlbum]]
    public var compilations: [SPMetadataAlbum] {
        get {
            return extractGroup(compilationGroup)
        }
    }
    ///Artist appears albums
    public let appearsGroup: [[SPMetadataAlbum]]
    public var appears: [SPMetadataAlbum] {
        get {
            return extractGroup(appearsGroup)
        }
    }
    ///All artist albums, singles, appears and compilations
    public var allAlbums: [SPMetadataAlbum] {
        get {
            var res: [SPMetadataAlbum] = []
            for group in albumGroup {
                res.append(contentsOf: group)
            }
            for group in albumGroup {
                res.append(contentsOf: group)
            }
            for group in singleGroup {
                res.append(contentsOf: group)
            }
            for group in compilationGroup {
                res.append(contentsOf: group)
            }
            for group in appearsGroup {
                res.append(contentsOf: group)
            }
            return res
        }
    }
    ///Artist affected genres
    public let genres: [String]
    ///Artist external IDs
    public let extIds: [SPMetadataExternalId]
    ///Artist portraits
    public let portraitVariants: [SPMetadataImage]
    ///Artist bio
    public let bio: [SPMetadataBiography]
    public let restrictions: [SPMetadataRestriction]
    ///Artist activity info
    public let activity: [SPMetadataActivityPeriod]
    ///Brief meta info about related artists
    public let related: [SPMetadataArtist]
    public let isPortraitAlbumCover: Bool
    ///Artist portraits by size group
    public let portraitGroup: [[SPMetadataImage]]
    ///Artist sale periods
    public let salePeriods: [SPMetadataSalePeriod]
    ///Artist localized names
    public let localizedNames: [SPMetadataLocalizedString]
    ///Artist availability info
    public let availability: [SPMetadataAvailability]
    public let indexVersion: Int64
    
    public init(gid: [UInt8], name: String, uri: String = "", popularity: Int32 = 0, topTracks: [SPMetadataTopTracks] = [], albumGroup: [[SPMetadataAlbum]] = [], singleGroup: [[SPMetadataAlbum]] = [], compilationGroup: [[SPMetadataAlbum]] = [], appearsGroup: [[SPMetadataAlbum]] = [], genres: [String] = [], extIds: [SPMetadataExternalId] = [], portraitVariants: [SPMetadataImage] = [], bio: [SPMetadataBiography] = [], restrictions: [SPMetadataRestriction] = [], activity: [SPMetadataActivityPeriod] = [], related: [SPMetadataArtist] = [], isPortraitAlbumCover: Bool = false, portraitGroup: [[SPMetadataImage]] = [], salePeriods: [SPMetadataSalePeriod] = [], localizedNames: [SPMetadataLocalizedString] = [], availability: [SPMetadataAvailability] = [], indexVersion: Int64 = 0) {
        self.name = name
        self.popularity = popularity
        self.topTracks = topTracks
        self.albumGroup = albumGroup
        self.singleGroup = singleGroup
        self.compilationGroup = compilationGroup
        self.appearsGroup = appearsGroup
        self.genres = genres
        self.extIds = extIds
        self.portraitVariants = portraitVariants
        self.bio = bio
        self.restrictions = restrictions
        self.activity = activity
        self.related = related
        self.isPortraitAlbumCover = isPortraitAlbumCover
        self.portraitGroup = portraitGroup
        self.salePeriods = salePeriods
        self.localizedNames = localizedNames
        self.availability = availability
        self.indexVersion = indexVersion
        
        if (!uri.isEmpty) {
            if (!gid.isEmpty) {
                super.init(uri: uri, globalID: gid)
                return
            }
            super.init(uri: uri)
            return
        }
        super.init(globalID: gid, type: .artist)
    }
    
    fileprivate func extractGroup<T: SPID>(_ group: [[T]]) -> [T] {
        var res: [T] = []
        var uriSet = Set<String>()
        for grNode in group {
            for item in grNode {
                if (uriSet.contains(item.hexGlobalID)) {
                    continue
                }
                res.append(item)
                uriSet.insert(item.hexGlobalID)
            }
        }
        return res
    }
    
    static func from(protobuf: SPMetaArtist, uri: String) -> SPMetadataArtist {
        let gid = [UInt8].init(protobuf.gid)
        var topTracks: [SPMetadataTopTracks] = []
        for top in protobuf.topTracks {
            let parsed = SPMetadataTopTracks.from(protobuf: top)
            topTracks.append(parsed)
        }
        let albumGroup = fromAlbumGroup(protobuf.albumGroup)
        let singleGroup = fromAlbumGroup(protobuf.singleGroup)
        let compilationGroup = fromAlbumGroup(protobuf.compilationGroup)
        let appearsGroup = fromAlbumGroup(protobuf.appearsOnGroup)
        let portraitGroup = SPMetadataImage.fromGroup(protobuf.portraitGroup)
        var related: [SPMetadataArtist] = []
        for item in protobuf.related {
            let shortGid = [UInt8].init(item.gid)
            let shortName = item.name
            //extract short info without recursion
            let parsed = SPMetadataArtist(gid: shortGid, name: shortName)
            related.append(parsed)
        }
        
        return SPMetadataArtist(gid: gid, name: protobuf.name, uri: uri, topTracks: topTracks, albumGroup: albumGroup, singleGroup: singleGroup, compilationGroup: compilationGroup, appearsGroup: appearsGroup, genres: protobuf.genres, extIds: protobuf.externalIds, portraitVariants: protobuf.portraitVariants, bio: protobuf.biography, restrictions: protobuf.restrictions, activity: protobuf.activity, related: related, isPortraitAlbumCover: protobuf.isPortraitAlbumCover, portraitGroup: portraitGroup, salePeriods: protobuf.salePeriods, localizedNames: protobuf.localizedNames, availability: protobuf.availability, indexVersion: protobuf.indexVersion)
    }
    
    fileprivate static func fromAlbumGroup(_ group: [SPMetaAlbumGroup]) -> [[SPMetadataAlbum]] {
        var parsedGroup: [[SPMetadataAlbum]] = []
        for itemGroup in group {
            var items: [SPMetadataAlbum] = []
            for item in itemGroup.albums {
                let parsed = SPMetadataAlbum.from(protobuf: item, uri: "")
                items.append(parsed)
            }
            parsedGroup.append(items)
        }
        return parsedGroup
    }
}
