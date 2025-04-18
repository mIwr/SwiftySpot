// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: TLComponentV2.proto
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

struct SPDacToolbarComponentV2: @unchecked Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var dayPartMessage: String {
    get {return _storage._dayPartMessage}
    set {_uniqueStorage()._dayPartMessage = newValue}
  }

  var subtitle: String {
    get {return _storage._subtitle ?? String()}
    set {_uniqueStorage()._subtitle = newValue}
  }
  /// Returns true if `subtitle` has been explicitly set.
  var hasSubtitle: Bool {return _storage._subtitle != nil}
  /// Clears the value of `subtitle`. Subsequent reads from it will return its default value.
  mutating func clearSubtitle() {_uniqueStorage()._subtitle = nil}

  var items: [SwiftProtobuf.Google_Protobuf_Any] {
    get {return _storage._items}
    set {_uniqueStorage()._items = newValue}
  }

  var profileBtn: SPDacToolbarItemProfileComponent {
    get {return _storage._profileBtn ?? SPDacToolbarItemProfileComponent()}
    set {_uniqueStorage()._profileBtn = newValue}
  }
  /// Returns true if `profileBtn` has been explicitly set.
  var hasProfileBtn: Bool {return _storage._profileBtn != nil}
  /// Clears the value of `profileBtn`. Subsequent reads from it will return its default value.
  mutating func clearProfileBtn() {_uniqueStorage()._profileBtn = nil}

  var ubiElementInfo: SPUbiUbiElementInfo {
    get {return _storage._ubiElementInfo ?? SPUbiUbiElementInfo()}
    set {_uniqueStorage()._ubiElementInfo = newValue}
  }
  /// Returns true if `ubiElementInfo` has been explicitly set.
  var hasUbiElementInfo: Bool {return _storage._ubiElementInfo != nil}
  /// Clears the value of `ubiElementInfo`. Subsequent reads from it will return its default value.
  mutating func clearUbiElementInfo() {_uniqueStorage()._ubiElementInfo = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

struct SPDacShortcutsSectionComponentV2: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var shortcuts: [SwiftProtobuf.Google_Protobuf_Any] = []

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

fileprivate let _protobuf_package = "com.spotify.home.dac.component.v2.proto"

extension SPDacToolbarComponentV2: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ToolbarComponentV2"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "day_part_message"),
    2: .same(proto: "subtitle"),
    3: .same(proto: "items"),
    4: .standard(proto: "profile_btn"),
    2000: .standard(proto: "ubi_element_info"),
  ]

  fileprivate class _StorageClass {
    var _dayPartMessage: String = String()
    var _subtitle: String? = nil
    var _items: [SwiftProtobuf.Google_Protobuf_Any] = []
    var _profileBtn: SPDacToolbarItemProfileComponent? = nil
    var _ubiElementInfo: SPUbiUbiElementInfo? = nil

    #if swift(>=5.10)
      // This property is used as the initial default value for new instances of the type.
      // The type itself is protecting the reference to its storage via CoW semantics.
      // This will force a copy to be made of this reference when the first mutation occurs;
      // hence, it is safe to mark this as `nonisolated(unsafe)`.
      static nonisolated(unsafe) let defaultInstance = _StorageClass()
    #else
      static let defaultInstance = _StorageClass()
    #endif

    private init() {}

    init(copying source: _StorageClass) {
      _dayPartMessage = source._dayPartMessage
      _subtitle = source._subtitle
      _items = source._items
      _profileBtn = source._profileBtn
      _ubiElementInfo = source._ubiElementInfo
    }
  }

  fileprivate mutating func _uniqueStorage() -> _StorageClass {
    if !isKnownUniquelyReferenced(&_storage) {
      _storage = _StorageClass(copying: _storage)
    }
    return _storage
  }

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    _ = _uniqueStorage()
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      while let fieldNumber = try decoder.nextFieldNumber() {
        // The use of inline closures is to circumvent an issue where the compiler
        // allocates stack space for every case branch when no optimizations are
        // enabled. https://github.com/apple/swift-protobuf/issues/1034
        switch fieldNumber {
        case 1: try { try decoder.decodeSingularStringField(value: &_storage._dayPartMessage) }()
        case 2: try { try decoder.decodeSingularStringField(value: &_storage._subtitle) }()
        case 3: try { try decoder.decodeRepeatedMessageField(value: &_storage._items) }()
        case 4: try { try decoder.decodeSingularMessageField(value: &_storage._profileBtn) }()
        case 2000: try { try decoder.decodeSingularMessageField(value: &_storage._ubiElementInfo) }()
        default: break
        }
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every if/case branch local when no optimizations
      // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
      // https://github.com/apple/swift-protobuf/issues/1182
      if !_storage._dayPartMessage.isEmpty {
        try visitor.visitSingularStringField(value: _storage._dayPartMessage, fieldNumber: 1)
      }
      try { if let v = _storage._subtitle {
        try visitor.visitSingularStringField(value: v, fieldNumber: 2)
      } }()
      if !_storage._items.isEmpty {
        try visitor.visitRepeatedMessageField(value: _storage._items, fieldNumber: 3)
      }
      try { if let v = _storage._profileBtn {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 4)
      } }()
      try { if let v = _storage._ubiElementInfo {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 2000)
      } }()
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SPDacToolbarComponentV2, rhs: SPDacToolbarComponentV2) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._dayPartMessage != rhs_storage._dayPartMessage {return false}
        if _storage._subtitle != rhs_storage._subtitle {return false}
        if _storage._items != rhs_storage._items {return false}
        if _storage._profileBtn != rhs_storage._profileBtn {return false}
        if _storage._ubiElementInfo != rhs_storage._ubiElementInfo {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SPDacShortcutsSectionComponentV2: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ShortcutsSectionComponentV2"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "shortcuts"),
    2000: .standard(proto: "ubi_element_info"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedMessageField(value: &self.shortcuts) }()
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
    if !self.shortcuts.isEmpty {
      try visitor.visitRepeatedMessageField(value: self.shortcuts, fieldNumber: 1)
    }
    try { if let v = self._ubiElementInfo {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2000)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SPDacShortcutsSectionComponentV2, rhs: SPDacShortcutsSectionComponentV2) -> Bool {
    if lhs.shortcuts != rhs.shortcuts {return false}
    if lhs._ubiElementInfo != rhs._ubiElementInfo {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
