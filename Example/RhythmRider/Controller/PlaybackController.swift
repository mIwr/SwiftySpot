//
//  PlaybackController.swift
//  RhythmRider
//
//  Created by developer on 25.10.2023.
//

import Foundation
import MediaPlayer
import SwiftUI
import SwiftySpot
import YAD
import MobileVLCKit
import SwPSSH
import SwWidevine
import ffmpegkit

//TODO chunk loader (app-level): through bg task download loop and IOStream + VLC???

class PlaybackController: NSObject, ObservableObject {
    
    fileprivate static let _noHash: Int = -1
    
    enum PlayRepeatMode: UInt8 {
        case noRepeat
        case repeatSequence
        case repeatItem
    }
    
    @Published fileprivate(set) var shuffle: Bool
    @Published fileprivate(set) var repeatSeq: Bool
    @Published fileprivate(set) var repeatOne: Bool
    @Published fileprivate(set) var playSeqIndicies: [Int]
    @Published fileprivate(set) var playingTrackUri: String
    
    var playingTrackId: String {
        get {
            let typedObj = SPTypedObj(uri: playingTrackUri, globalID: [])
            return typedObj.id
        }
    }
    
    var repeatMode: PlayRepeatMode {
        get {
            if (repeatOne) {
                return .repeatItem
            }
            if (repeatSeq) {
                return .repeatSequence
            }
            return .noRepeat
        }
    }
    
    ///Linked to playUriIndicies
    fileprivate var _currIndex: Int
    fileprivate var _playInputData: Data
    fileprivate var _playSeqHash: Int
    ///Current playable stock sequence hash value
    var playSeqHash: Int {
        get {
            return _playSeqHash
        }
    }
    fileprivate var _stockPlayItemsSeq: [PlaybackTrack]
    ///Ordered playback seq (including enabled/disabled shuffle option)
    var playItemsSeq: [PlaybackTrack] {
        get {
            var res: [PlaybackTrack] = []
            for index in playSeqIndicies {
                if (index < 0 || index >= _stockPlayItemsSeq.count) {
                    continue
                }
                res.append(_stockPlayItemsSeq[index])
            }
            return res
        }
    }
    
    fileprivate var _vlcPlayer: VLCMediaPlayer
    fileprivate var _playbackPositionInMs: TimeInterval
    fileprivate var _vlcPlayerTimeLastInMs: Int32
    
    fileprivate let _wdvPrc: WDVCDMController?
    fileprivate let _apiClient: SPClient
    fileprivate let _appProps: AppProperties
    
    var playing: Bool {
        get {
            return _vlcPlayer.isPlaying
        }
    }
    
    var playingTrack: PlaybackTrack? {
        get {
            if (playSeqIndicies.isEmpty || _currIndex < 0 || _currIndex >= playSeqIndicies.count) {
                return nil
            }
            let index = playSeqIndicies[_currIndex]
            if (_stockPlayItemsSeq.isEmpty || index < 0 || index >= _stockPlayItemsSeq.count) {
                return nil
            }
            let track = _stockPlayItemsSeq[index]
            return track
        }
    }
    
    var playbackPositionInMs: TimeInterval {
        get {
            return _playbackPositionInMs
        }
    }
    var playbackPositionInS: TimeInterval {
        get {
            return _playbackPositionInMs / 1000
        }
    }
    var playbackPositionFormatted: String {
        get {
            return SPDateUtil.formattedTrackTime(playbackPositionInS)
        }
    }
    var durationInMs: TimeInterval {
        get
        {
            if let safePlaybackTrack = playingTrack {
                return TimeInterval(safePlaybackTrack.trackMeta.durationInMs)
            }
            let timeInMs = TimeInterval(_vlcPlayer.media?.length.intValue ?? 0)
            return timeInMs
        }
    }
    var durationInS: TimeInterval {
        get
        {
            return durationInMs / 1000
        }
    }
    var trackDurationFormatted: String {
        get {
            return SPDateUtil.formattedTrackTime(durationInS)
        }
    }
    
    init(shuffle: Bool = false, repeatSeq: Bool = false, repeatOne: Bool = false, apiClient: SPClient, appProps: AppProperties) {
        self.shuffle = shuffle
        self.repeatSeq = repeatSeq
        self.repeatOne = repeatOne
        self._apiClient = apiClient
        self._appProps = appProps
        playSeqIndicies = []
        playingTrackUri = ""
        _currIndex = 0
        _stockPlayItemsSeq = []
        _playSeqHash = PlaybackController._noHash
        _vlcPlayer = VLCMediaPlayer()
        _vlcPlayerTimeLastInMs = 0
        _playbackPositionInMs = 0
        _playInputData = Data()
        if let safeDevice = WDVDevice.from(b64WdvDeviceData: Constants.WDV_DEVICE_ENC) {
            _wdvPrc = try? WDVCDMController(device: safeDevice)
        } else {
            _wdvPrc = nil
        }
        super.init()
        _vlcPlayer.delegate = self
        setupRemoteTransportControls()
    }
    
