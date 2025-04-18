// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: FilterComponent.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

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

struct SPDacFilterComponent: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var facets: [SPDacFacet] = []

  var ubiElementInfo: SPUbiUbiElementInfo {
    get {return _ubiElementInfo ?? SPUbiUbiElementInfo()}
    set {_ubiElementInfo = newValue}
  }
  /// Returns true if `ubiElementInfo` has been explicitly set.
  var hasUbiElementInfo: Bool {return self._ubiElementInfo != nil}
  /// Clears the value of `ubiElementInfo`. Subsequent reads from it will return its default value.
  mutating func clearUbiElementInfo() {self._ubiElementInfo = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _ubiElementInfo: SPUbiUbiElementInfo? = nil
}

struct SPDacFacet: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var title: String = String()

  var value: String = String()

  var selected: Bool = false

  var ubiElementInfo: SPUbiUbiElementInfo {
    get {return _ubiElementInfo ?? SPUbiUbiElementInfo()}
    set {_ubiElementInfo = newValue}
  }
  /// Returns true if `ubiElementInfo` has been explicitly set.
  var hasUbiElementInfo: Bool {return self._ubiElementInfo != nil}
  /// Clears the value of `ubiElementInfo`. Subsequent reads from it will return its default value.
  mutating func clearUbiElementInfo() {self._ubiElementInfo = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _ubiElementInfo: SPUbiUbiElementInfo? = nil
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "com.spotify.home.dac.component.experimental.v1.proto"

extension SPDacFilterComponent: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".FilterComponent"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "facets"),
    2000: .standard(proto: "ubi_element_info"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.facets) }()
      case 2000: try { try decoder.decodeSingularMessageField(value: &self._ubiElementInfo) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if !self.facets.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.facets, fieldNumber: 1)
    }
    try { if let v = self._ubiElementInfo {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2000)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SPDacFilterComponent, rhs: SPDacFilterComponent) -> Bool {
    if lhs.facets != rhs.facets {return false}
    if lhs._ubiElementInfo != rhs._ubiElementInfo {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SPDacFacet: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".Facet"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "title"),
    2: .same(proto: "value"),
    3: .same(proto: "selected"),
    2000: .standard(proto: "ubi_element_info"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.title) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.value) }()
      case 3: try { try decoder.decodeSingularBoolField(value: &self.selected) }()
      case 2000: try { try decoder.decodeSingularMessageField(value: &self._ubiElementInfo) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if !self.title.isEmpty {
      try visitor.visitSingularStringField(value: self.title, fieldNumber: 1)
    }
    if !self.value.isEmpty {
      try visitor.visitSingularStringField(value: self.value, fieldNumber: 2)
    }
    if self.selected != false {
      try visitor.visitSingularBoolField(value: self.selected, fieldNumber: 3)
    }
    try { if let v = self._ubiElementInfo {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2000)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SPDacFacet, rhs: SPDacFacet) -> Bool {
    if lhs.title != rhs.title {return false}
    if lhs.value != rhs.value {return false}
    if lhs.selected != rhs.selected {return false}
    if lhs._ubiElementInfo != rhs._ubiElementInfo {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
