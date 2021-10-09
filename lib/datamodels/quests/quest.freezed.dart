// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'quest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Quest _$QuestFromJson(Map<String, dynamic> json) {
  return _Quest.fromJson(json);
}

/// @nodoc
class _$QuestTearOff {
  const _$QuestTearOff();

  _Quest call(
      {required String id,
      required String name,
      required String description,
      required QuestType type,
      required AFKMarker startMarker,
      required AFKMarker finishMarker,
      required List<AFKMarker> markers,
      required num afkCredits,
      String? networkImagePath,
      List<num>? afkCreditsPerMarker,
      num? bonusAfkCreditsOnSuccess}) {
    return _Quest(
      id: id,
      name: name,
      description: description,
      type: type,
      startMarker: startMarker,
      finishMarker: finishMarker,
      markers: markers,
      afkCredits: afkCredits,
      networkImagePath: networkImagePath,
      afkCreditsPerMarker: afkCreditsPerMarker,
      bonusAfkCreditsOnSuccess: bonusAfkCreditsOnSuccess,
    );
  }

  Quest fromJson(Map<String, Object> json) {
    return Quest.fromJson(json);
  }
}

/// @nodoc
const $Quest = _$QuestTearOff();

/// @nodoc
mixin _$Quest {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  QuestType get type => throw _privateConstructorUsedError;
  AFKMarker get startMarker => throw _privateConstructorUsedError;
  AFKMarker get finishMarker => throw _privateConstructorUsedError;
  List<AFKMarker> get markers => throw _privateConstructorUsedError;
  num get afkCredits => throw _privateConstructorUsedError;
  String? get networkImagePath => throw _privateConstructorUsedError;
  List<num>? get afkCreditsPerMarker => throw _privateConstructorUsedError;
  num? get bonusAfkCreditsOnSuccess => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $QuestCopyWith<Quest> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $QuestCopyWith<$Res> {
  factory $QuestCopyWith(Quest value, $Res Function(Quest) then) =
      _$QuestCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String name,
      String description,
      QuestType type,
      AFKMarker startMarker,
      AFKMarker finishMarker,
      List<AFKMarker> markers,
      num afkCredits,
      String? networkImagePath,
      List<num>? afkCreditsPerMarker,
      num? bonusAfkCreditsOnSuccess});

  $AFKMarkerCopyWith<$Res> get startMarker;
  $AFKMarkerCopyWith<$Res> get finishMarker;
}

/// @nodoc
class _$QuestCopyWithImpl<$Res> implements $QuestCopyWith<$Res> {
  _$QuestCopyWithImpl(this._value, this._then);

  final Quest _value;
  // ignore: unused_field
  final $Res Function(Quest) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? type = freezed,
    Object? startMarker = freezed,
    Object? finishMarker = freezed,
    Object? markers = freezed,
    Object? afkCredits = freezed,
    Object? networkImagePath = freezed,
    Object? afkCreditsPerMarker = freezed,
    Object? bonusAfkCreditsOnSuccess = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as QuestType,
      startMarker: startMarker == freezed
          ? _value.startMarker
          : startMarker // ignore: cast_nullable_to_non_nullable
              as AFKMarker,
      finishMarker: finishMarker == freezed
          ? _value.finishMarker
          : finishMarker // ignore: cast_nullable_to_non_nullable
              as AFKMarker,
      markers: markers == freezed
          ? _value.markers
          : markers // ignore: cast_nullable_to_non_nullable
              as List<AFKMarker>,
      afkCredits: afkCredits == freezed
          ? _value.afkCredits
          : afkCredits // ignore: cast_nullable_to_non_nullable
              as num,
      networkImagePath: networkImagePath == freezed
          ? _value.networkImagePath
          : networkImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      afkCreditsPerMarker: afkCreditsPerMarker == freezed
          ? _value.afkCreditsPerMarker
          : afkCreditsPerMarker // ignore: cast_nullable_to_non_nullable
              as List<num>?,
      bonusAfkCreditsOnSuccess: bonusAfkCreditsOnSuccess == freezed
          ? _value.bonusAfkCreditsOnSuccess
          : bonusAfkCreditsOnSuccess // ignore: cast_nullable_to_non_nullable
              as num?,
    ));
  }

  @override
  $AFKMarkerCopyWith<$Res> get startMarker {
    return $AFKMarkerCopyWith<$Res>(_value.startMarker, (value) {
      return _then(_value.copyWith(startMarker: value));
    });
  }

  @override
  $AFKMarkerCopyWith<$Res> get finishMarker {
    return $AFKMarkerCopyWith<$Res>(_value.finishMarker, (value) {
      return _then(_value.copyWith(finishMarker: value));
    });
  }
}

