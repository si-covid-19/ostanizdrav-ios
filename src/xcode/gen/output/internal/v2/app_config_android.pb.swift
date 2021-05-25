// DO NOT EDIT.
// swift-format-ignore-file
//
// Generated by the Swift generator plugin for the protocol buffer compiler.
// Source: internal/v2/app_config_android.proto
//
// For information on using the generated types, please see the documentation:
//   https://github.com/apple/swift-protobuf/

/// This file is auto-generated, DO NOT make any changes here

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

struct SAP_Internal_V2_ApplicationConfigurationAndroid {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  /// Android apps are versioned by Version Code and not by Semantic Versioning
  var minVersionCode: Int64 {
    get {return _storage._minVersionCode}
    set {_uniqueStorage()._minVersionCode = newValue}
  }

  var latestVersionCode: Int64 {
    get {return _storage._latestVersionCode}
    set {_uniqueStorage()._latestVersionCode = newValue}
  }

  var appFeatures: SAP_Internal_V2_AppFeatures {
    get {return _storage._appFeatures ?? SAP_Internal_V2_AppFeatures()}
    set {_uniqueStorage()._appFeatures = newValue}
  }
  /// Returns true if `appFeatures` has been explicitly set.
  var hasAppFeatures: Bool {return _storage._appFeatures != nil}
  /// Clears the value of `appFeatures`. Subsequent reads from it will return its default value.
  mutating func clearAppFeatures() {_uniqueStorage()._appFeatures = nil}

  var supportedCountries: [String] {
    get {return _storage._supportedCountries}
    set {_uniqueStorage()._supportedCountries = newValue}
  }

  var keyDownloadParameters: SAP_Internal_V2_KeyDownloadParametersAndroid {
    get {return _storage._keyDownloadParameters ?? SAP_Internal_V2_KeyDownloadParametersAndroid()}
    set {_uniqueStorage()._keyDownloadParameters = newValue}
  }
  /// Returns true if `keyDownloadParameters` has been explicitly set.
  var hasKeyDownloadParameters: Bool {return _storage._keyDownloadParameters != nil}
  /// Clears the value of `keyDownloadParameters`. Subsequent reads from it will return its default value.
  mutating func clearKeyDownloadParameters() {_uniqueStorage()._keyDownloadParameters = nil}

  var exposureDetectionParameters: SAP_Internal_V2_ExposureDetectionParametersAndroid {
    get {return _storage._exposureDetectionParameters ?? SAP_Internal_V2_ExposureDetectionParametersAndroid()}
    set {_uniqueStorage()._exposureDetectionParameters = newValue}
  }
  /// Returns true if `exposureDetectionParameters` has been explicitly set.
  var hasExposureDetectionParameters: Bool {return _storage._exposureDetectionParameters != nil}
  /// Clears the value of `exposureDetectionParameters`. Subsequent reads from it will return its default value.
  mutating func clearExposureDetectionParameters() {_uniqueStorage()._exposureDetectionParameters = nil}

  var riskCalculationParameters: SAP_Internal_V2_RiskCalculationParameters {
    get {return _storage._riskCalculationParameters ?? SAP_Internal_V2_RiskCalculationParameters()}
    set {_uniqueStorage()._riskCalculationParameters = newValue}
  }
  /// Returns true if `riskCalculationParameters` has been explicitly set.
  var hasRiskCalculationParameters: Bool {return _storage._riskCalculationParameters != nil}
  /// Clears the value of `riskCalculationParameters`. Subsequent reads from it will return its default value.
  mutating func clearRiskCalculationParameters() {_uniqueStorage()._riskCalculationParameters = nil}

  var diagnosisKeysDataMapping: SAP_Internal_V2_DiagnosisKeysDataMapping {
    get {return _storage._diagnosisKeysDataMapping ?? SAP_Internal_V2_DiagnosisKeysDataMapping()}
    set {_uniqueStorage()._diagnosisKeysDataMapping = newValue}
  }
  /// Returns true if `diagnosisKeysDataMapping` has been explicitly set.
  var hasDiagnosisKeysDataMapping: Bool {return _storage._diagnosisKeysDataMapping != nil}
  /// Clears the value of `diagnosisKeysDataMapping`. Subsequent reads from it will return its default value.
  mutating func clearDiagnosisKeysDataMapping() {_uniqueStorage()._diagnosisKeysDataMapping = nil}

