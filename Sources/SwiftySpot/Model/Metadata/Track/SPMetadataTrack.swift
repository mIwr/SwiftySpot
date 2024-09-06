//
//  SPMetadataTrack.swift
//  SwiftySpot
//
//  Created by Developer on 19.09.2023.
//

///Track meta info
public class SPMetadataTrack: SPTypedObj {
    ///Track name
    public let name: String
    ///Brief meta about track album
    public let album: SPMetadataAlbum?
    ///Brief meta about track artists
    public let artists: [SPMetadataArtist]
    ///Track number in disc
    public let number: Int32
    ///Disc number with track
    public let discNumber: Int32
    ///Stock track duration in millis
    public let durationInMs: Int32
    ///Track popularity
    public let popularity: Int32
    ///Track is explicit flag
    public let explicit: Bool
    ///Track external IDs
    public let extIds: [SPMetadataExternalId]
    ///Track restrictions info
    public let restrictions: [SPMetadataRestriction]
    ///Available audio files (codecs) for track
    public let files: [SPMetadataAudioFile]
    ///Brief meta about track alternatives
    public let alternatives: [SPMetadataTrack]
    ///Track sale periods
    public let salePeriods: [SPMetadataSalePeriod]
    ///Track preview audio files (codecs)
    public let previews: [SPMetadataAudioFile]
    ///Track tags
    public let tags: [String]
    ///Earliest live timestamp for track
    public let earliestLiveTs: Int64
    ///Track has lyrics flag
    public let lyrics: Bool
    ///Track localized names
    public let localizedNames: [SPMetadataLocalizedString]
    ///Track availability info
    public let availability: [SPMetadataAvailability]
    ///Track licensor info
    public let licensor: SPMetadataLicensor?
    ///Track field with language or perfomance info
    public let langOrPerfomance: [String]
    ///Stock  track audio file (codec)
    public let original: SPMetadataAudioFile?
    ///Track content rating info
    public let contentRating: [SPMetadataContentRating]
    ///Track meta version
    public let indexVersion: Int64
    ///Track stock name
    public let origName: String
    ///Track version name
    public let versionName: String
    ///Meta info about artists's roles
    public let artistWithRole: [SPMetadataArtistWithRole]
    
    ///Generates preview download urls map from ogg vorbis audio files and previews only. Urls with hex fileID from others codecs causes 404 error
    public var previewDownloadUrls: [SPMetadataAudioFormat: String] {
        get {
            var res: [SPMetadataAudioFormat: String] = [:]
            for audio in files {
                if (!audio.format.oggVorbis) {
                    continue
                }
                let url = SPConstants.defaultCdnHeadsHost + "head/" + audio.hexId
                res[audio.format] = url
            }
            for preview in previews {
                if (!preview.format.availableFree) {
                    continue
                }
                let url = SPConstants.defaultCdnHeadsHost + "head/" + preview.hexId
                res[preview.format] = url
            }
            return res
        }
    }
    
    public init(gid: [UInt8], name: String, uri: String = "", album: SPMetadataAlbum? = nil, artists: [SPMetadataArtist] = [], number: Int32 = 0, discNumber: Int32 = 0, durationInMs: Int32 = 0, popularity: Int32 = 0, explicit: Bool = false, extIds: [SPMetadataExternalId] = [], restrictions: [SPMetadataRestriction] = [], files: [SPMetadataAudioFile] = [], alternatives: [SPMetadataTrack] = [], salePeriods: [SPMetadataSalePeriod] = [], previews: [SPMetadataAudioFile] = [], tags: [String] = [], earliestLiveTs: Int64 = 0, lyrics: Bool = false, localizedNames: [SPMetadataLocalizedString] = [], availability: [SPMetadataAvailability] = [], licensor: SPMetadataLicensor? = nil, langOrPerfomance: [String] = [], original: SPMetadataAudioFile? = nil, contentRating: [SPMetadataContentRating] = [], indexVersion: Int64 = 0, origName: String = "", versionName: String = "", artistWithRole: [SPMetadataArtistWithRole] = []) {
        self.name = name
        self.album = album
        self.artists = artists
        self.number = number
        self.discNumber = discNumber
        self.durationInMs = durationInMs
        self.popularity = popularity
        self.explicit = explicit
        self.extIds = extIds
        self.restrictions = restrictions
        self.files = files
        self.alternatives = alternatives
        self.salePeriods = salePeriods
        self.previews = previews
        self.tags = tags
        self.earliestLiveTs = earliestLiveTs
        self.lyrics = lyrics
        self.localizedNames = localizedNames
        self.availability = availability
        self.licensor = licensor
        self.langOrPerfomance = langOrPerfomance
        self.original = original
        self.contentRating = contentRating
        self.indexVersion = indexVersion
        self.origName = origName
        self.versionName = versionName
        self.artistWithRole = artistWithRole
        
        if (!uri.isEmpty) {
            if (!gid.isEmpty) {
                super.init(uri: uri, globalID: gid)
                return
            }
            super.init(uri: uri)
            return
        }
        super.init(globalID: gid, type: .track)
    }
    
    public func findPreviewAudioFile(codec: SPMetadataAudioFormat) -> SPMetadataAudioFile? {
        for variant in previews {
            if (variant.format != codec) {
                continue
            }
            return variant
        }
        return nil
    }
    
    public func findAudioFile(codec: SPMetadataAudioFormat) -> SPMetadataAudioFile? {
        for variant in files {
            if (variant.format != codec) {
                continue
            }
            return variant
        }
        if let safeOrigFile = original, safeOrigFile.format == codec {
            return safeOrigFile
        }
        return nil
    }
    
    static func from(protobuf: SPMetaTrack, uri: String) -> SPMetadataTrack {
        let gid = [UInt8].init(protobuf.gid)
        let safeUri = !protobuf.uri.isEmpty && protobuf.uri == uri ? protobuf.uri : uri //reserving navigate uri
        var album: SPMetadataAlbum?
        if (protobuf.hasAlbum) {
            album = SPMetadataAlbum.from(protobuf: protobuf.album, uri: "")
        }
        var artists: [SPMetadataArtist] = []
        for item in protobuf.artists {
            let parsed = SPMetadataArtist.from(protobuf: item, uri: "")
            artists.append(parsed)
        }
        var alternatives: [SPMetadataTrack] = []
        for item in protobuf.alternatives {
            let shortGid = [UInt8].init(item.gid)
            let shortName = item.name
            //extract short info without recursion
            let parsed = SPMetadataTrack(gid: shortGid, name: shortName)
            alternatives.append(parsed)
        }
        //Track always has duration which is x2 of real value
        
        return SPMetadataTrack(gid: gid, name: protobuf.name, uri: safeUri, album: album, artists: artists, number: protobuf.number, discNumber: protobuf.discNumber, durationInMs: protobuf.durationInMs / 2, popularity: protobuf.popularity, explicit: protobuf.explicit, extIds: protobuf.externalIds, restrictions: protobuf.restrictions, files: protobuf.files, alternatives: alternatives, salePeriods: protobuf.salePeriods, previews: protobuf.previews, tags: protobuf.tags, earliestLiveTs: protobuf.earliestLiveTimestamp, lyrics: protobuf.lyrics, localizedNames: protobuf.localizedNames, availability: protobuf.availability, licensor: protobuf.licensor, langOrPerfomance: protobuf.languageOrPerfomance, original: protobuf.original, contentRating: protobuf.contentRating, indexVersion: protobuf.indexVersion, origName: protobuf.originalTitle, versionName: protobuf.versionTitle, artistWithRole: protobuf.artistWithRole)
    }
}
