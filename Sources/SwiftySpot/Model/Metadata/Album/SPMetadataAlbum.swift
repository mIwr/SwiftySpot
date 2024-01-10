//
//  SPMetadataAlbum.swift
//  SwiftySpot
//
//  Created by Developer on 19.09.2023.
//

import Foundation

///Album meta info
public class SPMetadataAlbum: SPTypedObj {
    ///Album name
    public let name: String
    ///Brief meta info about album artists
    public let artists: [SPMetadataArtist]
    ///Album type
    public let type: SPMetadataAlbumType
    ///Album label name
    public let label: String
    ///Release timestamp
    public let releaseTsUTC: Int64
    ///Release date instance
    public var releaseDate: Date {
        get {
            let dt = Date(timeIntervalSince1970: TimeInterval(releaseTsUTC))
            return dt
        }
    }
    ///Release year
    public var releaseYear: UInt16 {
        get {
            let components = Calendar.current.dateComponents([.year], from: releaseDate)
            let year = components.year ?? 1970
            return UInt16(year)
        }
    }
    ///Album popularity
    public let popularity: Int32
    ///Album cover image info
    public let cover: [SPMetadataImg]
    ///Album external IDs
    public let extIds: [SPMetadataExtId]
    ///Album discs info
    public let discs: [SPMetadataDisc]
    ///Album copyrights
    public let copyrights: [SPMetadataCopyright]
    ///Album restrictions info
    public let restrictions: [SPMetadataRestriction]
    ///Brief meta info about related albums
    public let related: [SPMetadataAlbum]
    ///Album sale periods info
    public let salePeriods: [SPMetadataSalePeriod]
    ///Album cover variants by size
    public let coverGroup: [[SPMetadataImg]]
    ///Album stock  name
    public let origName: String
    ///Album version name
    public let versionName: String
    ///Album type string
    public let typeStr: String
    ///Album earliest live timestamp
    public let earliestLiveTs: Int64
    ///Album availability info
    public let availability: [SPMetadataAvailability]
    public let windowedTracks: [SPMetadataTrack]
    ///Album licensor
    public let licensor: SPMetadataLicensor?
    ///Album meta version
    public let version: Int64
    ///Feed GID
    public let feedGid: String
    ///Album delivery ID
    public let deliveryId: String
    ///Album localized names
    public let localizedNames: [SPMetadataLocalizedString]
    
    
    public init(gid: [UInt8], name: String, uri: String = "", artists: [SPMetadataArtist] = [], type: SPMetadataAlbumType = .ALBUM, label: String = "", releaseTsUTC: Int64 = 0, popularity: Int32 = 0, cover: [SPMetadataImg] = [], extIds: [SPMetadataExtId] = [], discs: [SPMetadataDisc] = [], copyrights: [SPMetadataCopyright] = [], restrictions: [SPMetadataRestriction] = [], related: [SPMetadataAlbum] = [], salePeriods: [SPMetadataSalePeriod] = [], coverGroup: [[SPMetadataImg]] = [], origName: String = "", versionName: String = "", typeStr: String = "", earliestLiveTs: Int64 = 0, availability: [SPMetadataAvailability] = [], windowedTracks: [SPMetadataTrack] = [], licensor: SPMetadataLicensor? = nil, version: Int64 = 0, feedGid: String = "", deliveryId: String = "", localizedNames: [SPMetadataLocalizedString] = []) {
        self.name = name
        self.artists = artists
        self.type = type
        self.label = label
        self.releaseTsUTC = releaseTsUTC
        self.popularity = popularity
        self.cover = cover
        self.extIds = extIds
        self.discs = discs
        self.copyrights = copyrights
        self.restrictions = restrictions
        self.related = related
        self.salePeriods = salePeriods
        self.coverGroup = coverGroup
        self.origName = origName
        self.versionName = versionName
        self.typeStr = typeStr
        self.earliestLiveTs = earliestLiveTs
        self.availability = availability
        self.windowedTracks = windowedTracks
        self.licensor = licensor
        self.version = version
        self.feedGid = feedGid
        self.deliveryId = deliveryId
        self.localizedNames = localizedNames
        
        if (!uri.isEmpty) {
            if (!gid.isEmpty) {
                super.init(uri: uri, globalID: gid)
                return
            }
            super.init(uri: uri)
            return
        }
        super.init(globalID: gid, type: .album)
    }
    
