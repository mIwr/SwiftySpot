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
    case wdvSeektable(fileHexId: String)
    //Init
    case clToken(userAgent: String, proto: SPClientTokenRequest)
    case acessPoints(clToken: String?)
    case wdvCert
    //Auth
    case auth(userAgent: String, clToken: String, proto: SPLoginV3Request)
    //SignUp
    case signupValidate(userAgent: String, clToken: String, os: String, appVer: String, validatorKey: String, password: String?)
    case signup(userAgent: String, clToken: String, os: String, appVer: String, clId: String, proto: SPCreateAccountRequest)
    //case signupComplete(userAgent: String, clToken: String, os: String, appVer: String, clId: String, sesionId: String)//signup/public/v2/account/complete-creation
    //Authorized
    case profile(userAgent: String, clToken: String, authToken: String, os: String, appVer: String)
    case landing(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, proto: SPDacRequest)
    case artist(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, uri: String, fields: [String], imgSize: String)
    case artistUI(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, id: String, locale: String, application: String, video: Bool, podcast: Bool, deviceId: String, timezone: String, timeFormat: String, signal: String)
    case playlist(apHost: String, userAgent: String, clToken: String, authToken: String, id: String, os: String, appVer: String, listItems: String)
    case metadata(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, proto: SPMetaBatchedEntityRequest)
    case lyrics(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, type: String, id: String, vocalRemove: Bool, syllableSync: Bool, clientLangCode: String)
    case collection(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, proto: SPCollectionPageRequest)
    case collectionDelta(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, proto: SPCollectionDeltaRequest)
    case collectionWrite(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, proto: SPCollectionWriteRequest)
    case searchSuggestion(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, reqId: UUID, query: String, catalogue: String, locale: String, entityTypes: [String], ts: Int64, onDemandSets: Bool, limit: UInt)
    case search(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, reqId: UUID, query: String, catalogue: String, locale: String, entityTypes: [String], ts: Int64, onDemandSets: Bool, limit: UInt, pageToken: String)
    case playIntent (apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, audioFileHexId: String, proto: SPPlayIntentRequest)
    case wdvIntentUrl(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, fileType: String)
    case wdvIntent(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, fileType: String, challenge: [UInt8])
    case downloadInfo(apHost: String, userAgent: String, clToken: String, authToken: String, os: String, appVer: String, audioFileHexId: String, productType: Int)
    case playlistFromSeed(userAgent: String, clToken: String, authToken: String, os: String, appVer: String, clId: String, uri: String)
}