  var dailySummariesConfig: SAP_Internal_V2_DailySummariesConfig {
    get {return _storage._dailySummariesConfig ?? SAP_Internal_V2_DailySummariesConfig()}
    set {_uniqueStorage()._dailySummariesConfig = newValue}
  }
  /// Returns true if `dailySummariesConfig` has been explicitly set.
  var hasDailySummariesConfig: Bool {return _storage._dailySummariesConfig != nil}
  /// Clears the value of `dailySummariesConfig`. Subsequent reads from it will return its default value.
  mutating func clearDailySummariesConfig() {_uniqueStorage()._dailySummariesConfig = nil}

  var eventDrivenUserSurveyParameters: SAP_Internal_V2_PPDDEventDrivenUserSurveyParametersAndroid {
    get {return _storage._eventDrivenUserSurveyParameters ?? SAP_Internal_V2_PPDDEventDrivenUserSurveyParametersAndroid()}
    set {_uniqueStorage()._eventDrivenUserSurveyParameters = newValue}
  }
  /// Returns true if `eventDrivenUserSurveyParameters` has been explicitly set.
  var hasEventDrivenUserSurveyParameters: Bool {return _storage._eventDrivenUserSurveyParameters != nil}
  /// Clears the value of `eventDrivenUserSurveyParameters`. Subsequent reads from it will return its default value.
  mutating func clearEventDrivenUserSurveyParameters() {_uniqueStorage()._eventDrivenUserSurveyParameters = nil}

  var privacyPreservingAnalyticsParameters: SAP_Internal_V2_PPDDPrivacyPreservingAnalyticsParametersAndroid {
    get {return _storage._privacyPreservingAnalyticsParameters ?? SAP_Internal_V2_PPDDPrivacyPreservingAnalyticsParametersAndroid()}
    set {_uniqueStorage()._privacyPreservingAnalyticsParameters = newValue}
  }
  /// Returns true if `privacyPreservingAnalyticsParameters` has been explicitly set.
  var hasPrivacyPreservingAnalyticsParameters: Bool {return _storage._privacyPreservingAnalyticsParameters != nil}
  /// Clears the value of `privacyPreservingAnalyticsParameters`. Subsequent reads from it will return its default value.
  mutating func clearPrivacyPreservingAnalyticsParameters() {_uniqueStorage()._privacyPreservingAnalyticsParameters = nil}

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}

  fileprivate var _storage = _StorageClass.defaultInstance
}

struct SAP_Internal_V2_DiagnosisKeysDataMapping {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var daysSinceOnsetToInfectiousness: Dictionary<Int32,Int32> = [:]

  var infectiousnessWhenDaysSinceOnsetMissing: Int32 = 0

  var reportTypeWhenMissing: Int32 = 0

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

struct SAP_Internal_V2_DailySummariesConfig {
  // SwiftProtobuf.Message conformance is added in an extension below. See the
  // `Message` and `Message+*Additions` files in the SwiftProtobuf library for
  // methods supported on all messages.

  var attenuationBucketThresholdDb: [Int32] = []

  var attenuationBucketWeights: [Double] = []

  var daysSinceExposureThreshold: Int32 = 0

  var infectiousnessWeights: Dictionary<Int32,Double> = [:]

  var minimumWindowScore: Double = 0

  var reportTypeWeights: Dictionary<Int32,Double> = [:]

  var unknownFields = SwiftProtobuf.UnknownStorage()