    deinit {
        UIApplication.shared.endReceivingRemoteControlEvents()
    }
    
    func setShuffleMode(enabled: Bool) {
        if (shuffle == enabled) {
            return
        }
        shuffle = enabled
        refreshPlaybackSeq()
    }
    
    func setRepeatMode(_ mode: PlayRepeatMode) {
        if (repeatMode == mode) {
            return
        }
        DispatchQueue.main.async {
            switch (mode) {
            case .noRepeat:
                self.repeatSeq = false
                self.repeatOne = false
                break
            case .repeatSequence:
                self.repeatSeq = true
                self.repeatOne = false
                break
            case .repeatItem:
                self.repeatSeq = false
                self.repeatOne = true
                break
            }
        }
    }
    
    func setPlaybackSeq(_ seq: [PlaybackTrack], playIndex: Int = 0, playNow: Bool = true) -> Bool {
        if (seq.isEmpty) {
            return false
        }
        let newHash = PlaybackController.calculatePlaySeqHash(seq.map({ track in
            return track.uri
        }))
        if (newHash != _playSeqHash) {
            _stockPlayItemsSeq = seq
            _playSeqHash = newHash
            refreshPlaybackSeq()
            notifyPlaybackSeqUpdate(playItemsSeq)
        }
        return setPlayingTrackByIndex(playIndex, play: playNow)
    }
    
    func appendPlaybackSeq(_ seq: [PlaybackTrack]) {
        if (seq.isEmpty) {
            return
        }
        _stockPlayItemsSeq.append(contentsOf: seq)
        _playSeqHash = PlaybackController.calculatePlaySeqHash(_stockPlayItemsSeq.map({ track in
            return track.uri
        }))
        refreshPlaybackSeq()
        notifyPlaybackSeqUpdate(playItemsSeq)
    }
    
    static func calculatePlaySeqHash(_ seqUris: [String]) -> Int {
        if (seqUris.isEmpty) {
            return PlaybackController._noHash
        }
        var uris: String = ""
        for uri in seqUris {
            uris += uri
        }
        let hash = uris.hashValue
        return hash
    }
    
