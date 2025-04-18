//
//  SPHashCashUtil.swift
//  SwiftySpot
//
//  Created by Developer on 06.09.2023.
//

import Foundation

///Hashcash challenge provider
final class SPHashCashUtil {
    
    fileprivate init() {}
    
    ///Compute hashcash for client token challenge asynchronously
    ///- Parameter prefix:hex string data for calculating hashcash
    ///- Parameter length: hashcash trailing zeros count
    ///- Parameter completion: hashcash solution completion handler
    static func solveClTokenChallengeAsync(prefix: Data, length: Int32, completion: @escaping (String?) -> Void) {
        let prefixStr = String(data: prefix, encoding: .utf8) ?? ""
        let prefixBytes = SPBase16.decode(prefixStr)
        let contextDigest = SPCryptoUtil.sha1(buffer: [])//Empty context for cl token challenge
        let seed = [UInt8].init(contextDigest[12...19])
        solveHashCashAsync(prefix: prefixBytes, length: length, random: seed) { hashcash in
            guard let solved = hashcash else {
                completion(nil)
                return
            }
            let solvedStr = SPBase16.encode(solved)
            completion(solvedStr)
        }
    }
    
    ///Compute hashcash for authorization challenge
    ///- Parameter context: hashcash seed data
    ///- Parameter prefix: bytes data for calculating hashcash
    ///- Parameter length: hashcash trailing zeros count
    ///- Returns Hashcash suffix bytes with defined trailing zeros count
    static func solveAuthChallenge(context: Data, prefix: Data, length: Int32) -> [UInt8]? {
        let contextBytes = [UInt8].init(context)
        let contextDigest = SPCryptoUtil.sha1(buffer: contextBytes)
        let seed = [UInt8].init(contextDigest[12...19])
        let prefixBytes = [UInt8].init(prefix)
        let solved = solveHashCash(prefix: prefixBytes, length: length, random: seed)
        return solved
    }
    
