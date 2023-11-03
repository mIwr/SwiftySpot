//
//  Process.swift
//  RhythmRider
//
//  Created by developer on 26.10.2023.
//

#if DEBUG
import Foundation

extension ProcessInfo {
    fileprivate static let _xcodePreviewAgentProcName = "XCPreviewAgent"
    fileprivate static let _runningPreviewEnvVarKey = "XCODE_RUNNING_FOR_PREVIEWS"
    
    var previewMode: Bool {
        get {
            let procName = processName
            let previewEnvVal = environment[ProcessInfo._runningPreviewEnvVarKey]
            return procName == ProcessInfo._xcodePreviewAgentProcName || previewEnvVal == "1"
        }
    }
}
#endif
