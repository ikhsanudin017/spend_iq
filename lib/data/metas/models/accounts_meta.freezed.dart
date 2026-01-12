// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'accounts_meta.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

AccountsMeta _$AccountsMetaFromJson(Map<String, dynamic> json) {
  return _AccountsMeta.fromJson(json);
}

/// @nodoc
mixin _$AccountsMeta {
  @HiveField(0)
  String get accountId => throw _privateConstructorUsedError;
  @HiveField(1)
  String get name => throw _privateConstructorUsedError;
  @HiveField(2)
  String get bankName => throw _privateConstructorUsedError;
  @HiveField(3)
  String get accountNumberMasked => throw _privateConstructorUsedError;
  @HiveField(4)
  DateTime get updatedAt => throw _privateConstructorUsedError;

  /// Serializes this AccountsMeta to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of AccountsMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $AccountsMetaCopyWith<AccountsMeta> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $AccountsMetaCopyWith<$Res> {
  factory $AccountsMetaCopyWith(
          AccountsMeta value, $Res Function(AccountsMeta) then) =
      _$AccountsMetaCopyWithImpl<$Res, AccountsMeta>;
  @useResult
  $Res call(
      {@HiveField(0) String accountId,
      @HiveField(1) String name,
      @HiveField(2) String bankName,
      @HiveField(3) String accountNumberMasked,
      @HiveField(4) DateTime updatedAt});
}

/// @nodoc
class _$AccountsMetaCopyWithImpl<$Res, $Val extends AccountsMeta>
    implements $AccountsMetaCopyWith<$Res> {
  _$AccountsMetaCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of AccountsMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? name = null,
    Object? bankName = null,
    Object? accountNumberMasked = null,
    Object? updatedAt = null,
  }) {
    return _then(_value.copyWith(
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: null == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      accountNumberMasked: null == accountNumberMasked
          ? _value.accountNumberMasked
          : accountNumberMasked // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$AccountsMetaImplCopyWith<$Res>
    implements $AccountsMetaCopyWith<$Res> {
  factory _$$AccountsMetaImplCopyWith(
          _$AccountsMetaImpl value, $Res Function(_$AccountsMetaImpl) then) =
      __$$AccountsMetaImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@HiveField(0) String accountId,
      @HiveField(1) String name,
      @HiveField(2) String bankName,
      @HiveField(3) String accountNumberMasked,
      @HiveField(4) DateTime updatedAt});
}

/// @nodoc
class __$$AccountsMetaImplCopyWithImpl<$Res>
    extends _$AccountsMetaCopyWithImpl<$Res, _$AccountsMetaImpl>
    implements _$$AccountsMetaImplCopyWith<$Res> {
  __$$AccountsMetaImplCopyWithImpl(
      _$AccountsMetaImpl _value, $Res Function(_$AccountsMetaImpl) _then)
      : super(_value, _then);

  /// Create a copy of AccountsMeta
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? accountId = null,
    Object? name = null,
    Object? bankName = null,
    Object? accountNumberMasked = null,
    Object? updatedAt = null,
  }) {
    return _then(_$AccountsMetaImpl(
      accountId: null == accountId
          ? _value.accountId
          : accountId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      bankName: null == bankName
          ? _value.bankName
          : bankName // ignore: cast_nullable_to_non_nullable
              as String,
      accountNumberMasked: null == accountNumberMasked
          ? _value.accountNumberMasked
          : accountNumberMasked // ignore: cast_nullable_to_non_nullable
              as String,
      updatedAt: null == updatedAt
          ? _value.updatedAt
          : updatedAt // ignore: cast_nullable_to_non_nullable
              as DateTime,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$AccountsMetaImpl extends _AccountsMeta {
  const _$AccountsMetaImpl(
      {@HiveField(0) required this.accountId,
      @HiveField(1) required this.name,
      @HiveField(2) required this.bankName,
      @HiveField(3) required this.accountNumberMasked,
      @HiveField(4) required this.updatedAt})
      : super._();

  factory _$AccountsMetaImpl.fromJson(Map<String, dynamic> json) =>
      _$$AccountsMetaImplFromJson(json);

  @override
  @HiveField(0)
  final String accountId;
  @override
  @HiveField(1)
  final String name;
  @override
  @HiveField(2)
  final String bankName;
  @override
  @HiveField(3)
  final String accountNumberMasked;
  @override
  @HiveField(4)
  final DateTime updatedAt;

  @override
  String toString() {
    return 'AccountsMeta(accountId: $accountId, name: $name, bankName: $bankName, accountNumberMasked: $accountNumberMasked, updatedAt: $updatedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$AccountsMetaImpl &&
            (identical(other.accountId, accountId) ||
                other.accountId == accountId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.bankName, bankName) ||
                other.bankName == bankName) &&
            (identical(other.accountNumberMasked, accountNumberMasked) ||
                other.accountNumberMasked == accountNumberMasked) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, accountId, name, bankName, accountNumberMasked, updatedAt);

  /// Create a copy of AccountsMeta
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$AccountsMetaImplCopyWith<_$AccountsMetaImpl> get copyWith =>
      __$$AccountsMetaImplCopyWithImpl<_$AccountsMetaImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$AccountsMetaImplToJson(
      this,
    );
  }
}

abstract class _AccountsMeta extends AccountsMeta {
  const factory _AccountsMeta(
      {@HiveField(0) required final String accountId,
      @HiveField(1) required final String name,
      @HiveField(2) required final String bankName,
      @HiveField(3) required final String accountNumberMasked,
      @HiveField(4) required final DateTime updatedAt}) = _$AccountsMetaImpl;
  const _AccountsMeta._() : super._();

  factory _AccountsMeta.fromJson(Map<String, dynamic> json) =
      _$AccountsMetaImpl.fromJson;

  @override
  @HiveField(0)
  String get accountId;
  @override
  @HiveField(1)
  String get name;
  @override
  @HiveField(2)
  String get bankName;
  @override
  @HiveField(3)
  String get accountNumberMasked;
  @override
  @HiveField(4)
  DateTime get updatedAt;

  /// Create a copy of AccountsMeta
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$AccountsMetaImplCopyWith<_$AccountsMetaImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