/// @nodoc
abstract class _$QuestCopyWith<$Res> implements $QuestCopyWith<$Res> {
  factory _$QuestCopyWith(_Quest value, $Res Function(_Quest) then) =
      __$QuestCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String name,
      String description,
      QuestType type,
      AFKMarker startMarker,
      AFKMarker finishMarker,
      List<AFKMarker> markers,
      num afkCredits,
      String? networkImagePath,
      List<num>? afkCreditsPerMarker,
      num? bonusAfkCreditsOnSuccess});

  @override
  $AFKMarkerCopyWith<$Res> get startMarker;
  @override
  $AFKMarkerCopyWith<$Res> get finishMarker;
}

/// @nodoc
class __$QuestCopyWithImpl<$Res> extends _$QuestCopyWithImpl<$Res>
    implements _$QuestCopyWith<$Res> {
  __$QuestCopyWithImpl(_Quest _value, $Res Function(_Quest) _then)
      : super(_value, (v) => _then(v as _Quest));

  @override
  _Quest get _value => super._value as _Quest;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? type = freezed,
    Object? startMarker = freezed,
    Object? finishMarker = freezed,
    Object? markers = freezed,
    Object? afkCredits = freezed,
    Object? networkImagePath = freezed,
    Object? afkCreditsPerMarker = freezed,
    Object? bonusAfkCreditsOnSuccess = freezed,
  }) {
    return _then(_Quest(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      description: description == freezed
          ? _value.description
          : description // ignore: cast_nullable_to_non_nullable
              as String,
      type: type == freezed
          ? _value.type
          : type // ignore: cast_nullable_to_non_nullable
              as QuestType,
      startMarker: startMarker == freezed
          ? _value.startMarker
          : startMarker // ignore: cast_nullable_to_non_nullable
              as AFKMarker,
      finishMarker: finishMarker == freezed
          ? _value.finishMarker
          : finishMarker // ignore: cast_nullable_to_non_nullable
              as AFKMarker,
      markers: markers == freezed
          ? _value.markers
          : markers // ignore: cast_nullable_to_non_nullable
              as List<AFKMarker>,
      afkCredits: afkCredits == freezed
          ? _value.afkCredits
          : afkCredits // ignore: cast_nullable_to_non_nullable
              as num,
      networkImagePath: networkImagePath == freezed
          ? _value.networkImagePath
          : networkImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      afkCreditsPerMarker: afkCreditsPerMarker == freezed
          ? _value.afkCreditsPerMarker
          : afkCreditsPerMarker // ignore: cast_nullable_to_non_nullable
              as List<num>?,
      bonusAfkCreditsOnSuccess: bonusAfkCreditsOnSuccess == freezed
          ? _value.bonusAfkCreditsOnSuccess
          : bonusAfkCreditsOnSuccess // ignore: cast_nullable_to_non_nullable
              as num?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_Quest implements _Quest {
  _$_Quest(
      {required this.id,
      required this.name,
      required this.description,
      required this.type,
      required this.startMarker,
      required this.finishMarker,
      required this.markers,
      required this.afkCredits,
      this.networkImagePath,
      this.afkCreditsPerMarker,
      this.bonusAfkCreditsOnSuccess});

  factory _$_Quest.fromJson(Map<String, dynamic> json) =>
      _$_$_QuestFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final QuestType type;
  @override
  final AFKMarker startMarker;
  @override
  final AFKMarker finishMarker;
  @override
  final List<AFKMarker> markers;
  @override
  final num afkCredits;
  @override
  final String? networkImagePath;
  @override
  final List<num>? afkCreditsPerMarker;
  @override
  final num? bonusAfkCreditsOnSuccess;

  @override
  String toString() {
    return 'Quest(id: $id, name: $name, description: $description, type: $type, startMarker: $startMarker, finishMarker: $finishMarker, markers: $markers, afkCredits: $afkCredits, networkImagePath: $networkImagePath, afkCreditsPerMarker: $afkCreditsPerMarker, bonusAfkCreditsOnSuccess: $bonusAfkCreditsOnSuccess)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _Quest &&
            (identical(other.id, id) ||
                const DeepCollectionEquality().equals(other.id, id)) &&
            (identical(other.name, name) ||
                const DeepCollectionEquality().equals(other.name, name)) &&
            (identical(other.description, description) ||
                const DeepCollectionEquality()
                    .equals(other.description, description)) &&
            (identical(other.type, type) ||
                const DeepCollectionEquality().equals(other.type, type)) &&
            (identical(other.startMarker, startMarker) ||
                const DeepCollectionEquality()
                    .equals(other.startMarker, startMarker)) &&
            (identical(other.finishMarker, finishMarker) ||
                const DeepCollectionEquality()
                    .equals(other.finishMarker, finishMarker)) &&
            (identical(other.markers, markers) ||
                const DeepCollectionEquality()
                    .equals(other.markers, markers)) &&
            (identical(other.afkCredits, afkCredits) ||
                const DeepCollectionEquality()
                    .equals(other.afkCredits, afkCredits)) &&
            (identical(other.networkImagePath, networkImagePath) ||
                const DeepCollectionEquality()
                    .equals(other.networkImagePath, networkImagePath)) &&
            (identical(other.afkCreditsPerMarker, afkCreditsPerMarker) ||
                const DeepCollectionEquality()
                    .equals(other.afkCreditsPerMarker, afkCreditsPerMarker)) &&
            (identical(
                    other.bonusAfkCreditsOnSuccess, bonusAfkCreditsOnSuccess) ||
                const DeepCollectionEquality().equals(
                    other.bonusAfkCreditsOnSuccess, bonusAfkCreditsOnSuccess)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(id) ^
      const DeepCollectionEquality().hash(name) ^
      const DeepCollectionEquality().hash(description) ^
      const DeepCollectionEquality().hash(type) ^
      const DeepCollectionEquality().hash(startMarker) ^
      const DeepCollectionEquality().hash(finishMarker) ^
      const DeepCollectionEquality().hash(markers) ^
      const DeepCollectionEquality().hash(afkCredits) ^
      const DeepCollectionEquality().hash(networkImagePath) ^
      const DeepCollectionEquality().hash(afkCreditsPerMarker) ^
      const DeepCollectionEquality().hash(bonusAfkCreditsOnSuccess);

  @JsonKey(ignore: true)
  @override
  _$QuestCopyWith<_Quest> get copyWith =>
      __$QuestCopyWithImpl<_Quest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_QuestToJson(this);
  }
}

abstract class _Quest implements Quest {
  factory _Quest(
      {required String id,
      required String name,
      required String description,
      required QuestType type,
      required AFKMarker startMarker,
      required AFKMarker finishMarker,
      required List<AFKMarker> markers,
      required num afkCredits,
      String? networkImagePath,
      List<num>? afkCreditsPerMarker,
      num? bonusAfkCreditsOnSuccess}) = _$_Quest;

  factory _Quest.fromJson(Map<String, dynamic> json) = _$_Quest.fromJson;

  @override
  String get id => throw _privateConstructorUsedError;
  @override
  String get name => throw _privateConstructorUsedError;
  @override
  String get description => throw _privateConstructorUsedError;
  @override
  QuestType get type => throw _privateConstructorUsedError;
  @override
  AFKMarker get startMarker => throw _privateConstructorUsedError;
  @override
  AFKMarker get finishMarker => throw _privateConstructorUsedError;
  @override
  List<AFKMarker> get markers => throw _privateConstructorUsedError;
  @override
  num get afkCredits => throw _privateConstructorUsedError;
  @override
  String? get networkImagePath => throw _privateConstructorUsedError;
  @override
  List<num>? get afkCreditsPerMarker => throw _privateConstructorUsedError;
  @override
  num? get bonusAfkCreditsOnSuccess => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$QuestCopyWith<_Quest> get copyWith => throw _privateConstructorUsedError;
}
