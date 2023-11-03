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
    public func getLandingData(completion: @escaping (_ result: Result<SPLandingData, SPError>) -> Void) {
        guard let safeClToken = clientToken, let safeAuthToken = authToken else {
            safeAuthReq { safeClToken, safeAuthToken in
                self.getLandingData(completion: completion)
            }
            return
        }
        var clientInfo = Com_Spotify_Dac_Api_V1_Proto_DacRequest.ClientInfo()
        clientInfo.appName = device.os.uppercased() + "_MUSIC_APP"
        clientInfo.version = appVersionCode
        let timezone = TimeZone.current.identifier
        getLandingByApi(userAgent: userAgent, clToken: safeClToken, authToken: safeAuthToken, os: device.os, appVer: appVersionCode, clId: clientId, clientInfo: clientInfo, facetUri: "default", timezone: timezone) { result in
            do {
                let pbResponse = try result.get()
                let playlists = self.extractPlaylistsFromDac(pbResponse)
                completion(.success(SPLandingData(playlists: playlists)))
            } catch {
#if DEBUG
                        print(error)
#endif
                        let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
                        completion(.failure(parsed))
            }
        }
    }
    
    func extractPlaylistsFromDac(_ dac: Com_Spotify_Dac_Api_V1_Proto_DacResponse) -> [SPLandingPlaylist] {
        var playlists: [SPLandingPlaylist] = []
        if (!dac.hasComponent) {
            return playlists
        }
        var uris = Set<String>()
        var discoverWeekly: SPLandingPlaylist?
        var releaseRadar: SPLandingPlaylist?
        var dailyMixes: [SPLandingPlaylist] = []
        if (!dac.component.isA(Com_Spotify_Home_Dac_Component_V1_Proto_HomePageComponent.self)) {
            #if DEBUG
            print("Unknown top-level type URL: " + dac.component.typeURL)
            #endif
            return playlists
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
                    playlists.append(playlist)
                }
            }
        } catch {
#if DEBUG
            print(error)
#endif
        }
        if (!dailyMixes.isEmpty) {
            dailyMixes.sort { a, b in
                return a.name.compare(b.name) == .orderedAscending
            }
            playlists.insert(contentsOf: dailyMixes, at: 0)
        }
        if let safeWeekly = discoverWeekly {
            playlists.insert(safeWeekly, at: 0)
        }
        if let safeReleaseRadar = releaseRadar {
            playlists.insert(safeReleaseRadar, at: 0)
        }
        return playlists
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
