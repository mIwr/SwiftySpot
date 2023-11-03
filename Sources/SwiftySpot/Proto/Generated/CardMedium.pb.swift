// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: CardMedium.proto
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

struct Com_Spotify_Home_Dac_Component_V1_Proto_AlbumCardMediumComponent {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var title: String = String()

  var subtitle: String = String()

  var uri: String = String()

  var image: String = String()

  var contextMenu: SwiftProtobuf.Google_Protobuf_Any {
    get {return _contextMenu ?? SwiftProtobuf.Google_Protobuf_Any()}
    set {_contextMenu = newValue}
  }
  /// Returns true if `contextMenu` has been explicitly set.
  var hasContextMenu: Bool {return self._contextMenu != nil}
  /// Clears the value of `contextMenu`. Subsequent reads from it will return its default value.
  mutating func clearContextMenu() {self._contextMenu = nil}

  var ubiElementInfo: Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo {
    get {return _ubiElementInfo ?? Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo()}
    set {_ubiElementInfo = newValue}
  }
  /// Returns true if `ubiElementInfo` has been explicitly set.
  var hasUbiElementInfo: Bool {return self._ubiElementInfo != nil}
  /// Clears the value of `ubiElementInfo`. Subsequent reads from it will return its default value.
  mutating func clearUbiElementInfo() {self._ubiElementInfo = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _contextMenu: SwiftProtobuf.Google_Protobuf_Any? = nil
  fileprivate var _ubiElementInfo: Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo? = nil
}

struct Com_Spotify_Home_Dac_Component_V1_Proto_ShowCardMediumComponent {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var title: String = String()

  var subtitle: String = String()

  var showCategories: String = String()

  var uri: String = String()

  var image: String = String()

  var contextMenu: SwiftProtobuf.Google_Protobuf_Any {
    get {return _contextMenu ?? SwiftProtobuf.Google_Protobuf_Any()}
    set {_contextMenu = newValue}
  }
  /// Returns true if `contextMenu` has been explicitly set.
  var hasContextMenu: Bool {return self._contextMenu != nil}
  /// Clears the value of `contextMenu`. Subsequent reads from it will return its default value.
  mutating func clearContextMenu() {self._contextMenu = nil}

  var ubiElementInfo: Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo {
    get {return _ubiElementInfo ?? Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo()}
    set {_ubiElementInfo = newValue}
  }
  /// Returns true if `ubiElementInfo` has been explicitly set.
  var hasUbiElementInfo: Bool {return self._ubiElementInfo != nil}
  /// Clears the value of `ubiElementInfo`. Subsequent reads from it will return its default value.
  mutating func clearUbiElementInfo() {self._ubiElementInfo = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _contextMenu: SwiftProtobuf.Google_Protobuf_Any? = nil
  fileprivate var _ubiElementInfo: Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo? = nil
}

struct Com_Spotify_Home_Dac_Component_V1_Proto_TrackCardMediumComponent {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var title: String = String()

  var subtitle: String = String()

  var uri: String = String()

  var image: String = String()

  var contextMenu: SwiftProtobuf.Google_Protobuf_Any {
    get {return _contextMenu ?? SwiftProtobuf.Google_Protobuf_Any()}
    set {_contextMenu = newValue}
  }
  /// Returns true if `contextMenu` has been explicitly set.
  var hasContextMenu: Bool {return self._contextMenu != nil}
  /// Clears the value of `contextMenu`. Subsequent reads from it will return its default value.
  mutating func clearContextMenu() {self._contextMenu = nil}

  var ubiElementInfo: Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo {
    get {return _ubiElementInfo ?? Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo()}
    set {_ubiElementInfo = newValue}
  }
  /// Returns true if `ubiElementInfo` has been explicitly set.
  var hasUbiElementInfo: Bool {return self._ubiElementInfo != nil}
  /// Clears the value of `ubiElementInfo`. Subsequent reads from it will return its default value.
  mutating func clearUbiElementInfo() {self._ubiElementInfo = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _contextMenu: SwiftProtobuf.Google_Protobuf_Any? = nil
  fileprivate var _ubiElementInfo: Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo? = nil
}

struct Com_Spotify_Home_Dac_Component_V1_Proto_LikedSongsCardMediumComponent {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var ubiElementInfo: Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo {
    get {return _ubiElementInfo ?? Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo()}
    set {_ubiElementInfo = newValue}
  }
  /// Returns true if `ubiElementInfo` has been explicitly set.
  var hasUbiElementInfo: Bool {return self._ubiElementInfo != nil}
  /// Clears the value of `ubiElementInfo`. Subsequent reads from it will return its default value.
  mutating func clearUbiElementInfo() {self._ubiElementInfo = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _ubiElementInfo: Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo? = nil
}

struct Com_Spotify_Home_Dac_Component_V1_Proto_PlaylistCardMediumComponent {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var title: String = String()