    func play() -> Bool {
        if (playing) {
            return true
        }
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
            try AVAudioSession.sharedInstance().setActive(true)
        } catch {
            print(error)
        }
        _vlcPlayer.play()
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playbackPositionInS
        notifyPlayStateUpdate(playing: true)
        return true
    }
    
    func pause(force: Bool = false) -> Bool {
        if (!_vlcPlayer.canPause) {
            return false
        }
        if (!playing && !force) {
            return true
        }
        _vlcPlayer.pause()
        notifyPlayStateUpdate(playing: false)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playbackPositionInS
        return true
    }
    
    func playPreviousTrack() -> Bool {
        if (!_vlcPlayer.isSeekable) {
            return false
        }
        if (playbackPositionInS > 5 || _currIndex - 1 < 0) {
            //The first track or played more than 5 secs
            _ = setPlaybackPosition(0)
            return true
        }
        if (_stockPlayItemsSeq.isEmpty) {
            return false
        }
        var newIndex = _currIndex - 1
        if (newIndex >= _stockPlayItemsSeq.count) {
            newIndex = _stockPlayItemsSeq.count - 1
        }
        if (_appProps.playbackSkipDisliked) {
            //Skip previous disliked tracks
            var skipDislikesIndex = newIndex
            var sucess = false
            for _ in 0..._stockPlayItemsSeq.count - 1 {
                let playItem = playItemsSeq[playSeqIndicies[skipDislikesIndex]]
                if let _ = _apiClient.dislikedTracksStorage.find(uri: playItem.uri) {
                    skipDislikesIndex -= 1
                    if (skipDislikesIndex < 0) {
                        skipDislikesIndex = _stockPlayItemsSeq.count - 1
                    }
                    continue
                }
                sucess = true
                break
            }
            if (sucess) {
                newIndex = skipDislikesIndex
            } else {
                notifyPlayStateUpdate(playing: false)
                clearNowPlaying()
                _vlcPlayer.media = nil
                return false
            }
        }
        //TODO check for availability (restrictions)
        /*
         while _currIndex >= 0 && tracks[_currIndex].available == false {
             _currIndex -= 1
         }
         */
        
        let setStatus = setPlayingTrackByIndex(newIndex, play: false)
        if (!setStatus) {
            clearNowPlaying()
            _vlcPlayer.media = nil
            return false
        }
        initPlay()
        return true
    }
    
    func playNextTrack() -> Bool {
        if (_stockPlayItemsSeq.isEmpty || (_currIndex + 1 >= _stockPlayItemsSeq.count && !repeatSeq)) {
            return false
        }
        var newIndex = (_currIndex + 1) % _stockPlayItemsSeq.count
        if (_appProps.playbackSkipDisliked) {
            //Skip next disliked tracks
            var skipDislikesIndex = newIndex
            var success = false
            for _ in 0..._stockPlayItemsSeq.count - 1 {
                let playItem = playItemsSeq[playSeqIndicies[skipDislikesIndex]]
                if let _ = _apiClient.dislikedTracksStorage.find(uri: playItem.uri) {
                    skipDislikesIndex = (skipDislikesIndex + 1) % _stockPlayItemsSeq.count
                    continue
                }
                success = true
                break
            }
            if (success) {
                newIndex = skipDislikesIndex
            } else {
                notifyPlayStateUpdate(playing: false)
                clearNowPlaying()
                _vlcPlayer.media = nil
                return false
            }
        }
        //TODO check for availability (restrictions)
        /*
         while _currIndex < tracks.count && tracks[_currIndex].available == false {
             _currIndex += 1
         }
         */
        let setStatus = setPlayingTrackByIndex(newIndex, play: false)
        if (!setStatus) {
            clearNowPlaying()
            _vlcPlayer.media = nil
            return false
        }
        initPlay()
        return true
    }
    
    func setPlayingTrackByIndex(_ index: Int, play: Bool = true) -> Bool {
        if (_stockPlayItemsSeq.isEmpty) {
            return false
        }
        if (playing) {
            _vlcPlayer.stop()
            _vlcPlayer.time = VLCTime.init(number: 0)
            _vlcPlayer.media = nil
            notifyPlayStateUpdate(playing: false)
        } else {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true, options: .notifyOthersOnDeactivation)
            } catch {
                print(error)
            }
        }
        //unsubsribePlaybackObservers()
        var playIndex = index
        if (index < 0 || index >= _stockPlayItemsSeq.count) {
            playIndex = 0
        }
        _currIndex = playIndex
        if let safeTrack = playingTrack {
            notifyPlayItemUpdate(safeTrack)
        }
        setupNowPlaying()
        if (play) {
            initPlay()
        }
        return true
    }
    
    func setPlaybackPosition(_ positionInS: TimeInterval) -> Bool {
        if (positionInS < 0 || durationInS < positionInS) {
            return false
        }
        let seekTime: CMTime = CMTimeMakeWithSeconds(positionInS, preferredTimescale: Int32(NSEC_PER_SEC))
        let num = Int32(positionInS * 1000)
        _playbackPositionInMs = positionInS * 1000
        _vlcPlayer.time = VLCTime(int: num)
        _vlcPlayerTimeLastInMs = _vlcPlayer.time.intValue
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = seekTime.seconds
        notifyPlaybackPositionUpdate(positionInS)
        return true
    }
    
    fileprivate func refreshPlaybackSeq() {
        if (_stockPlayItemsSeq.isEmpty) {
            _playSeqHash = PlaybackController._noHash
            _currIndex = 0
            playSeqIndicies = []
            playingTrackUri = ""
            return
        }
        var stockPlayingIndex = 0
        if (_currIndex >= 0 && _currIndex < playSeqIndicies.count) {
            stockPlayingIndex =  playSeqIndicies[_currIndex]
        }
        var newPlayingInex = stockPlayingIndex
        var indicies = [Int].init(repeating: 0, count: _stockPlayItemsSeq.count)
        for i in 0..._stockPlayItemsSeq.count - 1 {
            indicies[i] = i
        }
        if (shuffle) {
            newPlayingInex = 0//The playing item index will be the first in randomized seq if shuffle
            var remains = [Int].init(indicies)
            indicies.removeAll()
            remains.remove(at: stockPlayingIndex)
            indicies.append(stockPlayingIndex)
            while (remains.count > 0) {
                let rndIndex = Int.random(in: 0...remains.count - 1)
                let resIndex = remains.remove(at: rndIndex)
                indicies.append(resIndex)
            }
        }
        playSeqIndicies = indicies
        _currIndex = newPlayingInex
    }
    
    
    fileprivate func initPlay(useWdv: Bool = true) {
        guard let safePlayingTrack = playingTrack else {return}
        var file = safePlayingTrack.trackMeta.findAudioFile(codec: .mp4128)
        if (!useWdv) {
            file = safePlayingTrack.trackMeta.findAudioFile(codec: .oggVorbis160)
            if (_appProps.trafficEconomy || file == nil) {
                file = safePlayingTrack.trackMeta.findAudioFile(codec: .oggVorbis96) ?? file
            }
        }
        _vlcPlayer.stop()
        _vlcPlayer.media = nil
        _vlcPlayerTimeLastInMs = 0
        _playbackPositionInMs = 0
        if (Thread.isMainThread) {
            playingTrackUri = safePlayingTrack.uri
        } else {
            DispatchQueue.main.sync {
                playingTrackUri = safePlayingTrack.uri
            }
        }
        self.setupNowPlaying()
        guard let safeFile = file else {return}
        if (useWdv) {
            initWdvPlay(safePlayingTrack: safePlayingTrack, safeFile: safeFile)
            return
        }
        initPlay(safePlayingTrack: safePlayingTrack, safeFile: safeFile)
    }
    
    fileprivate func initWdvPlay(safePlayingTrack: PlaybackTrack, safeFile: SPMetadataAudioFile) {
        let taskId = UIApplication.shared.beginBackgroundTask(withName: "bgDownloadLoop" + safeFile.hexId) {
            print("Background task expired")
        }
        guard let safeWdv = _wdvPrc else {return}
        guard let safeAppCert = _apiClient.wdvAppCert, let safeWdvServiceCert = try? WDVSignedDrmCertificate(serializedBytes: safeAppCert) else {
            _ = _apiClient.getWdvCert { result in
                guard let safeWdvCert = try? result.get() else {
                    UIApplication.shared.endBackgroundTask(taskId)
                    return
                }
                self.initWdvPlay(safePlayingTrack: safePlayingTrack, safeFile: safeFile)
            }
            return
        }
        _ = _apiClient.findOrRequestWdvSeektable(hexFileId: safeFile.hexId, completion: { wdvPsshResult in
            guard let safeWdvSeektable = try? wdvPsshResult.get(), let safeParsedPssh = PSSHBox.from(b64EncodedBox: safeWdvSeektable.pssh), safeParsedPssh.widevineSystem else {
                UIApplication.shared.endBackgroundTask(taskId)
                return
            }
            let openSessionRes = safeWdv.openNewSession(serviceCertificate: safeWdvServiceCert)
            guard let safeSession = try? openSessionRes.get() else {
                UIApplication.shared.endBackgroundTask(taskId)
                return
            }
            let wdvMsgRes = safeWdv.generateLicChallenge(sessionHexId: safeSession.hexId, pssh: safeParsedPssh)
            guard let safeWdvMsg = try? wdvMsgRes.get() else {
                _ = self._wdvPrc?.closeSession(sessionHexId: safeSession.hexId)
                UIApplication.shared.endBackgroundTask(taskId)
                return
            }
            _ = self._apiClient.requestAudioWdvIntent(challenge: [UInt8].init(safeWdvMsg), completion: { licResponseResult in
                if (safePlayingTrack.uri != self.playingTrackUri) {
                    _ = self._wdvPrc?.closeSession(sessionHexId: safeSession.hexId)
                    UIApplication.shared.endBackgroundTask(taskId)
                    return
                }
                guard let safeLicResponse = try? licResponseResult.get() else {
                    _ = self._wdvPrc?.closeSession(sessionHexId: safeSession.hexId)
                    UIApplication.shared.endBackgroundTask(taskId)
                    return
                }
                let wdvProcessedResult = safeWdv.extractKeyFromLicenseMsg(sessionHexId: safeSession.hexId, licSrvResponse: safeLicResponse)
                _ = self._wdvPrc?.closeSession(sessionHexId: safeSession.hexId)
                guard let wdvProcessed = try? wdvProcessedResult.get(), let safeKey = wdvProcessed.first else {
                    UIApplication.shared.endBackgroundTask(taskId)
                    return
                }
                _ = self._apiClient.findOrRequestDownloadInfo(hexFileId: safeFile.hexId) { diRes in
                    if (safePlayingTrack.uri != self.playingTrackUri) {
                        UIApplication.shared.endBackgroundTask(taskId)
                        return
                    }
                    guard let safeDi = try? diRes.get(), let safeDirectLink = safeDi.directLinks.first else {
                        UIApplication.shared.endBackgroundTask(taskId)
                        return
                    }
                    
                    let decoder: (Data) -> Data = { input in
                        if (safePlayingTrack.uri != self.playingTrackUri) {
                            return Data()
                        }
                        guard let cacheDir = try? FileManager.default.url(for: .cachesDirectory, in: .userDomainMask, appropriateFor: nil, create: false) else {
                            return Data()
                        }
                        let outputPath = cacheDir.appendingPathComponent("out-dec.m4a")
                        let inputPipe = FFmpegKitConfig.registerNewFFmpegPipe() ?? "pipe:0"
                        DispatchQueue.global(qos: .default).async {
                            let safePipeUrl = URL(fileURLWithPath: inputPipe)
                            do {
                                let fileHandle = try FileHandle(forWritingTo: safePipeUrl)
                                try fileHandle.write(contentsOf: input)
                                try? fileHandle.close()
                            } catch {
                                print(error)
                            }
                        }
                        _ = FFmpegKit.execute("-y -decryption_key " + safeKey.hexData + " -i " + inputPipe + " -codec copy -f mp4 " + outputPath.absoluteString)
                        var decoded = Data()
                        do {
                            decoded = try Data(contentsOf: outputPath)
                        } catch {
                            print(error)
                        }
                        try? FileManager.default.removeItem(at: outputPath)
                        FFmpegKitConfig.closeFFmpegPipe(inputPipe)
                        return decoded
                    }
                    _ = self._apiClient.downloadAsOnePiece(cdnLink: safeDirectLink, decryptHandler: decoder) { dRes in
                        if (safePlayingTrack.uri != self.playingTrackUri) {
                            UIApplication.shared.endBackgroundTask(taskId)
                            return
                        }
                        switch(dRes) {
                        case .success(let playableData):
                            self._playInputData = playableData
                            let media = VLCMedia(stream: InputStream(data: self._playInputData))
                            self._vlcPlayer.media = media
                            do {
                                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                                try AVAudioSession.sharedInstance().setActive(true)
                            } catch {
                                print(error)
                            }
                            self._vlcPlayer.play()
                            self.notifyPlayStateUpdate(playing: true)
                            break
                        case .failure(let error):
                            if case .invalidResponseStatusCode(let errCode, _) = error {
                                if (errCode == 404) {
                                    //Not found or restricted on CDN??? (track meta restrictions is empty) -> next song
#if DEBUG
                                    print("Not found file " + safeFile.hexId + " (" + String(describing: safeFile.format) + ")")
#endif
                                    let status = self.playNextTrack()
                                    if (!status) {
                                        _ = self.pause(force: true)
                                    }
                                }
                                break
                            }
                        }
                        UIApplication.shared.endBackgroundTask(taskId)
                    }
                }
            })
        })
    }
    
    fileprivate func initPlay(safePlayingTrack: PlaybackTrack, safeFile: SPMetadataAudioFile) {
        let taskId = UIApplication.shared.beginBackgroundTask(withName: "bgDownloadLoop" + safeFile.hexId) {
            print("Background task expired")
        }
        _apiClient.findOrSendPlayIntent(hexFileId: safeFile.hexId, token: YDConstants.playIntentToken) { intentRes in
            if (safePlayingTrack.uri != self.playingTrackUri) {
                UIApplication.shared.endBackgroundTask(taskId)
                return
            }
            guard let safeIntent = try? intentRes.get() else {
                UIApplication.shared.endBackgroundTask(taskId)
                let status = self.playNextTrack()
                if (!status) {
                    _ = self.pause(force: true)
                }
                return
            }
            self._apiClient.findOrRequestDownloadInfo(hexFileId: safeFile.hexId) { diRes in
                if (safePlayingTrack.uri != self.playingTrackUri) {
                    UIApplication.shared.endBackgroundTask(taskId)
                    return
                }
                guard let safeDi = try? diRes.get() else {
                    UIApplication.shared.endBackgroundTask(taskId)
                    return
                }
                guard let safeDirectLink = safeDi.directLinks.first else {
                    UIApplication.shared.endBackgroundTask(taskId)
                    return
                }
                let decoder: (Data) -> Data = { input in
                    if (safePlayingTrack.uri != self.playingTrackUri) {
                        UIApplication.shared.endBackgroundTask(taskId)
                        return Data()
                    }
                    let bytes = [UInt8].init(input)
                    let decoded = YAD.decrypt(bytes, safeFile.id, [UInt8].init(safeIntent.obfuscatedKey))
                    let resData = Data(decoded)
                    return resData
                }
                //1 - check decode for the first 256 bytes chunk
                self._apiClient.downloadAsChunk(cdnLink: safeDirectLink, offsetInBytes: 0, chunkSizeInBytes: 256, total: nil, decryptHandler: decoder) { chunkRes in
                    if (safePlayingTrack.uri != self.playingTrackUri) {
                        UIApplication.shared.endBackgroundTask(taskId)
                        return
                    }
                    do {
                        let pair = try chunkRes.get()
                        let markerBytes = [UInt8].init(pair.1)
                        if (markerBytes.count < 3) {
                            UIApplication.shared.endBackgroundTask(taskId)
                            return
                        }
                        if (markerBytes[0] != 0x4f || markerBytes[1] != 0x67 || markerBytes[2] != 0x67) {
                            //fail decrypt -> force ogg96
                            UIApplication.shared.endBackgroundTask(taskId)
                            if safeFile.format != .oggVorbis96, let safeRerserveFile = safePlayingTrack.trackMeta.findAudioFile(codec: .oggVorbis96) {
                                self.initPlay(safePlayingTrack: safePlayingTrack, safeFile: safeRerserveFile)
                            }
                            #if DEBUG
                            print("Fail decode " + safeFile.hexId + " (" + String(describing: safeFile.format) + ")")
                            #endif
                            return
                        }
                        //2 - download all data
                        self._apiClient.downloadAsOnePiece(cdnLink: safeDirectLink, decryptHandler: decoder) { dRes in
                            if (safePlayingTrack.uri != self.playingTrackUri) {
                                UIApplication.shared.endBackgroundTask(taskId)
                                return
                            }
                            switch(dRes) {
                            case .success(let playableData):
                                self._playInputData = playableData
                                let media = VLCMedia(stream: InputStream(data: self._playInputData))
                                self._vlcPlayer.media = media
                                do {
                                    try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                                    try AVAudioSession.sharedInstance().setActive(true)
                                } catch {
                                    print(error)
                                }
                                self._vlcPlayer.play()
                                self.notifyPlayStateUpdate(playing: true)
                                break
                            case .failure(let error):
                                if case .invalidResponseStatusCode(let errCode, _) = error {
                                    if (errCode == 404) {
                                        //Not found or restricted on CDN??? (track meta restrictions is empty) -> next song
#if DEBUG
                                        print("Not found file " + safeFile.hexId + " (" + String(describing: safeFile.format) + ")")
#endif
                                        let status = self.playNextTrack()
                                        if (!status) {
                                            _ = self.pause(force: true)
                                        }
                                    }
                                    break
                                }
                            }
                            UIApplication.shared.endBackgroundTask(taskId)
                        }
                    } catch {
                        let parsed = error as? SPError ?? SPError.general(errCode: SPError.GeneralErrCode, data: ["description": error])
                        if case .invalidResponseStatusCode(let errCode, _) = parsed {
                            if (errCode == 404) {
                                //Not found or restricted on CDN -> next song
#if DEBUG
                                print("Not found file " + safeFile.hexId + " (" + String(describing: safeFile.format) + ")")
#endif
                                let status = self.playNextTrack()
                                if (!status) {
                                    _ = self.pause(force: true)
                                }
                            }
                        }
                    }
                }
                /*self._apiClient.downloadAsChunk(cdnLink: safeDirectLink, offsetInBytes: 0, total: nil, decryptHandler: { data in
                    if (safePlayingTrack.uri != self.playingTrackUri) {
                        return Data()
                    }
                    let bytes = [UInt8].init(data)
                    let decoded = YAD.decrypt(bytes, safeFile.id, safeIntent.obfuscatedKey)
                    let resData = Data(decoded)
                    return resData
                }) { downloadProgressRes in
                    if (safePlayingTrack.uri != self.playingTrackUri) {
                        UIApplication.shared.endBackgroundTask(taskId)
                        return
                    }
                    guard let pair = try? downloadProgressRes.get() else {
                        UIApplication.shared.endBackgroundTask(taskId)
                        return
                    }
                    self._playInputData = pair.1
                    if (UIApplication.shared.backgroundTimeRemaining < 10) {
                        self._pendingPlayTrack = PendingPlayTrack(track: safePlayingTrack, intent: safeIntent, di: safeDi, progress: pair.0, playableData: pair.1)
                        UIApplication.shared.endBackgroundTask(taskId)
                        return
                    }
                    self.bgDownloadLoop(trackUri: safePlayingTrack.uri, dataId: safeFile.id, keyBasis: safeIntent.obfuscatedKey, progress: pair.0) { loopResult in
                        if (safePlayingTrack.uri != self.playingTrackUri) {
                            self._pendingPlayTrack = nil
                            UIApplication.shared.endBackgroundTask(taskId)
                            return
                        }
                        let progress = loopResult.0
                        let data = loopResult.1
                        self._playInputData.append(data)
                        if (UIApplication.shared.backgroundTimeRemaining < 10) {
                            self._pendingPlayTrack = PendingPlayTrack(track: safePlayingTrack, intent: safeIntent, di: safeDi, progress: pair.0, playableData: self._playInputData)
                            UIApplication.shared.endBackgroundTask(taskId)
                            return
                        }
                        if (progress.remains == 0) {
                            //Downloaded
                            self._pendingPlayTrack = nil
                            let media = VLCMedia(stream: InputStream(data: self._playInputData))
                            self._vlcPlayer.media = media
                            self._vlcPlayer.play()
                            self.notifyPlayStateUpdate(playing: true)
                            UIApplication.shared.endBackgroundTask(taskId)
                        }
                    }
                }*/
            }
        }
    }
    
    /*fileprivate func bgDownloadLoop(trackUri: String, dataId: [UInt8], keyBasis: [UInt8], progress: SPDownloadProgress, chunkDownloadCompletion: @escaping (_ result: (SPDownloadProgress, Data)) -> Void) {
        if (trackUri != playingTrackUri) {
            chunkDownloadCompletion((progress, Data()))
            return
        }
        _apiClient.downloadAsChunk(cdnLink: progress.cdnLink, offsetInBytes: progress.position + 1, chunkSizeInBytes: progress.chunkSize, total: progress.total, decryptHandler: { data in
            if (trackUri != self.playingTrackUri) {
                return Data()
            }
            let bytes = [UInt8].init(data)
            let decoded = YAD.decrypt(bytes, dataId, keyBasis)
            let resData = Data(decoded)
            return resData
        }) { result in
            if (trackUri != self.playingTrackUri) {
                chunkDownloadCompletion((progress, Data()))
                return
            }
            do {
                let chunkDownloadRes = try result.get()
                let updProgress = chunkDownloadRes.0
                let data = chunkDownloadRes.1
                chunkDownloadCompletion((updProgress, data))
                print("Bg time remaining", UIApplication.shared.backgroundTimeRemaining)
                if (updProgress.remains == 0 || UIApplication.shared.backgroundTimeRemaining < 8) {
                    return
                }
                self.bgDownloadLoop(trackUri: trackUri, dataId: dataId, keyBasis: keyBasis, progress: updProgress, chunkDownloadCompletion: chunkDownloadCompletion)
            } catch {
                self.bgDownloadLoop(trackUri: trackUri, dataId: dataId, keyBasis: keyBasis, progress: progress, chunkDownloadCompletion: chunkDownloadCompletion)
            }
        }
    }*/
}