    static func from(protobuf: Spotify_Metadata_Album, uri: String) -> SPMetadataAlbum {
        let gid = [UInt8].init(protobuf.gid)
        let safeUri = !protobuf.uri.isEmpty && protobuf.uri == uri ? protobuf.uri : uri //reserving navigate uri
        var artists: [SPMetadataArtist] = []
        for item in protobuf.artists {
            let parsed = SPMetadataArtist.from(protobuf: item, uri: "")
            artists.append(parsed)
        }
        let type = SPMetadataAlbumType.from(protobuf: protobuf.type)
        let dt = SPMetadataDate.from(protobuf: protobuf.date)
        let ts = dt.timestamp
        var cover: [SPMetadataImg] = []
        for item in protobuf.cover {
            let parsed = SPMetadataImg.from(protobuf: item)
            cover.append(parsed)
        }
        var extIds: [SPMetadataExtId] = []
        for extItem in protobuf.externalIds {
            let parsed = SPMetadataExtId.from(protobuf: extItem)
            extIds.append(parsed)
        }
        var discs: [SPMetadataDisc] = []
        for item in protobuf.discs {
            let parsed = SPMetadataDisc.from(protobuf: item)
            discs.append(parsed)
        }
        var copyrights: [SPMetadataCopyright] = []
        for item in protobuf.copyrights {
            let parsed = SPMetadataCopyright.from(protobuf: item)
            copyrights.append(parsed)
        }
        var restrictions: [SPMetadataRestriction] = []
        for item in protobuf.restrictions {
            let parsed = SPMetadataRestriction.from(protobuf: item)
            restrictions.append(parsed)
        }
        var salePeriods: [SPMetadataSalePeriod] = []
        for item in protobuf.saledPeriods {
            let parsed = SPMetadataSalePeriod.from(protobuf: item)
            salePeriods.append(parsed)
        }
        let coverGroup = SPMetadataImg.fromGroup(protobuf.coverGroup)
        var availability: [SPMetadataAvailability] = []
        for item in protobuf.availability {
            let parsed = SPMetadataAvailability.from(protobuf: item)
            availability.append(parsed)
        }
        var windowedTracks: [SPMetadataTrack] = []
        for item in protobuf.windowedTracks {
            let parsed = SPMetadataTrack.from(protobuf: item, uri: "")
            windowedTracks.append(parsed)
        }
        var licensor: SPMetadataLicensor? = nil
        if (protobuf.hasLicensor) {
            licensor = SPMetadataLicensor.from(protobuf: protobuf.licensor)
        }
        var localizedNames: [SPMetadataLocalizedString] = []
        for item in protobuf.localizedNames {
            let parsed = SPMetadataLocalizedString.from(protobuf: item)
            localizedNames.append(parsed)
        }
        var related: [SPMetadataAlbum] = []
        for item in protobuf.related {
            let shortGid = [UInt8].init(item.gid)
            let shortName = item.name
            //extract short info without recursion
            let parsed = SPMetadataAlbum(gid: shortGid, name: shortName)
            related.append(parsed)
        }
        
        return SPMetadataAlbum(gid: gid, name: protobuf.name, uri: safeUri, artists: artists, type: type, label: protobuf.label, releaseTsUTC: ts, popularity: protobuf.popularity, cover: cover, extIds: extIds, discs: discs, copyrights: copyrights, restrictions: restrictions, related: related, salePeriods: salePeriods, coverGroup: coverGroup, origName: protobuf.originalTitle, versionName: protobuf.versionTitle, typeStr: protobuf.typeStr, earliestLiveTs: protobuf.earliestLiveTimestamp, availability: availability, windowedTracks: windowedTracks, licensor: licensor, version: protobuf.version, feedGid: protobuf.feedGid, deliveryId: protobuf.deliveryID, localizedNames: localizedNames)
    }
}
