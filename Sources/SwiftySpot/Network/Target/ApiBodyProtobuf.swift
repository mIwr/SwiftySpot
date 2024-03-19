//
//  ApiBodyProtobuf.swift
//  SwiftySpot
//
//  Created by Developer on 08.09.2023.
//

import Foundation

extension ApiTarget {
    
    var protobuf: Data? {
        var data: Data?
        switch self {
        case .download: return nil
        case .clToken(_, let proto):
            do {
                data = try proto.serializedData()
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
            return data
        case.acessPoints: return nil
        case .auth(_, _, let proto):
            do {
                data = try proto.serializedData()
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
            return data
        case .signupValidate: return nil
        case .signup(_, _, _, _, _, let proto):
            do {
                data = try proto.serializedData()
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
            return data
        case .profile: return nil
        case .landing(_, _, _, _, _, _, let proto):
            do {
                data = try proto.serializedData()
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
            return data
        case .artist: return nil
        case .artistUI: return nil
        case .playlist: return nil
        case .metadata(_, _, _, _, _, _, let proto):
            do {
                data = try proto.serializedData()
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
            return data
        case .lyrics: return nil
        case .collection(_, _, _, _, _, let proto):
            do {
                data = try proto.serializedData()
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
            return data
        case .collectionDelta(_, _, _, _, _, _, let proto):
            do {
                data = try proto.serializedData()
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
            return data
        case .collectionWrite(_, _, _, _, _, _, let proto):
            do {
                data = try proto.serializedData()
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
            return data
        case .searchSuggestion: return nil
        case .search: return nil
        case .playIntent(_, _, _, _, _, _, _, let proto):
            do {
                data = try proto.serializedData()
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
            return data
        case .downloadInfo: return nil
        case .playlistFromSeed: return nil
        }
    }
}