  var subtitle: String = String()

  var uri: String = String()

  var image: String = String()

  var accessibility: Com_Spotify_Home_Dac_Accessibility_V1_Proto_Accessibility {
    get {return _accessibility ?? Com_Spotify_Home_Dac_Accessibility_V1_Proto_Accessibility()}
    set {_accessibility = newValue}
  }
  /// Returns true if `accessibility` has been explicitly set.
  var hasAccessibility: Bool {return self._accessibility != nil}
  /// Clears the value of `accessibility`. Subsequent reads from it will return its default value.
  mutating func clearAccessibility() {self._accessibility = nil}

  var contextMenu: SwiftProtobuf.Google_Protobuf_Any {
    get {return _contextMenu ?? SwiftProtobuf.Google_Protobuf_Any()}
    set {_contextMenu = newValue}
  }
  /// Returns true if `contextMenu` has been explicitly set.
  var hasContextMenu: Bool {return self._contextMenu != nil}
  /// Clears the value of `contextMenu`. Subsequent reads from it will return its default value.
  mutating func clearContextMenu() {self._contextMenu = nil}

  var ubiElementInfo: Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo {
    get {return _ubiElementInfo ?? Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo()}
    set {_ubiElementInfo = newValue}
  }
  /// Returns true if `ubiElementInfo` has been explicitly set.
  var hasUbiElementInfo: Bool {return self._ubiElementInfo != nil}
  /// Clears the value of `ubiElementInfo`. Subsequent reads from it will return its default value.
  mutating func clearUbiElementInfo() {self._ubiElementInfo = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _accessibility: Com_Spotify_Home_Dac_Accessibility_V1_Proto_Accessibility? = nil
  fileprivate var _contextMenu: SwiftProtobuf.Google_Protobuf_Any? = nil
  fileprivate var _ubiElementInfo: Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo? = nil
}

struct Com_Spotify_Home_Dac_Component_V1_Proto_EpisodeCardMediumComponent {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var title: String = String()

  var subtitle: String = String()

  var uri: String = String()

  var image: String = String()

  var contextMenu: SwiftProtobuf.Google_Protobuf_Any {
    get {return _contextMenu ?? SwiftProtobuf.Google_Protobuf_Any()}
    set {_contextMenu = newValue}
  }
  /// Returns true if `contextMenu` has been explicitly set.
  var hasContextMenu: Bool {return self._contextMenu != nil}
  /// Clears the value of `contextMenu`. Subsequent reads from it will return its default value.
  mutating func clearContextMenu() {self._contextMenu = nil}

  var ubiElementInfo: Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo {
    get {return _ubiElementInfo ?? Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo()}
    set {_ubiElementInfo = newValue}
  }
  /// Returns true if `ubiElementInfo` has been explicitly set.
  var hasUbiElementInfo: Bool {return self._ubiElementInfo != nil}
  /// Clears the value of `ubiElementInfo`. Subsequent reads from it will return its default value.
  mutating func clearUbiElementInfo() {self._ubiElementInfo = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _contextMenu: SwiftProtobuf.Google_Protobuf_Any? = nil
  fileprivate var _ubiElementInfo: Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo? = nil
}

struct Com_Spotify_Home_Dac_Component_V1_Proto_ArtistCardMediumComponent {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var title: String = String()

  var subtitle: String = String()

  var uri: String = String()

  var image: String = String()

  var contextMenu: SwiftProtobuf.Google_Protobuf_Any {
    get {return _contextMenu ?? SwiftProtobuf.Google_Protobuf_Any()}
    set {_contextMenu = newValue}
  }
  /// Returns true if `contextMenu` has been explicitly set.
  var hasContextMenu: Bool {return self._contextMenu != nil}
  /// Clears the value of `contextMenu`. Subsequent reads from it will return its default value.
  mutating func clearContextMenu() {self._contextMenu = nil}

