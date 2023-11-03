//
//  CancellationToken.swift
//  SwiftySpot
//
//  Created by Developer on 16.09.2023.
//

import Foundation

public struct CancellationToken {
    fileprivate var cancelRequested: Bool
    /// Returns `true` if cancellation has been requested for this token.
    public var isCancellingRequested: Bool {
        get {
            return cancelRequested
        }
    }
    
    /// Registers the closure that will be called when the token is canceled.
    /// If this token is already cancelled, the closure will be run immediately
    /// and synchronously.
    public var onCancel: () -> Void
}

final public class CancellationTokenSource {
    /// Returns `true` if cancellation has been requested.
    public var isCancelling: Bool {
        get {
            return token.cancelRequested
        }
    }
    /// Creates a new token associated with the source.
    fileprivate var token: CancellationToken
    
    public init(token: CancellationToken) {
        self.token = token
    }
    
    /// Communicates a request for cancellation to the managed tokens.
    public func cancel() {
        token.cancelRequested = true
    }
}
