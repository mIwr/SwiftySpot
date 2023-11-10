//
//  RhythmRiderApp.swift
//  RhythmRider
//
//  Created by Developer on 07.10.2023.
//

import SwiftUI
import SwiftySpot
import AVFoundation

#if DEBUG
let previewProperties = AppProperties()
let previewApiClient = SPClient(device: SPDevice(os: "Android", osVer: "preview", osVerNum: 1, cpuAbi: "32", manufacturer: "preview", model: "preview"))
let previewPlayController = PlaybackController(apiClient: previewApiClient, appProps: previewProperties)
#endif

@main
struct RhythmRiderApp: App {
    
    @StateObject fileprivate var appProps: AppProperties
    @StateObject fileprivate var api: ApiController
    @StateObject fileprivate var playController: PlaybackController
    @State fileprivate var _hasAuth: Bool
    
    fileprivate let _clSession: ClSessionController
    fileprivate let _authSession: AuthSessionController
    
    init() {
        //App Delegate launch analogue
        let props = AppProperties.load()
        let osVer = "7.0"
        let osVerNum: Int32 = 23
        let model = "GT-I9500"
        let manufacturer = "Samsung"
        let device = SPDevice(os: "Android", osVer: osVer, osVerNum: osVerNum, cpuAbi: "32", manufacturer: manufacturer, model: model, deviceId: props.deviceId)
        _appProps = StateObject(wrappedValue: props)
        _clSession = ClSessionController()
        _authSession = AuthSessionController()
        let cl = _clSession.session
        var clToken = ""
        var clTokenExpires: Int32 = 0
        var clTokenRefreshAfter: Int32 = 0
        var clTokenCreateTsUTC: Int64 = 0
        if let safeCl = cl {
            clToken = safeCl.token
            clTokenExpires = safeCl.expiresInS
            clTokenRefreshAfter = safeCl.refreshInS
            clTokenCreateTsUTC = safeCl.createTsUTC
        }
        let auth = _authSession.session
        var authToken = ""
        var authExpiresInS: Int32 = 0
        var username = ""
        var storedCred = Data()
        var authTokenCreateTsUTC: Int64 = 0
        if let safeAuth = auth {
            authToken = safeAuth.token
            authExpiresInS = safeAuth.expiresInS
            username = safeAuth.username
            storedCred = safeAuth.storedCred
            authTokenCreateTsUTC = safeAuth.createTsUTC
        }
        let spClient: SPClient = SPClient(device: device, clToken: clToken, clTokenExpires: clTokenExpires, clTokenRefreshAfter: clTokenRefreshAfter, clTokenCreateTsUTC: clTokenCreateTsUTC, authToken: authToken, authExpiresInS: authExpiresInS, username: username, storedCred: [UInt8].init(storedCred), authTokenCreateTsUTC: authTokenCreateTsUTC)
        _api = StateObject(wrappedValue: ApiController(spClient))
        _hasAuth = spClient.authorized
        let playController = PlaybackController(apiClient: spClient, appProps: props)
        _playController = StateObject(wrappedValue: playController)
    }
    
    var body: some Scene {
        WindowGroup {
            if (_hasAuth) {
                TabBarScreen()
                    .environmentObject(appProps)
                    .environmentObject(api)
                    .environmentObject(playController)
                    .onReceive(NotificationCenter.default.publisher(for: .SPAuthorizationUpdate)) { notification in
                        let parseStatus = notification.tryParseAuthUpdate()
                        if (!parseStatus.0) {
                            return
                        }
                        let session = parseStatus.1
                        if (session == nil && _hasAuth) {
                            //Lost auth
                            _hasAuth = false
                        } else if (session != nil && !_hasAuth) {
                            //Auth
                            _hasAuth = true
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: applicationWillResignActive)
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification), perform: applicationWillEnterForeground)
                    .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification), perform: AVInterruptionChanged)
                    .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification), perform: AVAudioRouteChange)
            } else {
                AuthScreen()
                    .environmentObject(appProps)
                    .environmentObject(api)
                    .environmentObject(playController)
                    .onReceive(NotificationCenter.default.publisher(for: .SPAuthorizationUpdate)) { notification in
                        let parseStatus = notification.tryParseAuthUpdate()
                        if (!parseStatus.0) {
                            return
                        }
                        let session = parseStatus.1
                        if (session == nil && _hasAuth) {
                            //Lost auth
                            _hasAuth = false
                        } else if (session != nil && !_hasAuth) {
                            //Auth
                            _hasAuth = true
                        }
                    }
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willResignActiveNotification), perform: applicationWillResignActive)
                    .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification), perform: applicationWillEnterForeground)
                    .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.interruptionNotification), perform: AVInterruptionChanged)
                    .onReceive(NotificationCenter.default.publisher(for: AVAudioSession.routeChangeNotification), perform: AVAudioRouteChange)
            }
        }
    }
    
    fileprivate func applicationWillResignActive(_ notification: Notification) {
        UIApplication.shared.endEditing()
    }
    
    fileprivate func applicationWillEnterForeground(_ notification: Notification) {
        
    }
    
    fileprivate func AVInterruptionChanged(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
              let interruptionTypeRawValue = userInfo[AVAudioSessionInterruptionTypeKey] as? UInt,
              let interruptionType = AVAudioSession.InterruptionType(rawValue: interruptionTypeRawValue)
        else {return}
        switch interruptionType {
        case .began:
            _ = playController.pause(force: true)
#if DEBUG
            print("AV Session Interruption began")
#endif
            break
        case .ended:
#if DEBUG
            print("AV Session Interruption ended")
#endif
            break
        default:
#if DEBUG
            print("AV Session Interruption unknown state")
#endif
            break
        }
    }
    
    fileprivate func AVAudioRouteChange(_ notification: Notification) {
        guard let userInfo = notification.userInfo,
            let reasonValue = userInfo[AVAudioSessionRouteChangeReasonKey] as? UInt,
            let reason = AVAudioSession.RouteChangeReason(rawValue:reasonValue)
        else {return}
        if (reason == .oldDeviceUnavailable) {
            if let previousRoute =
                userInfo[AVAudioSessionRouteChangePreviousRouteKey] as? AVAudioSessionRouteDescription {
                for output in previousRoute.outputs {
                    if (output.portType == AVAudioSession.Port.headphones || output.portType == AVAudioSession.Port.airPlay || output.portType == AVAudioSession.Port.bluetoothA2DP || output.portType == .bluetoothHFP || output.portType == .bluetoothLE) {
                        //Pause play after external audio route disconnection
                        _ = playController.pause()
                        break
                    }
                }
            }
        }
    }
}
