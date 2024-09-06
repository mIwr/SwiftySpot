// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: DownloadInfo.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

import Foundation
import SwiftProtobuf

// If the compiler emits an error on this type, it is because this file
// was generated by a version of the `protoc` Swift plug-in that is
// incompatible with the version of SwiftProtobuf to which you are linking.
// Please ensure that you are building against the same version of the API
// that was used to generate this file.
fileprivate struct _GeneratedWithProtocGenSwiftVersion: SwiftProtobuf.ProtobufAPIVersionCheck {
  struct _2: SwiftProtobuf.ProtobufAPIVersion_2 {}
  typealias Version = _2
}

///PlayPlayLicenseRequest
struct SPPlayIntentRequest {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var version: Int32 = 0

  var token: Data = Data()

  var cacheID: Data {
    get {return _cacheID ?? Data()}
    set {_cacheID = newValue}
  }
  /// Returns true if `cacheID` has been explicitly set.
  var hasCacheID: Bool {return self._cacheID != nil}
  /// Clears the value of `cacheID`. Subsequent reads from it will return its default value.
  mutating func clearCacheID() {self._cacheID = nil}

  var interactivity: SPInteractivity = .unknownInteractivity

  var contentType: SPContentType = .unknownContentType

  var timestamp: Int64 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _cacheID: Data? = nil
}

#if swift(>=5.5) && canImport(_Concurrency)
extension SPPlayIntentRequest: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "spotify.playplay.proto"

extension SPPlayIntentRequest: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".PlayIntentRequest"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "version"),
    2: .same(proto: "token"),
    3: .standard(proto: "cache_id"),
    4: .same(proto: "interactivity"),
    5: .standard(proto: "content_type"),
    6: .same(proto: "timestamp"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularInt32Field(value: &self.version) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.token) }()
      case 3: try { try decoder.decodeSingularBytesField(value: &self._cacheID) }()
      case 4: try { try decoder.decodeSingularEnumField(value: &self.interactivity) }()
      case 5: try { try decoder.decodeSingularEnumField(value: &self.contentType) }()
      case 6: try { try decoder.decodeSingularInt64Field(value: &self.timestamp) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if self.version != 0 {
      try visitor.visitSingularInt32Field(value: self.version, fieldNumber: 1)
    }
    if !self.token.isEmpty {
      try visitor.visitSingularBytesField(value: self.token, fieldNumber: 2)
    }
    try { if let v = self._cacheID {
      try visitor.visitSingularBytesField(value: v, fieldNumber: 3)
    } }()
    if self.interactivity != .unknownInteractivity {
      try visitor.visitSingularEnumField(value: self.interactivity, fieldNumber: 4)
    }
    if self.contentType != .unknownContentType {
      try visitor.visitSingularEnumField(value: self.contentType, fieldNumber: 5)
    }
    if self.timestamp != 0 {
      try visitor.visitSingularInt64Field(value: self.timestamp, fieldNumber: 6)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SPPlayIntentRequest, rhs: SPPlayIntentRequest) -> Bool {
    if lhs.version != rhs.version {return false}
    if lhs.token != rhs.token {return false}
    if lhs._cacheID != rhs._cacheID {return false}
    if lhs.interactivity != rhs.interactivity {return false}
    if lhs.contentType != rhs.contentType {return false}
    if lhs.timestamp != rhs.timestamp {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
