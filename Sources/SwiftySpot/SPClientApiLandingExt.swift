//
//  SPClientApiLandingExt.swift
//  SwiftySpot
//
//  Created by Developer on 18.09.2023.
//

import Foundation
import SwiftProtobuf

extension SPClient {
    
    ///Extract playlists from landing page
    ///- Parameter completion: Extracted landing data response handler
    ///- Returns: API request session task
    public func getLandingData(completion: @escaping (_ result: Result<SPLandingData, SPError>) -> Void) -> URLSessionDataTask? {
        return safeAuthReq { safeClToken, safeAuthToken in
            var clientInfo = Com_Spotify_Dac_Api_V1_Proto_DacRequest.ClientInfo()
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
    
    func extractPlaylistsFromDac(_ dac: Com_Spotify_Dac_Api_V1_Proto_DacResponse) -> (userMixes: [SPLandingPlaylist], radio: [SPLandingPlaylist], playlists: [SPLandingPlaylist]) {
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
        if (!dac.component.isA(Com_Spotify_Home_Dac_Component_V1_Proto_HomePageComponent.self)) {
#if DEBUG
            print("Unknown top-level type URL: " + dac.component.typeURL)
#endif
            return (userMixes: userMixes, radio: radio, playlists: playlists)
        }
        do {
            let page = try Com_Spotify_Home_Dac_Component_V1_Proto_HomePageComponent(unpackingAny: dac.component)
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
            if (component.isA(Com_Spotify_Home_Dac_Component_V1_Proto_ShortcutsSectionComponent.self)) {
                let section = try Com_Spotify_Home_Dac_Component_V1_Proto_ShortcutsSectionComponent(unpackingAny: component)
                for shortcut in section.shortcuts {
                    do {
                        if (shortcut.isA(Com_Spotify_Home_Dac_Component_V1_Proto_PlaylistCardShortcutComponent.self)) {
                            let playlist = try Com_Spotify_Home_Dac_Component_V1_Proto_PlaylistCardShortcutComponent(unpackingAny: shortcut)
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
                            if (playlist.hasContextMenu &&  playlist.contextMenu.isA(Com_Spotify_Home_Dac_ContextMenu_V1_Proto_ContextMenu.self)) {
                                do {
                                    let contextMenu = try Com_Spotify_Home_Dac_ContextMenu_V1_Proto_ContextMenu(unpackingAny: playlist.contextMenu)
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
            if (component.isA(Com_Spotify_Home_Dac_Component_V2_Proto_ShortcutsSectionComponentV2.self)) {
                let section = try Com_Spotify_Home_Dac_Component_V2_Proto_ShortcutsSectionComponentV2(unpackingAny: component)
                for shortcut in section.shortcuts {
                    do {
                        if (shortcut.isA(Com_Spotify_Home_Dac_Component_V1_Proto_PlaylistCardShortcutComponent.self)) {
                            let playlist = try Com_Spotify_Home_Dac_Component_V1_Proto_PlaylistCardShortcutComponent(unpackingAny: shortcut)
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
                            if (playlist.contextMenu.isA(Com_Spotify_Home_Dac_ContextMenu_V1_Proto_ContextMenu.self)) {
                                do {
                                    let contextMenu = try Com_Spotify_Home_Dac_ContextMenu_V1_Proto_ContextMenu(unpackingAny: playlist.contextMenu)
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
            if (component.isA(Com_Spotify_Home_Dac_Component_V1_Proto_SectionComponent.self)) {
                let section = try Com_Spotify_Home_Dac_Component_V1_Proto_SectionComponent(unpackingAny: component)
                for component in section.components {
                    do {
                        if (component.isA(Com_Spotify_Home_Dac_Component_V1_Proto_PlaylistCardLargeComponent.self)) {
                            let playlist = try Com_Spotify_Home_Dac_Component_V1_Proto_PlaylistCardLargeComponent(unpackingAny: component)
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
                            if (playlist.contextMenu.isA(Com_Spotify_Home_Dac_ContextMenu_V1_Proto_ContextMenu.self)) {
                                do {
                                    let contextMenu = try Com_Spotify_Home_Dac_ContextMenu_V1_Proto_ContextMenu(unpackingAny: playlist.contextMenu)
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
                        if (component.isA(Com_Spotify_Home_Dac_Component_V1_Proto_PlaylistCardMediumComponent.self)) {
                            let playlist = try Com_Spotify_Home_Dac_Component_V1_Proto_PlaylistCardMediumComponent(unpackingAny: component)
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
                            if (playlist.contextMenu.isA(Com_Spotify_Home_Dac_ContextMenu_V1_Proto_ContextMenu.self)) {
                                do {
                                    let contextMenu = try Com_Spotify_Home_Dac_ContextMenu_V1_Proto_ContextMenu(unpackingAny: playlist.contextMenu)
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
                        if (component.isA(Com_Spotify_Home_Dac_Component_V1_Proto_PlaylistCardSmallComponent.self)) {
                            let playlist = try Com_Spotify_Home_Dac_Component_V1_Proto_PlaylistCardSmallComponent(unpackingAny: component)
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
                            if (playlist.contextMenu.isA(Com_Spotify_Home_Dac_ContextMenu_V1_Proto_ContextMenu.self)) {
                                do {
                                    let contextMenu = try Com_Spotify_Home_Dac_ContextMenu_V1_Proto_ContextMenu(unpackingAny: playlist.contextMenu)
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