  var ubiElementInfo: Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo {
    get {return _ubiElementInfo ?? Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo()}
    set {_ubiElementInfo = newValue}
  }
  /// Returns true if `ubiElementInfo` has been explicitly set.
  var hasUbiElementInfo: Bool {return self._ubiElementInfo != nil}
  /// Clears the value of `ubiElementInfo`. Subsequent reads from it will return its default value.
  mutating func clearUbiElementInfo() {self._ubiElementInfo = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _contextMenu: SwiftProtobuf.Google_Protobuf_Any? = nil
  fileprivate var _ubiElementInfo: Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo? = nil
}

struct Com_Spotify_Home_Dac_Component_V1_Proto_YourEpisodesCardMediumComponent {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var ubiElementInfo: Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo {
    get {return _ubiElementInfo ?? Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo()}
    set {_ubiElementInfo = newValue}
  }
  /// Returns true if `ubiElementInfo` has been explicitly set.
  var hasUbiElementInfo: Bool {return self._ubiElementInfo != nil}
  /// Clears the value of `ubiElementInfo`. Subsequent reads from it will return its default value.
  mutating func clearUbiElementInfo() {self._ubiElementInfo = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _ubiElementInfo: Com_Spotify_Ubi_Proto_Elementinfo_V1_UbiElementInfo? = nil
}

#if swift(>=5.5) && canImport(_Concurrency)
extension Com_Spotify_Home_Dac_Component_V1_Proto_AlbumCardMediumComponent: @unchecked Sendable {}
extension Com_Spotify_Home_Dac_Component_V1_Proto_ShowCardMediumComponent: @unchecked Sendable {}
extension Com_Spotify_Home_Dac_Component_V1_Proto_TrackCardMediumComponent: @unchecked Sendable {}
extension Com_Spotify_Home_Dac_Component_V1_Proto_LikedSongsCardMediumComponent: @unchecked Sendable {}
extension Com_Spotify_Home_Dac_Component_V1_Proto_PlaylistCardMediumComponent: @unchecked Sendable {}
extension Com_Spotify_Home_Dac_Component_V1_Proto_EpisodeCardMediumComponent: @unchecked Sendable {}
extension Com_Spotify_Home_Dac_Component_V1_Proto_ArtistCardMediumComponent: @unchecked Sendable {}
extension Com_Spotify_Home_Dac_Component_V1_Proto_YourEpisodesCardMediumComponent: @unchecked Sendable {}
#endif  // swift(>=5.5) && canImport(_Concurrency)

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "com.spotify.home.dac.component.v1.proto"

extension Com_Spotify_Home_Dac_Component_V1_Proto_AlbumCardMediumComponent: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".AlbumCardMediumComponent"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "title"),
    2: .same(proto: "subtitle"),
    3: .same(proto: "uri"),
    4: .same(proto: "image"),
    5: .standard(proto: "context_menu"),
    2000: .standard(proto: "ubi_element_info"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.title) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.subtitle) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.uri) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.image) }()
      case 5: try { try decoder.decodeSingularMessageField(value: &self._contextMenu) }()
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
    if !self.subtitle.isEmpty {
      try visitor.visitSingularStringField(value: self.subtitle, fieldNumber: 2)
    }
    if !self.uri.isEmpty {
      try visitor.visitSingularStringField(value: self.uri, fieldNumber: 3)
    }
    if !self.image.isEmpty {
      try visitor.visitSingularStringField(value: self.image, fieldNumber: 4)
    }
    try { if let v = self._contextMenu {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
    } }()
    try { if let v = self._ubiElementInfo {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2000)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Com_Spotify_Home_Dac_Component_V1_Proto_AlbumCardMediumComponent, rhs: Com_Spotify_Home_Dac_Component_V1_Proto_AlbumCardMediumComponent) -> Bool {
    if lhs.title != rhs.title {return false}
    if lhs.subtitle != rhs.subtitle {return false}
    if lhs.uri != rhs.uri {return false}
    if lhs.image != rhs.image {return false}
    if lhs._contextMenu != rhs._contextMenu {return false}
    if lhs._ubiElementInfo != rhs._ubiElementInfo {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Com_Spotify_Home_Dac_Component_V1_Proto_ShowCardMediumComponent: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ShowCardMediumComponent"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "title"),
    2: .same(proto: "subtitle"),
    3: .same(proto: "showCategories"),
    4: .same(proto: "uri"),
    5: .same(proto: "image"),
    6: .standard(proto: "context_menu"),
    2000: .standard(proto: "ubi_element_info"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.title) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.subtitle) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.showCategories) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.uri) }()
      case 5: try { try decoder.decodeSingularStringField(value: &self.image) }()
      case 6: try { try decoder.decodeSingularMessageField(value: &self._contextMenu) }()
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
    if !self.subtitle.isEmpty {
      try visitor.visitSingularStringField(value: self.subtitle, fieldNumber: 2)
    }
    if !self.showCategories.isEmpty {
      try visitor.visitSingularStringField(value: self.showCategories, fieldNumber: 3)
    }
    if !self.uri.isEmpty {
      try visitor.visitSingularStringField(value: self.uri, fieldNumber: 4)
    }
    if !self.image.isEmpty {
      try visitor.visitSingularStringField(value: self.image, fieldNumber: 5)
    }
    try { if let v = self._contextMenu {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 6)
    } }()
    try { if let v = self._ubiElementInfo {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2000)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Com_Spotify_Home_Dac_Component_V1_Proto_ShowCardMediumComponent, rhs: Com_Spotify_Home_Dac_Component_V1_Proto_ShowCardMediumComponent) -> Bool {
    if lhs.title != rhs.title {return false}
    if lhs.subtitle != rhs.subtitle {return false}
    if lhs.showCategories != rhs.showCategories {return false}
    if lhs.uri != rhs.uri {return false}
    if lhs.image != rhs.image {return false}
    if lhs._contextMenu != rhs._contextMenu {return false}
    if lhs._ubiElementInfo != rhs._ubiElementInfo {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Com_Spotify_Home_Dac_Component_V1_Proto_TrackCardMediumComponent: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".TrackCardMediumComponent"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "title"),
    2: .same(proto: "subtitle"),
    3: .same(proto: "uri"),
    4: .same(proto: "image"),
    5: .standard(proto: "context_menu"),
    2000: .standard(proto: "ubi_element_info"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.title) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.subtitle) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.uri) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.image) }()
      case 5: try { try decoder.decodeSingularMessageField(value: &self._contextMenu) }()
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
    if !self.subtitle.isEmpty {
      try visitor.visitSingularStringField(value: self.subtitle, fieldNumber: 2)
    }
    if !self.uri.isEmpty {
      try visitor.visitSingularStringField(value: self.uri, fieldNumber: 3)
    }
    if !self.image.isEmpty {
      try visitor.visitSingularStringField(value: self.image, fieldNumber: 4)
    }
    try { if let v = self._contextMenu {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
    } }()
    try { if let v = self._ubiElementInfo {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2000)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Com_Spotify_Home_Dac_Component_V1_Proto_TrackCardMediumComponent, rhs: Com_Spotify_Home_Dac_Component_V1_Proto_TrackCardMediumComponent) -> Bool {
    if lhs.title != rhs.title {return false}
    if lhs.subtitle != rhs.subtitle {return false}
    if lhs.uri != rhs.uri {return false}
    if lhs.image != rhs.image {return false}
    if lhs._contextMenu != rhs._contextMenu {return false}
    if lhs._ubiElementInfo != rhs._ubiElementInfo {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Com_Spotify_Home_Dac_Component_V1_Proto_LikedSongsCardMediumComponent: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".LikedSongsCardMediumComponent"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    2000: .standard(proto: "ubi_element_info"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
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
    try { if let v = self._ubiElementInfo {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2000)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Com_Spotify_Home_Dac_Component_V1_Proto_LikedSongsCardMediumComponent, rhs: Com_Spotify_Home_Dac_Component_V1_Proto_LikedSongsCardMediumComponent) -> Bool {
    if lhs._ubiElementInfo != rhs._ubiElementInfo {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Com_Spotify_Home_Dac_Component_V1_Proto_PlaylistCardMediumComponent: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".PlaylistCardMediumComponent"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "title"),
    2: .same(proto: "subtitle"),
    3: .same(proto: "uri"),
    4: .same(proto: "image"),
    5: .same(proto: "accessibility"),
    6: .standard(proto: "context_menu"),
    2000: .standard(proto: "ubi_element_info"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.title) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.subtitle) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.uri) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.image) }()
      case 5: try { try decoder.decodeSingularMessageField(value: &self._accessibility) }()
      case 6: try { try decoder.decodeSingularMessageField(value: &self._contextMenu) }()
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
    if !self.subtitle.isEmpty {
      try visitor.visitSingularStringField(value: self.subtitle, fieldNumber: 2)
    }
    if !self.uri.isEmpty {
      try visitor.visitSingularStringField(value: self.uri, fieldNumber: 3)
    }
    if !self.image.isEmpty {
      try visitor.visitSingularStringField(value: self.image, fieldNumber: 4)
    }
    try { if let v = self._accessibility {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
    } }()
    try { if let v = self._contextMenu {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 6)
    } }()
    try { if let v = self._ubiElementInfo {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2000)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Com_Spotify_Home_Dac_Component_V1_Proto_PlaylistCardMediumComponent, rhs: Com_Spotify_Home_Dac_Component_V1_Proto_PlaylistCardMediumComponent) -> Bool {
    if lhs.title != rhs.title {return false}
    if lhs.subtitle != rhs.subtitle {return false}
    if lhs.uri != rhs.uri {return false}
    if lhs.image != rhs.image {return false}
    if lhs._accessibility != rhs._accessibility {return false}
    if lhs._contextMenu != rhs._contextMenu {return false}
    if lhs._ubiElementInfo != rhs._ubiElementInfo {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Com_Spotify_Home_Dac_Component_V1_Proto_EpisodeCardMediumComponent: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".EpisodeCardMediumComponent"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "title"),
    2: .same(proto: "subtitle"),
    3: .same(proto: "uri"),
    4: .same(proto: "image"),
    5: .standard(proto: "context_menu"),
    2000: .standard(proto: "ubi_element_info"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.title) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.subtitle) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.uri) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.image) }()
      case 5: try { try decoder.decodeSingularMessageField(value: &self._contextMenu) }()
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
    if !self.subtitle.isEmpty {
      try visitor.visitSingularStringField(value: self.subtitle, fieldNumber: 2)
    }
    if !self.uri.isEmpty {
      try visitor.visitSingularStringField(value: self.uri, fieldNumber: 3)
    }
    if !self.image.isEmpty {
      try visitor.visitSingularStringField(value: self.image, fieldNumber: 4)
    }
    try { if let v = self._contextMenu {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
    } }()
    try { if let v = self._ubiElementInfo {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2000)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Com_Spotify_Home_Dac_Component_V1_Proto_EpisodeCardMediumComponent, rhs: Com_Spotify_Home_Dac_Component_V1_Proto_EpisodeCardMediumComponent) -> Bool {
    if lhs.title != rhs.title {return false}
    if lhs.subtitle != rhs.subtitle {return false}
    if lhs.uri != rhs.uri {return false}
    if lhs.image != rhs.image {return false}
    if lhs._contextMenu != rhs._contextMenu {return false}
    if lhs._ubiElementInfo != rhs._ubiElementInfo {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Com_Spotify_Home_Dac_Component_V1_Proto_ArtistCardMediumComponent: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ArtistCardMediumComponent"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "title"),
    2: .same(proto: "subtitle"),
    3: .same(proto: "uri"),
    4: .same(proto: "image"),
    5: .standard(proto: "context_menu"),
    2000: .standard(proto: "ubi_element_info"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.title) }()
      case 2: try { try decoder.decodeSingularStringField(value: &self.subtitle) }()
      case 3: try { try decoder.decodeSingularStringField(value: &self.uri) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.image) }()
      case 5: try { try decoder.decodeSingularMessageField(value: &self._contextMenu) }()
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
    if !self.subtitle.isEmpty {
      try visitor.visitSingularStringField(value: self.subtitle, fieldNumber: 2)
    }
    if !self.uri.isEmpty {
      try visitor.visitSingularStringField(value: self.uri, fieldNumber: 3)
    }
    if !self.image.isEmpty {
      try visitor.visitSingularStringField(value: self.image, fieldNumber: 4)
    }
    try { if let v = self._contextMenu {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
    } }()
    try { if let v = self._ubiElementInfo {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2000)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Com_Spotify_Home_Dac_Component_V1_Proto_ArtistCardMediumComponent, rhs: Com_Spotify_Home_Dac_Component_V1_Proto_ArtistCardMediumComponent) -> Bool {
    if lhs.title != rhs.title {return false}
    if lhs.subtitle != rhs.subtitle {return false}
    if lhs.uri != rhs.uri {return false}
    if lhs.image != rhs.image {return false}
    if lhs._contextMenu != rhs._contextMenu {return false}
    if lhs._ubiElementInfo != rhs._ubiElementInfo {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension Com_Spotify_Home_Dac_Component_V1_Proto_YourEpisodesCardMediumComponent: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".YourEpisodesCardMediumComponent"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    2000: .standard(proto: "ubi_element_info"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
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
    try { if let v = self._ubiElementInfo {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2000)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: Com_Spotify_Home_Dac_Component_V1_Proto_YourEpisodesCardMediumComponent, rhs: Com_Spotify_Home_Dac_Component_V1_Proto_YourEpisodesCardMediumComponent) -> Bool {
    if lhs._ubiElementInfo != rhs._ubiElementInfo {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}