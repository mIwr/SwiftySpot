#  SwiftySpot - Swift Spotify API Library

<p align="center">
    <img src="https://github.com/mIwr/SwiftySpot/blob/master/RepoAssets/logo.png?raw=true" width="320px"/>
</p>


[![Swift Package Manager compatible](https://img.shields.io/badge/SPM-compatible-brightgreen.svg?style=flat&colorA=28a745&&colorB=4E4E4E)](https://github.com/apple/swift-package-manager)
[![Platform](https://img.shields.io/badge/Platforms-iOS%20%7C%20Android%20%7CmacOS%20%7C%20watchOS%20%7C%20tvOS%20%7C%20Linux-4E4E4E.svg?colorA=28a745)](#Setup)


<p align="center">
    <a href="https://github.com/apple/swift">
        <img src="https://img.shields.io/badge/language-swift-orange.svg">
    </a>
    <a href="http://cocoapods.org/pods/SwiftySpot">
        <img src="https://img.shields.io/cocoapods/v/SwiftySpot.svg?style=flat">
    </a>
    <a href="http://cocoapods.org/pods/SwiftySpot">
        <img src="https://img.shields.io/cocoapods/p/SwiftySpot.svg?style=flat">
    </a>
    <a href="./LICENSE">
        <img src="https://img.shields.io/cocoapods/l/SwiftySpot.svg?style=flat">
    </a>
</p>

Spotify API swift implementation

## Content

- [Introduction](#Introduction)

- [Setup](#Setup)

- [Getting started](#Getting-started)

- [Examples](#Usage-examples)

- [Sample application](#App-example)

## Introduction

The library provides an interface for interacting with the Spotify API

macOS 10.13+ and iOS 11.0+ are supported by the module.

For work with Spotify API need:

- Active session (client token). Usually the token has a validity period of 14 days. The token is provided when the client passes the challenge. After expiration must be regenerated
- Authorization: access and refresh tokens. Usually the access token has a validity period of 2 hours. After expiration can be regenerated by refresh token, if exists, or by signing in
- Access point host (for some endpoints). Can be retrieved with active session

## Setup

### SwiftPM

SwiftySpot is available through SPM (Swift Package Manager)

```
.package(url: "https://github.com/mIwr/SwiftySpot.git", .from(from: "0.4.9"))
```

### CocoaPods

SwiftySpot is available with CocoaPods. To install a module, just add to the Podfile:

- iOS
```ruby
platform :ios, '11.0'
...
pod 'SwiftySpot'
```

- macOS
```ruby
platform :osx, '10.13'
...
pod 'SwiftySpot'
```

## Getting started

You can interact with the API through [SPClient](./Sources/SwiftySpot/SPClient.swift) instance.

Client has 3 states:

1) Client without session and authorization. The first launch, for example
2) Client with session and without authorization
3) Client with session and authorization, including state without access token, but with refresh credential

**SPClient manages the session itself: Initialize (client session) or refresh (client session and auth token) if needed**

### Client initialization. State 1

```swift
import SwiftySpot

let device = SPDevice(os: "osName", osVer: "osVersion", osVerNum: 1, cpuAbi: "32", manufacturer: "brand", model: "model", deviceId: "{8 bytes hex string}")

let client = SPClient(device: device)
```

Available API method - Authorize with credentials. Client token will be generated automatically before auth process

### Client initialization. State 2

```swift
import SwiftySpot

let device = SPDevice(os: "osName", osVer: "os version, osVerNum: {os number}, cpuAbi: "32", manufacturer: "brand", model: "model", deviceId: "{8 bytes hex string}")

let clToken = "..."
let clExpires = 3600
let clRefresh = 4800
let clCreateTs = 0

let client = SPClient(device: device, clToken: clToken, clTokenExpires: clExpires, clTokenRefreshAfter: clRefresh, clTokenCreateTsUTC: clCreated)
```

Available API method - Authorize with credentials

### Client initialization. State 3

```swift
import SwiftySpot

let device = SPDevice(os: "osName", osVer: "os version, osVerNum: {os number}, cpuAbi: "32", manufacturer: "brand", model: "model", deviceId: "{8 bytes hex string}")

let clToken = "..."
let clExpires = 3600
let clRefresh = 4800
let clCreateTs = 0

let authToken = "..."
let authExpires = 7200
let authCreateTs = 0
let username = "..."
let storedCredential = Data()

let client = SPClient(device: device, clToken: clToken, clTokenExpires: clExpires, clTokenRefreshAfter: clRefresh, clTokenCreateTsUTC: clCreated, authToken: authToken, authExpiresInS: authExpires, username: username, storedCred: storedCredential, authTokenCreateTsUTC: authCreateTs)
```

All API methods are available

### Managing metadata

Library has built-in metadata manager. 
It caches on RAM all artist, album and track metadata, which are requested by API.
The manager is initialized with empty storage by default during API client init. 
You are able to init the manager with start metadata

**Metadata provider tips**

Metadata from manager can be provided 3 ways:

1. Through manager instance **search** methods: searchTrack(-s), searchArtist(-s), searchAlbum(-s):

```swift
let trackNavUri = "spotify:track:123
let track: SPMetadataTrack? = client.metaStorage.findTrack(uri: trackNavUri)
```

2. Through manager instance properties, which return all available data:

```swift
let allAlbumsMeta: [SPMetadataAlbum] = client.metaStorage.cachedAlbumsMeta
```

3. Through *NotificationCenter* update events

| Notification.Name  | Name key           | Payload type     | Description                      |
|--------------------|--------------------|------------------|----------------------------------|
| SPArtistMetaUpdate | SPArtistMetaUpdate | SPMetadataArtist | API client received artist meta  |
| SPAlbumMetaUpdate  | SPAlbumMetaUpdate  | SPMetadataAlbum  | API client received album meta   |
| SPTrackMetaUpdate  | SPTrackMetaUpdate  | SPMetadataTrack  | API client received track meta   |

Library has notification extension, which provides methods for parsing payload object to API instances:

```swift
//notification: Notification
let artistParseRes: (Bool, SPMetadataArtist?) = notifcation.tryParseArtistMetaUpdate()
let albumParseRes: (Bool, SPMetadataAlbum?) = notifcation.tryParseAlbumMetaUpdate()
let trackParseRes: (Bool, SPMetadataTrack?) = notifcation.tryParseTrackMetaUpdate()
```

The first variable in pair (Bool) is parse status. 'True' value means that the notification has correct name and payload object type

### Managing like/dislike collections

Library has built-in like/dislike collection managers.
It caches on RAM artist and track likes/dislikes, which are processed by API.
The managers are initialized with empty storage by default during API client init.
You are able to init the manager with start collection

Also managers save current collection state, which includes:
- Sync token (Collection update ID)
- Next page token

**Like/Dislike provider tips**

Like/Dislike info from manager can be provided 3 ways:

1. Through manager instance **find** method

```swift
let trackNavUri = "spotify:track:123
let collectionItem: SPCollectionItem? = client.likedTracksStorage.find(uri: trackNavUri)
```

2. Through manager instance property, which return all available data ordered by add timestamp:

```swift
let allAlbumsMeta: [SPCollectionItem] = client.likedAlbumsStorage.orderedItems
```

3. Through *NotificationCenter* update events

| Notification.Name     | Name key              | Payload type     | Description    |
|-----------------------|-----------------------|------------------|----------------|
| SPArtistLikeUpdate    | SPArtistLikeUpdate    | SPCollectionItem | Fires on Like/Dislike op, get collection or update collection by delta API requests |
| SPArtistDislikeUpdate | SPArtistDislikeUpdate | SPCollectionItem | Fires on Like/Dislike op, get collection or update collection by delta API requests |
| SPAlbumLikeUpdate    | SPAlbumLikeUpdate    | SPCollectionItem | Fires on Like/Dislike op, get collection or update collection by delta API requests |
| SPAlbumDislikeUpdate | SPAlbumDislikeUpdate | SPCollectionItem | Fires on Like/Dislike op, get collection or update collection by delta API requests |
| SPTrackLikeUpdate     | SPTrackLikeUpdate     | SPCollectionItem | Fires on Like/Dislike op, get collection or update collection by delta API requests |
| SPTrackDislikeUpdate  | SPTrackDislikeUpdate  | SPCollectionItem | Fires on Like/Dislike op, get collection or update collection by delta API requests |

Library has notification extension, which provides methods for parsing payload object to API instances:

```swift
//notification: Notification
var parseRes: (Bool, SPCollectionItem?) = notifcation.tryParseArtistLikeUpdate()
parseRes = notifcation.tryParseArtistDislikeUpdate()
parseRes = notifcation.tryParseAlbumLikeUpdate()
parseRes = notifcation.tryParseAlbumDislikeUpdate()
parseRes = notifcation.tryParseTrackLikeUpdate()
parseRes = notifcation.tryParseTrackDislikeUpdate()
```

The first variable in pair (Bool) is parse status. 'True' value means that the notification has correct name and payload object type

## Usage examples

### Start landing (Dac request)

Spotify Dac object contains screen design info and payload data with playlists. SPClient extracts playlists from response and push them to completion handler.

```swift
client.getLandingData { result in
    guard let landing = try? result.get() else {return}
    //processing playlists...
}
```

### Get metadata

```swift
let uri = SPNavigateUriUtil.generateTrackUri(id: TestConstants.trackId)
client.getTracksDetails(trackUris: [uri]) { result in
    guard let meta = try? result.get() else {return}
    //processing tracks full info...
}
```

Track metadata also contains codecs download info, which can be used to retrieve direct download link

### Track download info

**Although each spotify track has many codec variants to download (ogg, mp3, mp4, flac and others), only OGG files can be downloaded (Free - 96, 160 kbps, Premium - 320 kbps)**

```swift
let fileIdHex = "..."//From track audio file metadata
client.getDownloadInfo(hexFileId: fileIdHex) { result in
    guard let di = try? result.get() else {return}
    //processing track direct download links...
}
```

## App example

An application for iOS (14.0+, SwiftUI) was created for this API.
It implements a working minimum: Playlists from dac, displaying playlist tracks, the ability to like or dislike them, display the 'my collection' tracks and search tracks
Its source code is publicy available.

<p align="center">
<img src="https://github.com/mIwr/SwiftySpot/blob/master/RepoAssets/feed.jpg?raw=true">          <img src="https://github.com/mIwr/SwiftySpot/blob/master/RepoAssets/playlist.jpg?raw=true">          <img src="https://github.com/mIwr/SwiftySpot/blob/master/RepoAssets/player.jpg?raw=true">          <img src="https://github.com/mIwr/SwiftySpot/blob/master/RepoAssets/playback.jpg?raw=true">          <img src="https://github.com/mIwr/SwiftySpot/blob/master/RepoAssets/fav.jpg?raw=true">          <img src="https://github.com/mIwr/SwiftySpot/blob/master/RepoAssets/search.jpg?raw=true">
</p>