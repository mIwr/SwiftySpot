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
    ///Top tracks short info
    public let topTracks: [SPMetadataTopTracks]
    ///Artist albums
    public let albumGroup: [[SPMetadataAlbum]]
    ///Artist singles
    public let singleGroup: [[SPMetadataAlbum]]
    ///Artist compilations
    public let compilationGroup: [[SPMetadataAlbum]]
    ///Artist appears albums
    public let appearsGroup: [[SPMetadataAlbum]]
    ///Artist affected genres
    public let genres: [String]
    ///Artist external IDs
    public let extIds: [SPMetadataExtId]
    ///Artist portraits
    public let portraitVariants: [SPMetadataImg]
    ///Artist bio
    public let bio: [SPMetadataBiography]
    public let restrictions: [SPMetadataRestriction]
    ///Artist activity info
    public let activity: [SPMetadataActivityPeriod]
    ///Brief meta info about related artists
    public let related: [SPMetadataArtist]
    public let isPortraitAlbumCover: Bool
    ///Artist portraits by size group
    public let portraitGroup: [[SPMetadataImg]]
    ///Artist sale periods
    public let salePeriods: [SPMetadataSalePeriod]
    ///Artist localized names
    public let localizedNames: [SPMetadataLocalizedString]
    ///Artist availability info
    public let availability: [SPMetadataAvailability]
    public let indexVersion: Int64
    
    public init(gid: [UInt8], name: String, uri: String = "", popularity: Int32 = 0, topTracks: [SPMetadataTopTracks] = [], albumGroup: [[SPMetadataAlbum]] = [], singleGroup: [[SPMetadataAlbum]] = [], compilationGroup: [[SPMetadataAlbum]] = [], appearsGroup: [[SPMetadataAlbum]] = [], genres: [String] = [], extIds: [SPMetadataExtId] = [], portraitVariants: [SPMetadataImg] = [], bio: [SPMetadataBiography] = [], restrictions: [SPMetadataRestriction] = [], activity: [SPMetadataActivityPeriod] = [], related: [SPMetadataArtist] = [], isPortraitAlbumCover: Bool = false, portraitGroup: [[SPMetadataImg]] = [], salePeriods: [SPMetadataSalePeriod] = [], localizedNames: [SPMetadataLocalizedString] = [], availability: [SPMetadataAvailability] = [], indexVersion: Int64 = 0) {
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
            let obj = SPTypedObj(uri: uri)
            if (obj.entityType != .artist && (!obj.globalID.isEmpty || obj.globalID == gid)) {
                super.init(uri: uri)
                return
            }
        }
        super.init(globalID: gid, type: .artist)
    }
    
    static func from(protobuf: Spotify_Metadata_Artist, uri: String) -> SPMetadataArtist {
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
        var extIds: [SPMetadataExtId] = []
        for extItem in protobuf.externalIds {
            let parsed = SPMetadataExtId.from(protobuf: extItem)
            extIds.append(parsed)
        }
        var portraitVariants: [SPMetadataImg] = []
        for item in protobuf.portraitVariants {
            let parsed = SPMetadataImg.from(protobuf: item)
            portraitVariants.append(parsed)
        }
        var bio: [SPMetadataBiography] = []
        for item in protobuf.biography {
            let parsed = SPMetadataBiography.from(protobuf: item)
            bio.append(parsed)
        }
        var restrictions: [SPMetadataRestriction] = []
        for item in protobuf.restrictions {
            let parsed = SPMetadataRestriction.from(protobuf: item)
            restrictions.append(parsed)
        }
        var activity: [SPMetadataActivityPeriod] = []
        for item in protobuf.activity {
            let parsed = SPMetadataActivityPeriod.from(protobuf: item)
            activity.append(parsed)
        }
        let portraitGroup = SPMetadataImg.fromGroup(protobuf.portraitGroup)
        var salePeriods: [SPMetadataSalePeriod] = []
        for item in protobuf.salePreiods {
            let parsed = SPMetadataSalePeriod.from(protobuf: item)
            salePeriods.append(parsed)
        }
        var localizedNames: [SPMetadataLocalizedString] = []
        for item in protobuf.localizedNames {
            let parsed = SPMetadataLocalizedString.from(protobuf: item)
            localizedNames.append(parsed)
        }
        var availability: [SPMetadataAvailability] = []
        for item in protobuf.availability {
            let parsed = SPMetadataAvailability.from(protobuf: item)
            availability.append(parsed)
        }
        var related: [SPMetadataArtist] = []
        for item in protobuf.related {
            let shortGid = [UInt8].init(item.gid)
            let shortName = item.name
            //extract short info without recursion
            let parsed = SPMetadataArtist(gid: shortGid, name: shortName)
            related.append(parsed)
        }
        
        return SPMetadataArtist(gid: gid, name: protobuf.name, uri: uri, topTracks: topTracks, albumGroup: albumGroup, singleGroup: singleGroup, compilationGroup: compilationGroup, appearsGroup: appearsGroup, genres: protobuf.genres, extIds: extIds, portraitVariants: portraitVariants, bio: bio, restrictions: restrictions, activity: activity, related: related, isPortraitAlbumCover: protobuf.isPortraitAlbumCover, portraitGroup: portraitGroup, salePeriods: salePeriods, localizedNames: localizedNames, availability: availability, indexVersion: protobuf.indexVersion)
    }
    
    fileprivate static func fromAlbumGroup(_ group: [Spotify_Metadata_AlbumGroup]) -> [[SPMetadataAlbum]] {
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
