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
    public let cover: [SPMetadataImage]
    ///Album external IDs
    public let extIds: [SPMetadataExternalId]
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
    public let coverGroup: [[SPMetadataImage]]
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
    
    
    public init(gid: [UInt8], name: String, uri: String = "", artists: [SPMetadataArtist] = [], type: SPMetadataAlbumType = .album, label: String = "", releaseTsUTC: Int64 = 0, popularity: Int32 = 0, cover: [SPMetadataImage] = [], extIds: [SPMetadataExternalId] = [], discs: [SPMetadataDisc] = [], copyrights: [SPMetadataCopyright] = [], restrictions: [SPMetadataRestriction] = [], related: [SPMetadataAlbum] = [], salePeriods: [SPMetadataSalePeriod] = [], coverGroup: [[SPMetadataImage]] = [], origName: String = "", versionName: String = "", typeStr: String = "", earliestLiveTs: Int64 = 0, availability: [SPMetadataAvailability] = [], windowedTracks: [SPMetadataTrack] = [], licensor: SPMetadataLicensor? = nil, version: Int64 = 0, feedGid: String = "", deliveryId: String = "", localizedNames: [SPMetadataLocalizedString] = []) {
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
    
    static func from(protobuf: SPMetaAlbum, uri: String) -> SPMetadataAlbum {
        let gid = [UInt8].init(protobuf.gid)
        let safeUri = !protobuf.uri.isEmpty && protobuf.uri == uri ? protobuf.uri : uri //reserving navigate uri
        var artists: [SPMetadataArtist] = []
        for item in protobuf.artists {
            let parsed = SPMetadataArtist.from(protobuf: item, uri: "")
            artists.append(parsed)
        }
        let ts = protobuf.date.timestamp
        var discs: [SPMetadataDisc] = []
        for item in protobuf.discs {
            let parsed = SPMetadataDisc.from(protobuf: item)
            discs.append(parsed)
        }
        let coverGroup = SPMetadataImage.fromGroup(protobuf.coverGroup)
        var windowedTracks: [SPMetadataTrack] = []
        for item in protobuf.windowedTracks {
            let parsed = SPMetadataTrack.from(protobuf: item, uri: "")
            windowedTracks.append(parsed)
        }
        var related: [SPMetadataAlbum] = []
        for item in protobuf.related {
            let shortGid = [UInt8].init(item.gid)
            let shortName = item.name
            //extract short info without recursion
            let parsed = SPMetadataAlbum(gid: shortGid, name: shortName)
            related.append(parsed)
        }
        
        return SPMetadataAlbum(gid: gid, name: protobuf.name, uri: safeUri, artists: artists, type: protobuf.type, label: protobuf.label, releaseTsUTC: ts, popularity: protobuf.popularity, cover: protobuf.cover, extIds: protobuf.externalIds, discs: discs, copyrights: protobuf.copyrights, restrictions: protobuf.restrictions, related: related, salePeriods: protobuf.salePeriods, coverGroup: coverGroup, origName: protobuf.originalTitle, versionName: protobuf.versionTitle, typeStr: protobuf.typeStr, earliestLiveTs: protobuf.earliestLiveTimestamp, availability: protobuf.availability, windowedTracks: windowedTracks, licensor: protobuf.licensor, version: protobuf.version, feedGid: protobuf.feedGid, deliveryId: protobuf.deliveryID, localizedNames: protobuf.localizedNames)
    }
}
