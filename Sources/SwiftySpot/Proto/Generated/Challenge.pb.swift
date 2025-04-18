// DO NOT EDIT.
// swift-format-ignore-file
// swiftlint:disable all
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: Challenge.proto
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

///Client token generation and authorization hashcash challenge
struct SPHashcashChallenge: @unchecked Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var length: Int32 = 0

  var prefix: Data = Data()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

///Hashcash challenge answer
struct SPHashcashChallengeAnswer: @unchecked Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var suffix: Data = Data()

  ///Authorization hashcash challenge solving duration
  var duration: SwiftProtobuf.Google_Protobuf_Duration {
    get {return _duration ?? SwiftProtobuf.Google_Protobuf_Duration()}
    set {_duration = newValue}
  }
  /// Returns true if `duration` has been explicitly set.
  var hasDuration: Bool {return self._duration != nil}
  /// Clears the value of `duration`. Subsequent reads from it will return its default value.
  mutating func clearDuration() {self._duration = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _duration: SwiftProtobuf.Google_Protobuf_Duration? = nil
}

///Client token generation client secret challenge
struct SPClientSecretChallenge: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var salt: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

///Client secret challenge answer
struct SPClientSecretHMACAnswer: @unchecked Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var hmac: Data = Data()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

///Client token generation JS challenge
struct SPEvaluateJSChallenge: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var code: String = String()

  var libraries: [String] = []

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

///JS challenge answer
struct SPEvaluateJSAnswer: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var result: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

///Authorization code challenge
struct SPCodeChallenge: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var method: SPCodeChallenge.Method = .unknown

  var codeLength: Int32 = 0

  var expiresInS: Int32 = 0

  var canonicalPhoneNumber: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  enum Method: SwiftProtobuf.Enum, Swift.CaseIterable {
    typealias RawValue = Int
    case unknown // = 0
    case sms // = 1
    case UNRECOGNIZED(Int)

    init() {
      self = .unknown
    }

    init?(rawValue: Int) {
      switch rawValue {
      case 0: self = .unknown
      case 1: self = .sms
      default: self = .UNRECOGNIZED(rawValue)
      }
    }

    var rawValue: Int {
      switch self {
      case .unknown: return 0
      case .sms: return 1
      case .UNRECOGNIZED(let i): return i
      }
    }

    // The compiler won't synthesize support with the UNRECOGNIZED case.
    static let allCases: [SPCodeChallenge.Method] = [
      .unknown,
      .sms,
    ]

  }

  init() {}
}

///Code challenge answer
struct SPCodeChallengeAnswer: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var code: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

///Authorization captcha challenge
struct SPCaptchaChallenge: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var urlContainer: SPCaptchaUrlContainer {
    get {return _urlContainer ?? SPCaptchaUrlContainer()}
    set {_urlContainer = newValue}
  }
  /// Returns true if `urlContainer` has been explicitly set.
  var hasURLContainer: Bool {return self._urlContainer != nil}
  /// Clears the value of `urlContainer`. Subsequent reads from it will return its default value.
  mutating func clearURLContainer() {self._urlContainer = nil}

  var interactRefContainer: SPCaptchaInteractRefContainer {
    get {return _interactRefContainer ?? SPCaptchaInteractRefContainer()}
    set {_interactRefContainer = newValue}
  }
  /// Returns true if `interactRefContainer` has been explicitly set.
  var hasInteractRefContainer: Bool {return self._interactRefContainer != nil}
  /// Clears the value of `interactRefContainer`. Subsequent reads from it will return its default value.
  mutating func clearInteractRefContainer() {self._interactRefContainer = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _urlContainer: SPCaptchaUrlContainer? = nil
  fileprivate var _interactRefContainer: SPCaptchaInteractRefContainer? = nil
}

struct SPCaptchaUrlContainer: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var url: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct SPCaptchaInteractRefContainer: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var interactRef: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

