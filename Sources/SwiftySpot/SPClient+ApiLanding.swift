//
//  SPClientApiLandingExt.swift
//  SwiftySpot
//
//  Created by Developer on 18.09.2023.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif
import SwiftProtobuf

extension SPClient {
    
    ///Extract playlists from landing page
    ///- Parameter completion: Extracted landing data response handler
    ///- Returns: API request session task
    public func getLandingData(completion: @escaping (_ result: Result<SPLandingData, SPError>) -> Void) -> URLSessionDataTask? {
        return safeAuthIncludingGuestReq { safeClToken, safeAuthToken in
            var clientInfo = SPDacRequest.ClientInfo()
            clientInfo.appName = self.device.os.uppercased() + "_MUSIC_APP"
            clientInfo.version = self.appVersionCode
            let timezone = TimeZone.current.identifier
            let task = getLandingByApi(userAgent: self.userAgent, clToken: safeClToken, authToken: safeAuthToken, os: self.device.os, appVer: self.appVersionCode, clId: self.clientId, clientInfo: clientInfo, facetUri: "default", timezone: timezone) { result in
                do {
                    let pbResponse = try result.get()
                    let recognized = self.extractPlaylistsFromDac(pbResponse)
                    completion(.success(SPLandingData(userMixes: recognized.userMixes, radioMixes: recognized.radio, playlists: recognized.playlists)))
                } catch {
    #if DEBUG
                    print(error)
    #endif
                    let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
                    completion(.failure(parsed))
                }
            }
            return task
        }
    }
    
    func extractPlaylistsFromDac(_ dac: SPDacResponse) -> (userMixes: [SPLandingPlaylist], radio: [SPLandingPlaylist], playlists: [SPLandingPlaylist]) {
        var userMixes: [SPLandingPlaylist] = []
        var radio: [SPLandingPlaylist] = []
        var playlists: [SPLandingPlaylist] = []
        if (!dac.hasComponent) {
            return (userMixes: userMixes, radio: radio, playlists: playlists)
        }
        var uris = Set<String>()
        var discoverWeekly: SPLandingPlaylist?
        var releaseRadar: SPLandingPlaylist?
        var dailyMixes: [SPLandingPlaylist] = []
        if (!dac.component.isA(SPDacHomePageComponent.self)) {
#if DEBUG
            print("Unknown top-level type URL: " + dac.component.typeURL)
#endif
            return (userMixes: userMixes, radio: radio, playlists: playlists)
        }
        do {
            let page = try SPDacHomePageComponent(unpackingAny: dac.component)
            for component in page.components {
#if DEBUG
                print("Home page component type for parsing: " + component.typeURL)
#endif
                let parsed = self.tryExtractPlaylistInfo(from: component)
                if (parsed.isEmpty) {
                    continue
                }
                for i in 0...parsed.count - 1 {
                    let playlist = parsed[i]
                    if (uris.contains(playlist.uri)) {
                        continue
                    }
                    uris.insert(playlist.uri)
                    let lowercasedName = playlist.name.lowercased()
                    let lowercasedSub = playlist.subtitle.lowercased()
                    if (lowercasedName.starts(with: "daily mix") || lowercasedName.starts(with: "микс дня") || lowercasedSub.starts(with: "daily mix") == true || lowercasedSub.starts(with: "микс дня") == true || playlist.image.contains("dailymix")) {
                        dailyMixes.append(playlist)
                        continue
                    }
                    if (lowercasedName.starts(with: "release radar") || lowercasedName.starts(with: "радар новинок")) {
                        releaseRadar = playlist
                        continue
                    }
                    if (lowercasedName.starts(with: "discover weekly") || lowercasedName.starts(with: "открытия недели")) {
                        discoverWeekly = playlist
                        continue
                    }
                    if (lowercasedName.hasSuffix("radio") || lowercasedName.hasSuffix("радио")) {
                        radio.append(playlist)
                        continue
                    }
                    playlists.append(playlist)
                }
            }
        } catch {
#if DEBUG
            print(error)
#endif
        }
        if let safeReleaseRadar = releaseRadar {
            userMixes.append(safeReleaseRadar)
        }
        if let safeWeekly = discoverWeekly {
            userMixes.append(safeWeekly)
        }
        if (!dailyMixes.isEmpty) {
            dailyMixes.sort { a, b in
                return a.name.compare(b.name) == .orderedAscending
            }
            userMixes.append(contentsOf: dailyMixes)
        }
        
        return (userMixes: userMixes, radio: radio, playlists: playlists)
    }
    
