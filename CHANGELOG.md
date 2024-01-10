#  Changelog

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