  init() {}
}

// MARK: - Code below here is support for the SwiftProtobuf runtime.

fileprivate let _protobuf_package = "SAP.internal.v2"

extension SAP_Internal_V2_ApplicationConfigurationAndroid: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".ApplicationConfigurationAndroid"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "minVersionCode"),
    2: .same(proto: "latestVersionCode"),
    3: .same(proto: "appFeatures"),
    4: .same(proto: "supportedCountries"),
    5: .same(proto: "keyDownloadParameters"),
    6: .same(proto: "exposureDetectionParameters"),
    7: .same(proto: "riskCalculationParameters"),
    8: .same(proto: "diagnosisKeysDataMapping"),
    9: .same(proto: "dailySummariesConfig"),
    10: .same(proto: "eventDrivenUserSurveyParameters"),
    11: .same(proto: "privacyPreservingAnalyticsParameters"),
  ]

  fileprivate class _StorageClass {
    var _minVersionCode: Int64 = 0
    var _latestVersionCode: Int64 = 0
    var _appFeatures: SAP_Internal_V2_AppFeatures? = nil
    var _supportedCountries: [String] = []
    var _keyDownloadParameters: SAP_Internal_V2_KeyDownloadParametersAndroid? = nil
    var _exposureDetectionParameters: SAP_Internal_V2_ExposureDetectionParametersAndroid? = nil
    var _riskCalculationParameters: SAP_Internal_V2_RiskCalculationParameters? = nil
    var _diagnosisKeysDataMapping: SAP_Internal_V2_DiagnosisKeysDataMapping? = nil
    var _dailySummariesConfig: SAP_Internal_V2_DailySummariesConfig? = nil
    var _eventDrivenUserSurveyParameters: SAP_Internal_V2_PPDDEventDrivenUserSurveyParametersAndroid? = nil
    var _privacyPreservingAnalyticsParameters: SAP_Internal_V2_PPDDPrivacyPreservingAnalyticsParametersAndroid? = nil

    static let defaultInstance = _StorageClass()

    private init() {}

    init(copying source: _StorageClass) {
      _minVersionCode = source._minVersionCode
      _latestVersionCode = source._latestVersionCode
      _appFeatures = source._appFeatures
      _supportedCountries = source._supportedCountries
      _keyDownloadParameters = source._keyDownloadParameters
      _exposureDetectionParameters = source._exposureDetectionParameters
      _riskCalculationParameters = source._riskCalculationParameters
      _diagnosisKeysDataMapping = source._diagnosisKeysDataMapping
      _dailySummariesConfig = source._dailySummariesConfig
      _eventDrivenUserSurveyParameters = source._eventDrivenUserSurveyParameters
      _privacyPreservingAnalyticsParameters = source._privacyPreservingAnalyticsParameters
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
        case 1: try { try decoder.decodeSingularInt64Field(value: &_storage._minVersionCode) }()
        case 2: try { try decoder.decodeSingularInt64Field(value: &_storage._latestVersionCode) }()
        case 3: try { try decoder.decodeSingularMessageField(value: &_storage._appFeatures) }()
        case 4: try { try decoder.decodeRepeatedStringField(value: &_storage._supportedCountries) }()
        case 5: try { try decoder.decodeSingularMessageField(value: &_storage._keyDownloadParameters) }()
        case 6: try { try decoder.decodeSingularMessageField(value: &_storage._exposureDetectionParameters) }()
        case 7: try { try decoder.decodeSingularMessageField(value: &_storage._riskCalculationParameters) }()
        case 8: try { try decoder.decodeSingularMessageField(value: &_storage._diagnosisKeysDataMapping) }()
        case 9: try { try decoder.decodeSingularMessageField(value: &_storage._dailySummariesConfig) }()
        case 10: try { try decoder.decodeSingularMessageField(value: &_storage._eventDrivenUserSurveyParameters) }()
        case 11: try { try decoder.decodeSingularMessageField(value: &_storage._privacyPreservingAnalyticsParameters) }()
        default: break
        }
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    try withExtendedLifetime(_storage) { (_storage: _StorageClass) in
      if _storage._minVersionCode != 0 {
        try visitor.visitSingularInt64Field(value: _storage._minVersionCode, fieldNumber: 1)
      }
      if _storage._latestVersionCode != 0 {
        try visitor.visitSingularInt64Field(value: _storage._latestVersionCode, fieldNumber: 2)
      }
      if let v = _storage._appFeatures {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 3)
      }
      if !_storage._supportedCountries.isEmpty {
        try visitor.visitRepeatedStringField(value: _storage._supportedCountries, fieldNumber: 4)
      }
      if let v = _storage._keyDownloadParameters {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 5)
      }
      if let v = _storage._exposureDetectionParameters {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 6)
      }
      if let v = _storage._riskCalculationParameters {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 7)
      }
      if let v = _storage._diagnosisKeysDataMapping {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 8)
      }
      if let v = _storage._dailySummariesConfig {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 9)
      }
      if let v = _storage._eventDrivenUserSurveyParameters {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 10)
      }
      if let v = _storage._privacyPreservingAnalyticsParameters {
        try visitor.visitSingularMessageField(value: v, fieldNumber: 11)
      }
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SAP_Internal_V2_ApplicationConfigurationAndroid, rhs: SAP_Internal_V2_ApplicationConfigurationAndroid) -> Bool {
    if lhs._storage !== rhs._storage {
      let storagesAreEqual: Bool = withExtendedLifetime((lhs._storage, rhs._storage)) { (_args: (_StorageClass, _StorageClass)) in
        let _storage = _args.0
        let rhs_storage = _args.1
        if _storage._minVersionCode != rhs_storage._minVersionCode {return false}
        if _storage._latestVersionCode != rhs_storage._latestVersionCode {return false}
        if _storage._appFeatures != rhs_storage._appFeatures {return false}
        if _storage._supportedCountries != rhs_storage._supportedCountries {return false}
        if _storage._keyDownloadParameters != rhs_storage._keyDownloadParameters {return false}
        if _storage._exposureDetectionParameters != rhs_storage._exposureDetectionParameters {return false}
        if _storage._riskCalculationParameters != rhs_storage._riskCalculationParameters {return false}
        if _storage._diagnosisKeysDataMapping != rhs_storage._diagnosisKeysDataMapping {return false}
        if _storage._dailySummariesConfig != rhs_storage._dailySummariesConfig {return false}
        if _storage._eventDrivenUserSurveyParameters != rhs_storage._eventDrivenUserSurveyParameters {return false}
        if _storage._privacyPreservingAnalyticsParameters != rhs_storage._privacyPreservingAnalyticsParameters {return false}
        return true
      }
      if !storagesAreEqual {return false}
    }
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SAP_Internal_V2_DiagnosisKeysDataMapping: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".DiagnosisKeysDataMapping"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "daysSinceOnsetToInfectiousness"),
    2: .same(proto: "infectiousnessWhenDaysSinceOnsetMissing"),
    3: .same(proto: "reportTypeWhenMissing"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufInt32,SwiftProtobuf.ProtobufInt32>.self, value: &self.daysSinceOnsetToInfectiousness) }()
      case 2: try { try decoder.decodeSingularInt32Field(value: &self.infectiousnessWhenDaysSinceOnsetMissing) }()
      case 3: try { try decoder.decodeSingularInt32Field(value: &self.reportTypeWhenMissing) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.daysSinceOnsetToInfectiousness.isEmpty {
      try visitor.visitMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufInt32,SwiftProtobuf.ProtobufInt32>.self, value: self.daysSinceOnsetToInfectiousness, fieldNumber: 1)
    }
    if self.infectiousnessWhenDaysSinceOnsetMissing != 0 {
      try visitor.visitSingularInt32Field(value: self.infectiousnessWhenDaysSinceOnsetMissing, fieldNumber: 2)
    }
    if self.reportTypeWhenMissing != 0 {
      try visitor.visitSingularInt32Field(value: self.reportTypeWhenMissing, fieldNumber: 3)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SAP_Internal_V2_DiagnosisKeysDataMapping, rhs: SAP_Internal_V2_DiagnosisKeysDataMapping) -> Bool {
    if lhs.daysSinceOnsetToInfectiousness != rhs.daysSinceOnsetToInfectiousness {return false}
    if lhs.infectiousnessWhenDaysSinceOnsetMissing != rhs.infectiousnessWhenDaysSinceOnsetMissing {return false}
    if lhs.reportTypeWhenMissing != rhs.reportTypeWhenMissing {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}

extension SAP_Internal_V2_DailySummariesConfig: SwiftProtobuf.Message, SwiftProtobuf._MessageImplementationBase, SwiftProtobuf._ProtoNameProviding {
  static let protoMessageName: String = _protobuf_package + ".DailySummariesConfig"
  static let _protobuf_nameMap: SwiftProtobuf._NameMap = [
    1: .same(proto: "attenuationBucketThresholdDb"),
    2: .same(proto: "attenuationBucketWeights"),
    3: .same(proto: "daysSinceExposureThreshold"),
    4: .same(proto: "infectiousnessWeights"),
    5: .same(proto: "minimumWindowScore"),
    6: .same(proto: "reportTypeWeights"),
  ]

  mutating func decodeMessage<D: SwiftProtobuf.Decoder>(decoder: inout D) throws {
    while let fieldNumber = try decoder.nextFieldNumber() {
      // The use of inline closures is to circumvent an issue where the compiler
      // allocates stack space for every case branch when no optimizations are
      // enabled. https://github.com/apple/swift-protobuf/issues/1034
      switch fieldNumber {
      case 1: try { try decoder.decodeRepeatedInt32Field(value: &self.attenuationBucketThresholdDb) }()
      case 2: try { try decoder.decodeRepeatedDoubleField(value: &self.attenuationBucketWeights) }()
      case 3: try { try decoder.decodeSingularInt32Field(value: &self.daysSinceExposureThreshold) }()
      case 4: try { try decoder.decodeMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufInt32,SwiftProtobuf.ProtobufDouble>.self, value: &self.infectiousnessWeights) }()
      case 5: try { try decoder.decodeSingularDoubleField(value: &self.minimumWindowScore) }()
      case 6: try { try decoder.decodeMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufInt32,SwiftProtobuf.ProtobufDouble>.self, value: &self.reportTypeWeights) }()
      default: break
      }
    }
  }

  func traverse<V: SwiftProtobuf.Visitor>(visitor: inout V) throws {
    if !self.attenuationBucketThresholdDb.isEmpty {
      try visitor.visitPackedInt32Field(value: self.attenuationBucketThresholdDb, fieldNumber: 1)
    }
    if !self.attenuationBucketWeights.isEmpty {
      try visitor.visitPackedDoubleField(value: self.attenuationBucketWeights, fieldNumber: 2)
    }
    if self.daysSinceExposureThreshold != 0 {
      try visitor.visitSingularInt32Field(value: self.daysSinceExposureThreshold, fieldNumber: 3)
    }
    if !self.infectiousnessWeights.isEmpty {
      try visitor.visitMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufInt32,SwiftProtobuf.ProtobufDouble>.self, value: self.infectiousnessWeights, fieldNumber: 4)
    }
    if self.minimumWindowScore != 0 {
      try visitor.visitSingularDoubleField(value: self.minimumWindowScore, fieldNumber: 5)
    }
    if !self.reportTypeWeights.isEmpty {
      try visitor.visitMapField(fieldType: SwiftProtobuf._ProtobufMap<SwiftProtobuf.ProtobufInt32,SwiftProtobuf.ProtobufDouble>.self, value: self.reportTypeWeights, fieldNumber: 6)
    }
    try unknownFields.traverse(visitor: &visitor)
  }

  static func ==(lhs: SAP_Internal_V2_DailySummariesConfig, rhs: SAP_Internal_V2_DailySummariesConfig) -> Bool {
    if lhs.attenuationBucketThresholdDb != rhs.attenuationBucketThresholdDb {return false}
    if lhs.attenuationBucketWeights != rhs.attenuationBucketWeights {return false}
    if lhs.daysSinceExposureThreshold != rhs.daysSinceExposureThreshold {return false}
    if lhs.infectiousnessWeights != rhs.infectiousnessWeights {return false}
    if lhs.minimumWindowScore != rhs.minimumWindowScore {return false}
    if lhs.reportTypeWeights != rhs.reportTypeWeights {return false}
    if lhs.unknownFields != rhs.unknownFields {return false}
    return true
  }
}