    fileprivate static func solveHashCash(prefix: [UInt8], length: Int32, random: [UInt8], timeoutInS: UInt = 10) -> [UInt8]? {
        let bigEndian = true
        guard var l1: Int64 = SPBinaryUtil.getVal(random, bigEndian: bigEndian) else {
#if DEBUG
            print("Parse Int64 fail from random bytes")
#endif
            return nil
        }
        var l2: Int64 = 0
        var timeout = false
        let interval = TimeInterval(timeoutInS)
        #if DEBUG
        let startTs = Date().timeIntervalSince1970
        #endif
        DispatchQueue.main.async {
            _ = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
    #if DEBUG
                    print("Hashcash solve timeout (expired " + String(timeoutInS) + " secs)")
    #endif
                timeout = true
            }
        }
        while !timeout {
            var buff: [UInt8] = [UInt8].init(prefix)
            let l1Bytes = SPBinaryUtil.getBytes(l1, bigEndian: bigEndian)
            let l2Bytes = SPBinaryUtil.getBytes(l2, bigEndian: bigEndian)
            buff.append(contentsOf: l1Bytes)
            buff.append(contentsOf: l2Bytes)
            let digest = SPCryptoUtil.sha1(buffer: buff)
            guard let buffLong: Int64 = SPBinaryUtil.getVal(digest, offset: 12, bigEndian: bigEndian) else {
#if DEBUG
                print("Parse Int64 fail from SHA1 digest")
#endif
                return nil
            }
            let zeros = buffLong.trailingZeroBitCount
            if (zeros >= length) { //CTZ
                var res = [UInt8].init()
                res.append(contentsOf: l1Bytes)
                res.append(contentsOf: l2Bytes)
#if DEBUG
                print("Hashcash solution: " + String(l1) + "; " + String(l2) + "; digest: " + String(buffLong) + " [trailing zero bits count - " + String(zeros) + "]")
                print(res)
                let delta = Date().timeIntervalSince1970 - startTs
                print("Calculation time in seconds: " + String(delta))
#endif
                return res
            }
            l1 += 1
            l2 += 1
        }
        return nil
    }
    
    fileprivate static func solveHashCashAsync(prefix: [UInt8], length: Int32, random: [UInt8], tasks: UInt = 5, taskIterations: UInt = 400000, timeoutInS: UInt = 9, completion: @escaping ([UInt8]?) -> Void) {
        guard let startL1: Int64 = SPBinaryUtil.getVal(random, bigEndian: true) else {
#if DEBUG
            print("Parse Int64 fail from random bytes")
#endif
            completion(nil)
            return
        }
        var timeoutCancellation = false
        var solution: [UInt8]?
        let interval = TimeInterval(timeoutInS)
        #if DEBUG
        let startTs = Date().timeIntervalSince1970
        #endif
        let dispatchGroup = DispatchGroup()
        
        DispatchQueue.main.async {
            _ = Timer.scheduledTimer(withTimeInterval: interval, repeats: false) { _ in
    #if DEBUG
                    print("Hashcash solve timeout (expired " + String(timeoutInS) + " secs)")
    #endif
                timeoutCancellation = true
            }
        }
        let solver: (UInt, [UInt8], Int32, Int64, Int64) -> Void = { (taskIndex, prefix, length, startL1, startL2) in
            var taskL1 = startL1
            var taskL2 = startL2
            while !timeoutCancellation && solution == nil {
                if (solution != nil) {
                    dispatchGroup.leave()
                    return
                }
                guard let safeHashCash = hashCashIteration(taskIndex: taskIndex, prefix: prefix, l1: &taskL1, l2: &taskL2, length: length) else {
                    continue
                }
                if (solution != nil) {
                    dispatchGroup.leave()
                    return
                }
                solution = safeHashCash
                #if DEBUG
                let delta = Date().timeIntervalSince1970 - startTs
                print("Task index -> " + String(taskIndex) + "|Calculation time in seconds: " + String(delta))
                #endif
            }
            dispatchGroup.leave()
        }
        for i in 0...tasks - 1 {
            let taskStartL1 = startL1 + (Int64(i) * Int64(taskIterations))
            let taskStartL2 = Int64(i) * Int64(taskIterations)
            dispatchGroup.enter()
            DispatchQueue.global().async {
                solver(i, prefix, length, taskStartL1, taskStartL2)
            }
        }
        dispatchGroup.notify(queue: .main) {
            completion(solution)
        }
    }
    
    fileprivate static func hashCashIteration(taskIndex: UInt, prefix: [UInt8], l1: inout Int64, l2: inout Int64, length: Int32) -> [UInt8]? {
        var buff: [UInt8] = [UInt8].init(prefix)
        let l1Bytes = SPBinaryUtil.getBytes(l1, bigEndian: true)
        let l2Bytes = SPBinaryUtil.getBytes(l2, bigEndian: true)
        buff.append(contentsOf: l1Bytes)
        buff.append(contentsOf: l2Bytes)
        let digest = SPCryptoUtil.sha1(buffer: buff)
        guard let buffLong: Int64 = SPBinaryUtil.getVal(digest, offset: 12, bigEndian: true) else {
#if DEBUG
            print("Parse Int64 fail from SHA1 digest")
#endif
            l1 += 1
            l2 += 1
            return nil
        }
        let zeros = buffLong.trailingZeroBitCount
        if (zeros >= length) { //CTZ
            var res: [UInt8] = []
            res.append(contentsOf: l1Bytes)
            res.append(contentsOf: l2Bytes)
#if DEBUG
                print("Task index -> " + String(taskIndex) + "|Hashcash solution: " + String(l1) + "; " + String(l2) + "; digest: " + String(buffLong) + " [trailing zero bits count - " + String(zeros) + "]")
                print(res)
#endif
            return res
        }
        l1 += 1
        l2 += 1
        return nil
    }
}
