//
//  SPClientApiSearch.swift
//  SwiftySpot
//
//  Created by Developer on 25.09.2023.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif

extension SPClient {
    
    ///Search suggestions
    ///- Parameter query: Search query
    ///- Parameter limit: Search results page limit
    ///- Parameter onDemandSets: TODO
    ///- Parameter completion: Search result response handler
    ///- Returns: API request session task
    public func searchSuggestion(query: String, entityTypes: [SPSearchEntityType], limit: UInt, onDemandSets: Bool = true, completion: @escaping (_ result: Result<SPSearchSuggestionResult, SPError>) -> Void) -> URLSessionDataTask? {
        return safeAuthProfileReq { safeClToken, safeAuthToken, safeProfile in
            let uuid = UUID()
            let ts = Int64(Date().timeIntervalSince1970)
            var types: [String] = []
            for type in entityTypes {
                types.append(type.apiKey)
            }
            let task = searchSuggestionByApi(userAgent: self.userAgent, clToken: safeClToken, authToken: safeAuthToken, os: self.device.os, appVer: self.appVersionCode, clId: self.clientId, reqId: uuid, query: query, catalogue: safeProfile.product, locale: Locale.current.identifier, entityTypes: types, ts: ts, onDemandSets: onDemandSets, limit: limit) { response in
                do {
                    let autocompleteView = try response.get()
                    let parsed = SPSearchSuggestionResult.from(protobuf: autocompleteView)
                    completion(.success(parsed))
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
    
    ///Search data
    ///- Parameter query: Search query
    ///- Parameter entityTypes: Allowed for search entity types
    ///- Parameter limit: Search results page limit
    ///- Parameter pageToken: Pagination token. If not stated, the first page will be requested
    ///- Parameter onDemandSets: TODO
    ///- Parameter completion: Search result response handler
    ///- Returns: API request session task
    public func search(query: String, entityTypes: [SPSearchEntityType], limit: UInt, pageToken: String?, onDemandSets: Bool = true, completion: @escaping (_ result: Result<SPSearchResult, SPError>) -> Void) -> URLSessionDataTask? {
        return safeAuthProfileReq { safeClToken, safeAuthToken, safeProfile in
            let uuid = UUID()
            let ts = Int64(Date().timeIntervalSince1970)
            var types: [String] = []
            for type in entityTypes {
                types.append(type.apiKey)
            }
            let task = searchByApi(userAgent: self.userAgent, clToken: safeClToken, authToken: safeAuthToken, os: self.device.os, appVer: self.appVersionCode, clId: self.clientId, reqId: uuid, query: query, catalogue: safeProfile.product, locale: Locale.current.identifier, entityTypes: types, ts: ts, onDemandSets: onDemandSets, limit: limit, pageToken: pageToken ?? "") { response in
                do {
                    let mainView = try response.get()
                    let parsed = SPSearchResult.from(protobuf: mainView)
                    completion(.success(parsed))
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
    
    ///Search data through Web API and convert result as mobile entities array
    ///- Parameter query: Search query
    ///- Parameter entityTypes: Allowed for search entity types
    ///- Parameter limit: Search results page limit
    ///- Parameter offset: Search results offset
    ///- Parameter completion: Search result response handler
    ///- Returns: API request session task
    public func webSearchWithConversion(query: String, entityTypes: [SPSearchEntityType], limit: UInt, offset: UInt?, completion: @escaping (_ result: Result<[SPSearchEntity], SPError>) -> Void) -> URLSessionDataTask? {
        return safeAuthIncludingGuestReq { safeClToken, safeAuthToken in
            return self.webSearch(query: query, entityTypes: entityTypes, limit: limit, offset: offset) { result in
                do {
                    let searchRes = try result.get()
                    completion(.success(searchRes.asSearchResultEntities()))
                } catch {
     #if DEBUG
                    print(error)
     #endif
                    let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
                    completion(.failure(parsed))
                }
            }
        }
    }
    
    ///Search data through Web API
    ///- Parameter query: Search query
    ///- Parameter entityTypes: Allowed for search entity types
    ///- Parameter limit: Search results page limit
    ///- Parameter offset: Search results offset
    ///- Parameter completion: Search result response handler
    ///- Returns: API request session task
    public func webSearch(query: String, entityTypes: [SPSearchEntityType], limit: UInt, offset: UInt?, completion: @escaping (_ result: Result<SPWebSearchResult, SPError>) -> Void) -> URLSessionDataTask? {
        //Not work with mobile app access tokens anymore (RBAC: access denied) -> Use web access token only
        return safeGuestWebAuthReq { safeClToken, safeAuthToken in
            var opPair = SPSearchEntityType.searchDesktopPersistedQuery
            if (entityTypes.count == 1) {
                opPair = entityTypes[0].webOpType
            }
            return webSearchByApi(userAgent: self.webUserAgent, clToken: safeClToken, authToken: safeAuthToken, os: SPConstants.webPlatform, appVer: self.webAppVersionCode, query: query, opName: opPair.opName, opQueryHashHexString: opPair.persistedQueryHashHex, limit: limit, offset: offset ?? 0, completion: completion)
        }
    }
}