    func tryExtractPlaylistInfo(from component: Google_Protobuf_Any) -> [SPLandingPlaylist] {
        var res: [SPLandingPlaylist] = []
        do {
            if (component.isA(SPDacShortcutsSectionComponent.self)) {
                let section = try SPDacShortcutsSectionComponent(unpackingAny: component)
                for shortcut in section.shortcuts {
                    do {
                        if (shortcut.isA(SPDacPlaylistCardShortcutComponent.self)) {
                            let playlist = try SPDacPlaylistCardShortcutComponent(unpackingAny: shortcut)
                            if (!SPNavigateUriUtil.validatePlaylistUri(playlist.uri)) {
#if DEBUG
                                print("Invalid playlist navigation uri: " + playlist.uri + ". Playlist dropped")
#endif
                                continue
                            }
                            var uri = playlist.uri
                            var title = playlist.title
                            var subtitle = ""
                            var img = playlist.image
                            if (playlist.hasContextMenu &&  playlist.contextMenu.isA(SPDacContextMenu.self)) {
                                do {
                                    let contextMenu = try SPDacContextMenu(unpackingAny: playlist.contextMenu)
                                    if (title.isEmpty) {
                                        var replaceVal = contextMenu.title
                                        if (replaceVal.isEmpty) {
                                            replaceVal = contextMenu.placeholder
                                        }
                                        title = replaceVal
                                    }
                                    if (subtitle.isEmpty) {
                                        subtitle = contextMenu.subtitle
                                    }
                                    if (uri.isEmpty) {
                                        uri = contextMenu.uri
                                    }
                                    if (img.isEmpty) {
                                        img = contextMenu.image
                                    }
                                } catch {
#if DEBUG
                                    print(error)
#endif
                                }
                            }
                            res.append(SPLandingPlaylist(name: title, subtitle: subtitle, uri: uri, image: img))
                        }
                    } catch {
#if DEBUG
                        print(error)
#endif
                    }
                }
            }
            if (component.isA(SPDacShortcutsSectionComponentV2.self)) {
                let section = try SPDacShortcutsSectionComponentV2(unpackingAny: component)
                for shortcut in section.shortcuts {
                    do {
                        if (shortcut.isA(SPDacPlaylistCardShortcutComponent.self)) {
                            let playlist = try SPDacPlaylistCardShortcutComponent(unpackingAny: shortcut)
                            if (!SPNavigateUriUtil.validatePlaylistUri(playlist.uri)) {
#if DEBUG
                                print("Invalid playlist navigation uri: " + playlist.uri + ". Playlist dropped")
#endif
                                continue
                            }
                            var uri = playlist.uri
                            var title = playlist.title
                            var subtitle = ""
                            var img = playlist.image
                            if (playlist.contextMenu.isA(SPDacContextMenu.self)) {
                                do {
                                    let contextMenu = try SPDacContextMenu(unpackingAny: playlist.contextMenu)
                                    if (title.isEmpty) {
                                        var replaceVal = contextMenu.title
                                        if (replaceVal.isEmpty) {
                                            replaceVal = contextMenu.placeholder
                                        }
                                        title = replaceVal
                                    }
                                    if (subtitle.isEmpty) {
                                        subtitle = contextMenu.subtitle
                                    }
                                    if (uri.isEmpty) {
                                        uri = contextMenu.uri
                                    }
                                    if (img.isEmpty) {
                                        img = contextMenu.image
                                    }
                                } catch {
#if DEBUG
                                    print(error)
#endif
                                }
                            }
                            res.append(SPLandingPlaylist(name: title, subtitle: subtitle, uri: uri, image: img))
                        }
                    } catch {
#if DEBUG
                        print(error)
#endif
                    }
                }
            }
            if (component.isA(SPDacSectionComponent.self)) {
                let section = try SPDacSectionComponent(unpackingAny: component)
                for component in section.components {
                    do {
                        if (component.isA(SPDacPlaylistCardLargeComponent.self)) {
                            let playlist = try SPDacPlaylistCardLargeComponent(unpackingAny: component)
                            if (!SPNavigateUriUtil.validatePlaylistUri(playlist.uri)) {
#if DEBUG
                                print("Invalid playlist navigation uri: " + playlist.uri + ". Playlist dropped")
#endif
                                continue
                            }
                            var uri = playlist.uri
                            var title = playlist.title
                            var subtitle = playlist.subtitle
                            var img = playlist.image
                            if (playlist.contextMenu.isA(SPDacContextMenu.self)) {
                                do {
                                    let contextMenu = try SPDacContextMenu(unpackingAny: playlist.contextMenu)
                                    if (title.isEmpty) {
                                        var replaceVal = contextMenu.title
                                        if (replaceVal.isEmpty) {
                                            replaceVal = contextMenu.placeholder
                                        }
                                        title = replaceVal
                                    }
                                    if (subtitle.isEmpty) {
                                        subtitle = contextMenu.subtitle
                                    }
                                    if (uri.isEmpty) {
                                        uri = contextMenu.uri
                                    }
                                    if (img.isEmpty) {
                                        img = contextMenu.image
                                    }
                                } catch {
#if DEBUG
                                    print(error)
#endif
                                }
                            }
                            res.append(SPLandingPlaylist(name: title, subtitle: subtitle, uri: uri, image: img))
                            continue
                        }
                        if (component.isA(SPDacPlaylistCardMediumComponent.self)) {
                            let playlist = try SPDacPlaylistCardMediumComponent(unpackingAny: component)
                            if (!SPNavigateUriUtil.validatePlaylistUri(playlist.uri)) {
#if DEBUG
                                print("Invalid playlist navigation uri: " + playlist.uri + ". Playlist dropped")
#endif
                                continue
                            }
                            var uri = playlist.uri
                            var title = playlist.title
                            var subtitle = playlist.subtitle
                            var img = playlist.image
                            if (playlist.contextMenu.isA(SPDacContextMenu.self)) {
                                do {
                                    let contextMenu = try SPDacContextMenu(unpackingAny: playlist.contextMenu)
                                    if (title.isEmpty) {
                                        var replaceVal = contextMenu.title
                                        if (replaceVal.isEmpty) {
                                            replaceVal = contextMenu.placeholder
                                        }
                                        title = replaceVal
                                    }
                                    if (subtitle.isEmpty) {
                                        subtitle = contextMenu.subtitle
                                    }
                                    if (uri.isEmpty) {
                                        uri = contextMenu.uri
                                    }
                                    if (img.isEmpty) {
                                        img = contextMenu.image
                                    }
                                } catch {
#if DEBUG
                                    print(error)
#endif
                                }
                            }
                            res.append(SPLandingPlaylist(name: title, subtitle: subtitle, uri: uri, image: img))
                            continue
                        }
                        if (component.isA(SPDacPlaylistCardSmallComponent.self)) {
                            let playlist = try SPDacPlaylistCardSmallComponent(unpackingAny: component)
                            if (!SPNavigateUriUtil.validatePlaylistUri(playlist.uri)) {
#if DEBUG
                                print("Invalid playlist navigation uri: " + playlist.uri + ". Playlist dropped")
#endif
                                continue
                            }
                            var uri = playlist.uri
                            var title = playlist.title
                            var subtitle = ""
                            var img = playlist.image
                            if (playlist.contextMenu.isA(SPDacContextMenu.self)) {
                                do {
                                    let contextMenu = try SPDacContextMenu(unpackingAny: playlist.contextMenu)
                                    if (title.isEmpty) {
                                        var replaceVal = contextMenu.title
                                        if (replaceVal.isEmpty) {
                                            replaceVal = contextMenu.placeholder
                                        }
                                        title = replaceVal
                                    }
                                    if (subtitle.isEmpty) {
                                        subtitle = contextMenu.subtitle
                                    }
                                    if (uri.isEmpty) {
                                        uri = contextMenu.uri
                                    }
                                    if (img.isEmpty) {
                                        img = contextMenu.image
                                    }
                                } catch {
#if DEBUG
                                    print(error)
#endif
                                }
                            }
                            res.append(SPLandingPlaylist(name: title, subtitle: subtitle, uri: uri, image: img))
                            continue
                        }
                    } catch {
#if DEBUG
                        print(error)
#endif
                    }
                }
            }
        } catch {
#if DEBUG
            print(error)
#endif
        }
        return res
    }
}
