//
//  ApiBodyProtobuf.swift
//  SwiftySpot
//
//  Created by Developer on 08.09.2023.
//

import Foundation

extension ApiTarget {
    
    var reqBody: Data? {
        var data: Data?
        switch self {
        case .download: return nil
        case .wdvSeektable: return nil
        case .clToken(_, let proto):
            do {
                data = try proto.serializedData()
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
            return data
        case .webClToken(_, let clId, let os, let appVer, let deviceId):
            let dict: [String: Any] = [
                "client_data": [
                    "client_version": appVer,
                    "client_id": clId,
                    "js_sdk_data": [
                        "device_brand":"unknown",
                        "device_model":"unknown",
                        "os": os,
                        "os_version":"unknown",
                        "device_id": deviceId,
                        "device_type":"computer"
                    ]
                ]
            ]
            do {
                data = try JSONSerialization.data(withJSONObject: dict)
            } catch {
                #if DEBUG
                print(error)
                #endif
            }
            return data
        case.acessPoints: return nil
        case .wdvCert: return nil
        case .guestAuth: return nil
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
        case .webProfile: return nil
        case .webProfileCustom: return nil
        case .webProfileCustom2: return nil
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
        case .webSearch: return nil
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
        case .wdvIntentUrl: return nil
        case .wdvIntent(_, _, _, _, _, _, _, let challenge):
            //Protobuf challenge raw bytes
            data = Data(challenge)
            return data
        case .downloadInfo: return nil
        case .playlistFromSeed: return nil
        }
    }
}