extension PlaybackController {
    //MediaPlayer handlers ext
    fileprivate func setupRemoteTransportControls() {
        UIApplication.shared.beginReceivingRemoteControlEvents()
        let commandCenter = MPRemoteCommandCenter.shared()
        commandCenter.skipBackwardCommand.isEnabled = false
        commandCenter.skipForwardCommand.isEnabled = false
        commandCenter.seekForwardCommand.isEnabled = false
        commandCenter.seekBackwardCommand.isEnabled = false
        commandCenter.changePlaybackPositionCommand.isEnabled = true
        commandCenter.changePlaybackPositionCommand.addTarget(self, action: #selector(changePlaybackPosition))
        commandCenter.playCommand.isEnabled = true
        commandCenter.playCommand.addTarget(self, action: #selector(playCmd))
        commandCenter.pauseCommand.isEnabled = true
        commandCenter.pauseCommand.addTarget(self, action: #selector(pauseCmd))
        commandCenter.nextTrackCommand.isEnabled = true
        commandCenter.nextTrackCommand.addTarget(self, action: #selector(nextTrackCmd))
        commandCenter.previousTrackCommand.isEnabled = true
        commandCenter.previousTrackCommand.addTarget(self, action: #selector(previousTrackCmd))
    }
    
    fileprivate func setupNowPlaying() {
        guard let safePlayingTrack = playingTrack else {return}
        var nowPlayingInfo = [String : Any]()
        if let safeUiImg = UIImage(resource: R.image.cover) {
            nowPlayingInfo[MPMediaItemPropertyArtwork] = MPMediaItemArtwork(boundsSize: CGSize(width: 256, height: 256), requestHandler: { size in
                return safeUiImg
            })
        }
        nowPlayingInfo[MPMediaItemPropertyTitle] = safePlayingTrack.trackMeta.name
        nowPlayingInfo[MPMediaItemPropertyArtist] = safePlayingTrack.trackMeta.artists.map({ artist in
            return artist.name
        }).joined(separator: ",")
        nowPlayingInfo[MPMediaItemPropertyPlaybackDuration] = safePlayingTrack.trackMeta.durationInMs / 1000
        nowPlayingInfo[MPNowPlayingInfoPropertyElapsedPlaybackTime] = 0.0
        MPNowPlayingInfoCenter.default().nowPlayingInfo = nowPlayingInfo
    }
    
    fileprivate func clearNowPlaying() {
        MPNowPlayingInfoCenter.default().nowPlayingInfo = [:]
    }
    
    @objc fileprivate func previousTrackCmd(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return playPreviousTrack() ? .success : .commandFailed
    }
    
    @objc fileprivate func nextTrackCmd(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        return playNextTrack() ? .success : .commandFailed
    }
    
    @objc fileprivate func changePlaybackPosition(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        if let safeEvent = event as? MPChangePlaybackPositionCommandEvent {
            let seconds = safeEvent.positionTime
            _ = setPlaybackPosition(seconds)
            return .success
        }
        return .commandFailed
    }
    
    @objc fileprivate func pauseCmd(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        let pauseRes = pause()
        return pauseRes ? .success : .noActionableNowPlayingItem
    }
    
    @objc fileprivate func playCmd(event: MPRemoteCommandEvent) -> MPRemoteCommandHandlerStatus {
        let playRes = play()
        return playRes ? .success : .noSuchContent
    }
}

extension Notification.Name {
    ///Playing state update event. Payload contains in notification.object with type 'Bool'
    public static let SPPlayStateUpdate = Notification.Name(PlaybackController._playStateUpdate)
    ///Playback collection update event (shuffle/deshuffle, new collection, append subcollection). Payload contains in notification.object with type 'PlaybackTrack array]'
    public static let SPPlaybackSeqUpdate = Notification.Name(PlaybackController._playbackPositionUpdate)
    ///Playing item update event. Payload contains in notification.object with type 'PlaybackTrack'
    public static let SPPlayItemUpdate = Notification.Name(PlaybackController._playItemUpdate)
    ///Playback position update event. Payload contains in notification.object with type 'TimeInterval'
    public static let SPPlaybackPositionUpdate = Notification.Name(PlaybackController._playbackPositionUpdate)
}

extension Notification {
    func tryParsePlayStateUpdate() -> (Bool, Bool?) {
        if let playing = object as? Bool, name == Notification.Name.SPPlayStateUpdate {
            return (true, playing)
        }
        return (false, nil)
    }
    
    func tryParsePlaybackSeqUpdate() -> (Bool, [PlaybackTrack]?) {
        if let item = object as? [PlaybackTrack], name == Notification.Name.SPPlaybackSeqUpdate {
            return (true, item)
        }
        return (false, nil)
    }
    
    func tryParsePlayItemUpdate() -> (Bool, PlaybackTrack?) {
        if let item = object as? PlaybackTrack, name == Notification.Name.SPPlayItemUpdate {
            return (true, item)
        }
        return (false, nil)
    }
    
    func tryParsePlaybackPositionUpdate() -> (Bool, TimeInterval?) {
        if let item = object as? TimeInterval, name == Notification.Name.SPPlaybackPositionUpdate {
            return (true, item)
        }
        return (false, nil)
    }
}

extension PlaybackController {
    fileprivate static let _playStateUpdate = "SPPlayStateUpdate"
    fileprivate static let _playItemUpdate = "SPPlaybackItemUpdate"
    fileprivate static let _playbackSeqUpdate = "SPPlaybackSeqUpdate"
    fileprivate static let _playbackPositionUpdate = "SPPlaybackPositionUpdate"
    
    fileprivate func notifyPlayStateUpdate(playing: Bool) {
        let notification = Notification(name: .SPPlayStateUpdate, object: playing)
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
    
    func notifyPlaybackSeqUpdate(_ seq: [PlaybackTrack]) {
        let notification = Notification.init(name: .SPPlaybackSeqUpdate, object: seq)
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
    
    fileprivate func notifyPlayItemUpdate(_ item: PlaybackTrack) {
        let notification = Notification(name: .SPPlayItemUpdate, object: item)
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
    
    func notifyPlaybackPositionUpdate(_ positionInS: TimeInterval) {
        let notification = Notification.init(name: .SPPlaybackPositionUpdate, object: positionInS)
        DispatchQueue.main.async {
            NotificationCenter.default.post(notification)
        }
    }
}

extension PlaybackController: VLCMediaPlayerDelegate {
    
    func mediaPlayerStateChanged(_ aNotification: Notification) {
        switch(_vlcPlayer.state) {
        case .playing:
            notifyPlayStateUpdate(playing: true)
            return
        case .paused:
            notifyPlayStateUpdate(playing: false)
            return
        case .stopped:
            notifyPlayStateUpdate(playing: false)
            return
        case .ended:
            if (repeatOne) {
                _ = setPlaybackPosition(TimeInterval(0.0))
                let media = VLCMedia(stream: InputStream(data: _playInputData))
                _vlcPlayer.media = media
                _ = play()
                return
            }
            notifyPlayStateUpdate(playing: false)
            _ = playNextTrack()
            return
        default:
            return
        }
    }
    
    func mediaPlayerTimeChanged(_ aNotification: Notification) {
        if (!_vlcPlayer.isPlaying) {
            return
        }
        let newVlcTime = _vlcPlayer.time.intValue
        let delta = abs(newVlcTime - _vlcPlayerTimeLastInMs)
        _vlcPlayerTimeLastInMs = newVlcTime
        if (delta > 2000) {
            return
        }
        _playbackPositionInMs += TimeInterval(delta)
        MPNowPlayingInfoCenter.default().nowPlayingInfo?[MPNowPlayingInfoPropertyElapsedPlaybackTime] = playbackPositionInS
        notifyPlaybackPositionUpdate(playbackPositionInS)
    }
}
