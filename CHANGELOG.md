#  Changelog

## Version 0.8.0
**18.04.2025**

**BREAKING CHANGES**

- Login v4 flow disables straight authorization with login/password. If you want to authorize without user interaction (captcha, email token and other), use login (account mail, username or phone number) with stored credentials

**API-related changes**

- Login v4 flow support
- Authorization by email token support
- Guest authorization fix
- Web search fix (Apollo GraphQL persisted queries' SHA256 hashes update)

**Other changes**

- Optimize proto models
- Hashcash solve fix
- Static mobile app client ID in SPClient *clID* marked as deprecated. Use IDs according OS platform

## Version 0.7.1
**22.11.2024**

**BREAKING CHANGES**

- Renamed 'SPCollectionPage' ctor parameter from 'pageSise' to 'pageSize'

**Other changes**

- Non-Apple platforms build support fixes

## Version 0.7.0
**21.11.2024**

**API-related changes**

- Guest authorization
- Guest authorization supported API methods:
-- Dac landing (Without personal playlists)
-- Playlist details
-- Metadata
-- Playlist generator by track seed
-- DRM'ed track
-- Search

**Other changes**

- Profile API endpoint variants to bypass Spotify restrictions

## Version 0.6.1
**01.10.2024**

**API-related changes**

- Login/Password authorization fix (User-Agent header rename according device platform)

## Version 0.6.0
**06.09.2024**

**BREAKING CHANGES**

- Replaced by stock protobuf non-main models and enums: 'Search', 'Metadata', 'Lyrics', 'Collection', 'DownloadInfo'
- Remove 'public' access modifier for util classes: [SPBinaryUtil](./Sources/SwiftySpot/Util/SPBinaryUtil.swift), [SPDateUtil](./Sources/SwiftySpot/Util/SPDateUtil.swift)

**API-related changes**

- Spotify seektable (contains Widevine PSSH box) support
- Spotify Widevine license request API support

**Other changes**

- Reduce boilerplate code by adopting some protobuf messages and enums for using outside of framework (public access modifier)
- Module privacy info

## Version 0.5.3
**19.03.2024**

**API-related changes**

- Authorization with login(phone,mail,username) and stored credential support. Internal impl is refreshing access token with the provided login and stored credential

**Other changes**

- New audio formats for download info
- Playlist generator from custom navigation uri support

## Version 0.5.2
**15.02.2024**

**API-related changes**

- Playlist generator from track seed

**Other changes**

- Landing playlists recognizer upd
- Lyrics API fix

_____________________________

## Version 0.5.1
**10.01.2024**

**API-related changes**

- Artist metadata resolver

**Other changes**

- GID <-> Base62 ID conversion fix
- API credentials refresher fix

_____________________________

## Version 0.5.0
**08.12.2023**

**BREAKING CHANGES**

- Deprecated meta repository *metaStorage* was deleted

**Other changes**

- API endpoints return *URLSessionDataTask?* instance for better API requests control
- Collection remote API unit tests XCAssert block fix
- Lib doc update

_____________________________

## Version 0.4.11
**17.11.2023**

**API-related changes**

- Lyrics support

**Other changes**

- Lyrics caching repository
- Separated meta storages (artists, albums, playlists, tracks, lyrics)
- Meta repostitory of SPClient *metaStorage* marked as deprecated and will be removed from 0.5.0 version. Use separated meta storages instead

_____________________________


## Version 0.4.10
**11.11.2023**

**API-related changes**

- Play intent error codes handler

**Other**

- Outdated playlist meta remove from storage

_____________________________

## Version 0.4.9
**03.11.2023**

**Initial release**

API blocks:
- Auth
- Landing (Dac)
- Profile info
- Metadata (Artist, Album, Playlist, Track)
- Favourite (Collection context)
- Search
_____________________________
