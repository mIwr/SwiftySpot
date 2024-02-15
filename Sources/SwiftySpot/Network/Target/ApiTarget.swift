//
//  ApiTarget.swift
//  SwiftySpot
//
//  Created by Developer on 06.09.2023.
//

import Foundation

enum ApiTarget {
    //General
    case download(headers: [String: String], fullPath: String)
    //Init
    case clToken(userAgent: String, proto: SPClientTokenRequest)
    case acessPoints(clToken: String)
    //Auth
    case auth(userAgent: String, clToken: String, proto: SPLoginV3Request)
    //SignUp
    case signupValidate(userAgent: String, clToken: String, os: String, appVer: String, validatorKey: String, password: String?)
    case signup(userAgent: String, clToken: String, os: String, appVer: String, clId: String, proto: Com_Spotify_Signup_V2_Proto_CreateAccountRequest)
    //case signupComplete(userAgent: String, clToken: String, os: String, appVer: String, clId: String, sesionId: String)//signup/public/v2/account/complete-creation
    //Authorized
    case profile(userAgent: String, clToken: String, authToken: String, os: String, appVer: String)
    case landing(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, proto: Com_Spotify_Dac_Api_V1_Proto_DacRequest)
    case artist(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, uri: String, fields: [String], imgSize: String)
    case artistUI(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, id: String, locale: String, application: String, video: Bool, podcast: Bool, deviceId: String, timezone: String, timeFormat: String, signal: String)
    case playlist(apHost: String, userAgent: String, clToken: String, authToken: String, id: String, os: String, appVer: String, listItems: String)
    case metadata(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, proto: Com_Spotify_Extendedmetadata_Proto_BatchedEntityRequest)
    case lyrics(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, type: String, id: String, vocalRemove: Bool, syllableSync: Bool, clientLangCode: String)
    case collection(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, proto: Com_Spotify_Collection2_V2_Proto_PageRequest)
    case collectionDelta(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, proto: Com_Spotify_Collection2_V2_Proto_DeltaRequest)
    case collectionWrite(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, proto: Com_Spotify_Collection2_V2_Proto_WriteRequest)
    case searchSuggestion(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, reqId: UUID, query: String, catalogue: String, locale: String, entityTypes: [String], ts: Int64, onDemandSets: Bool, limit: UInt)
    case search(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, reqId: UUID, query: String, catalogue: String, locale: String, entityTypes: [String], ts: Int64, onDemandSets: Bool, limit: UInt, pageToken: String)
    case playIntent (apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, audioFileHexId: String, proto: Spotify_Playplay_Proto_PlayIntentRequest)
    case downloadInfo(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, audioFileHexId: String, productType: Int)
    case playlistFromTrack(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, trackId: String)
}