///Captcha challenge answer
struct SPCaptchaChallengeAnswer: Sendable {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var interactRef: String = String()

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

extension SPHashcashChallenge: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "HashcashChallenge"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "length"),
    2: .same(proto: "prefix"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularInt32Field(value: &self.length) }()
      case 2: try { try decoder.decodeSingularBytesField(value: &self.prefix) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.length != 0 {
      try visitor.visitSingularInt32Field(value: self.length, fieldNumber: 1)
    }
    if !self.prefix.isEmpty {
      try visitor.visitSingularBytesField(value: self.prefix, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SPHashcashChallenge, rhs: SPHashcashChallenge) -> Bool {
    if lhs.length != rhs.length {return false}
    if lhs.prefix != rhs.prefix {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SPHashcashChallengeAnswer: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "HashcashChallengeAnswer"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "suffix"),
    2: .same(proto: "duration"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.suffix) }()
      case 2: try { try decoder.decodeSingularMessageField(value: &self._duration) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    if !self.suffix.isEmpty {
      try visitor.visitSingularBytesField(value: self.suffix, fieldNumber: 1)
    }
    try { if let v = self._duration {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 2)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SPHashcashChallengeAnswer, rhs: SPHashcashChallengeAnswer) -> Bool {
    if lhs.suffix != rhs.suffix {return false}
    if lhs._duration != rhs._duration {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SPClientSecretChallenge: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "ClientSecretChallenge"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "salt"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.salt) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.salt.isEmpty {
      try visitor.visitSingularStringField(value: self.salt, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SPClientSecretChallenge, rhs: SPClientSecretChallenge) -> Bool {
    if lhs.salt != rhs.salt {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SPClientSecretHMACAnswer: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "ClientSecretHMACAnswer"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "hmac"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularBytesField(value: &self.hmac) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.hmac.isEmpty {
      try visitor.visitSingularBytesField(value: self.hmac, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SPClientSecretHMACAnswer, rhs: SPClientSecretHMACAnswer) -> Bool {
    if lhs.hmac != rhs.hmac {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SPEvaluateJSChallenge: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "EvaluateJSChallenge"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "code"),
    2: .same(proto: "libraries"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.code) }()
      case 2: try { try decoder.decodeRepeatedStringField(value: &self.libraries) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.code.isEmpty {
      try visitor.visitSingularStringField(value: self.code, fieldNumber: 1)
    }
    if !self.libraries.isEmpty {
      try visitor.visitRepeatedStringField(value: self.libraries, fieldNumber: 2)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SPEvaluateJSChallenge, rhs: SPEvaluateJSChallenge) -> Bool {
    if lhs.code != rhs.code {return false}
    if lhs.libraries != rhs.libraries {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SPEvaluateJSAnswer: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "EvaluateJSAnswer"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "result"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.result) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.result.isEmpty {
      try visitor.visitSingularStringField(value: self.result, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SPEvaluateJSAnswer, rhs: SPEvaluateJSAnswer) -> Bool {
    if lhs.result != rhs.result {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SPCodeChallenge: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CodeChallenge"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "method"),
    2: .standard(proto: "code_length"),
    3: .standard(proto: "expires_in_s"),
    4: .standard(proto: "canonical_phone_number"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularEnumField(value: &self.method) }()
      case 2: try { try decoder.decodeSingularInt32Field(value: &self.codeLength) }()
      case 3: try { try decoder.decodeSingularInt32Field(value: &self.expiresInS) }()
      case 4: try { try decoder.decodeSingularStringField(value: &self.canonicalPhoneNumber) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if self.method != .unknown {
      try visitor.visitSingularEnumField(value: self.method, fieldNumber: 1)
    }
    if self.codeLength != 0 {
      try visitor.visitSingularInt32Field(value: self.codeLength, fieldNumber: 2)
    }
    if self.expiresInS != 0 {
      try visitor.visitSingularInt32Field(value: self.expiresInS, fieldNumber: 3)
    }
    if !self.canonicalPhoneNumber.isEmpty {
      try visitor.visitSingularStringField(value: self.canonicalPhoneNumber, fieldNumber: 4)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SPCodeChallenge, rhs: SPCodeChallenge) -> Bool {
    if lhs.method != rhs.method {return false}
    if lhs.codeLength != rhs.codeLength {return false}
    if lhs.expiresInS != rhs.expiresInS {return false}
    if lhs.canonicalPhoneNumber != rhs.canonicalPhoneNumber {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SPCodeChallenge.Method: SwiftProtobuf._ProtoNameProviding {
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    0: .same(proto: "UNKNOWN"),
    1: .same(proto: "SMS"),
  ]
}

extension SPCodeChallengeAnswer: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CodeChallengeAnswer"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "code"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.code) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.code.isEmpty {
      try visitor.visitSingularStringField(value: self.code, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SPCodeChallengeAnswer, rhs: SPCodeChallengeAnswer) -> Bool {
    if lhs.code != rhs.code {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SPCaptchaChallenge: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CaptchaChallenge"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "url_container"),
    10: .standard(proto: "interact_ref_container"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularMessageField(value: &self._urlContainer) }()
      case 10: try { try decoder.decodeSingularMessageField(value: &self._interactRefContainer) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    // The use of inline closures is to circumvent an issue where the compiler
    // allocates stack space for every if/case branch local when no optimizations
    // are enabled. https://github.com/apple/swift-protobuf/issues/1034 and
    // https://github.com/apple/swift-protobuf/issues/1182
    try { if let v = self._urlContainer {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 1)
    } }()
    try { if let v = self._interactRefContainer {
      try visitor.visitSingularMessageField(value: v, fieldNumber: 10)
    } }()
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SPCaptchaChallenge, rhs: SPCaptchaChallenge) -> Bool {
    if lhs._urlContainer != rhs._urlContainer {return false}
    if lhs._interactRefContainer != rhs._interactRefContainer {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SPCaptchaUrlContainer: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CaptchaUrlContainer"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "url"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.url) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.url.isEmpty {
      try visitor.visitSingularStringField(value: self.url, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SPCaptchaUrlContainer, rhs: SPCaptchaUrlContainer) -> Bool {
    if lhs.url != rhs.url {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SPCaptchaInteractRefContainer: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CaptchaInteractRefContainer"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "interact_ref"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.interactRef) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.interactRef.isEmpty {
      try visitor.visitSingularStringField(value: self.interactRef, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SPCaptchaInteractRefContainer, rhs: SPCaptchaInteractRefContainer) -> Bool {
    if lhs.interactRef != rhs.interactRef {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SPCaptchaChallengeAnswer: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = "CaptchaChallengeAnswer"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .standard(proto: "interact_ref"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeSingularStringField(value: &self.interactRef) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.interactRef.isEmpty {
      try visitor.visitSingularStringField(value: self.interactRef, fieldNumber: 1)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SPCaptchaChallengeAnswer, rhs: SPCaptchaChallengeAnswer) -> Bool {
    if lhs.interactRef != rhs.interactRef {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
