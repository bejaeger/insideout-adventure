// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'quest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Quest _$QuestFromJson(Map<String, dynamic> json) {
  return _Quest.fromJson(json);
}

/// @nodoc
mixin _$Quest {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get description => throw _privateConstructorUsedError;
  QuestType get type => throw _privateConstructorUsedError;
  String? get createdBy => throw _privateConstructorUsedError;
  AFKMarker? get startMarker => throw _privateConstructorUsedError;
  AFKMarker? get finishMarker => throw _privateConstructorUsedError;
  List<AFKMarker> get markers => throw _privateConstructorUsedError;
  List<MarkerNote>? get markerNotes => throw _privateConstructorUsedError;
  num get afkCredits => throw _privateConstructorUsedError;
  String? get networkImagePath => throw _privateConstructorUsedError;
  List<num>? get afkCreditsPerMarker => throw _privateConstructorUsedError;
  num? get bonusAfkCreditsOnSuccess => throw _privateConstructorUsedError;
  double? get distanceFromUser => throw _privateConstructorUsedError;
  double? get distanceToTravelInMeter =>
      throw _privateConstructorUsedError; // for distance estimate
  int get repeatable => throw _privateConstructorUsedError;

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
      String? createdBy,
      AFKMarker? startMarker,
      AFKMarker? finishMarker,
      List<AFKMarker> markers,
      List<MarkerNote>? markerNotes,
      num afkCredits,
      String? networkImagePath,
      List<num>? afkCreditsPerMarker,
      num? bonusAfkCreditsOnSuccess,
      double? distanceFromUser,
      double? distanceToTravelInMeter,
      int repeatable});

  $AFKMarkerCopyWith<$Res>? get startMarker;
  $AFKMarkerCopyWith<$Res>? get finishMarker;
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
    Object? createdBy = freezed,
    Object? startMarker = freezed,
    Object? finishMarker = freezed,
    Object? markers = freezed,
    Object? markerNotes = freezed,
    Object? afkCredits = freezed,
    Object? networkImagePath = freezed,
    Object? afkCreditsPerMarker = freezed,
    Object? bonusAfkCreditsOnSuccess = freezed,
    Object? distanceFromUser = freezed,
    Object? distanceToTravelInMeter = freezed,
    Object? repeatable = freezed,
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
      createdBy: createdBy == freezed
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      startMarker: startMarker == freezed
          ? _value.startMarker
          : startMarker // ignore: cast_nullable_to_non_nullable
              as AFKMarker?,
      finishMarker: finishMarker == freezed
          ? _value.finishMarker
          : finishMarker // ignore: cast_nullable_to_non_nullable
              as AFKMarker?,
      markers: markers == freezed
          ? _value.markers
          : markers // ignore: cast_nullable_to_non_nullable
              as List<AFKMarker>,
      markerNotes: markerNotes == freezed
          ? _value.markerNotes
          : markerNotes // ignore: cast_nullable_to_non_nullable
              as List<MarkerNote>?,
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
      distanceFromUser: distanceFromUser == freezed
          ? _value.distanceFromUser
          : distanceFromUser // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceToTravelInMeter: distanceToTravelInMeter == freezed
          ? _value.distanceToTravelInMeter
          : distanceToTravelInMeter // ignore: cast_nullable_to_non_nullable
              as double?,
      repeatable: repeatable == freezed
          ? _value.repeatable
          : repeatable // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }

  @override
  $AFKMarkerCopyWith<$Res>? get startMarker {
    if (_value.startMarker == null) {
      return null;
    }

    return $AFKMarkerCopyWith<$Res>(_value.startMarker!, (value) {
      return _then(_value.copyWith(startMarker: value));
    });
  }

  @override
  $AFKMarkerCopyWith<$Res>? get finishMarker {
    if (_value.finishMarker == null) {
      return null;
    }

    return $AFKMarkerCopyWith<$Res>(_value.finishMarker!, (value) {
      return _then(_value.copyWith(finishMarker: value));
    });
  }
}

/// @nodoc
abstract class _$$_QuestCopyWith<$Res> implements $QuestCopyWith<$Res> {
  factory _$$_QuestCopyWith(_$_Quest value, $Res Function(_$_Quest) then) =
      __$$_QuestCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String name,
      String description,
      QuestType type,
      String? createdBy,
      AFKMarker? startMarker,
      AFKMarker? finishMarker,
      List<AFKMarker> markers,
      List<MarkerNote>? markerNotes,
      num afkCredits,
      String? networkImagePath,
      List<num>? afkCreditsPerMarker,
      num? bonusAfkCreditsOnSuccess,
      double? distanceFromUser,
      double? distanceToTravelInMeter,
      int repeatable});

  @override
  $AFKMarkerCopyWith<$Res>? get startMarker;
  @override
  $AFKMarkerCopyWith<$Res>? get finishMarker;
}

/// @nodoc
class __$$_QuestCopyWithImpl<$Res> extends _$QuestCopyWithImpl<$Res>
    implements _$$_QuestCopyWith<$Res> {
  __$$_QuestCopyWithImpl(_$_Quest _value, $Res Function(_$_Quest) _then)
      : super(_value, (v) => _then(v as _$_Quest));

  @override
  _$_Quest get _value => super._value as _$_Quest;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? description = freezed,
    Object? type = freezed,
    Object? createdBy = freezed,
    Object? startMarker = freezed,
    Object? finishMarker = freezed,
    Object? markers = freezed,
    Object? markerNotes = freezed,
    Object? afkCredits = freezed,
    Object? networkImagePath = freezed,
    Object? afkCreditsPerMarker = freezed,
    Object? bonusAfkCreditsOnSuccess = freezed,
    Object? distanceFromUser = freezed,
    Object? distanceToTravelInMeter = freezed,
    Object? repeatable = freezed,
  }) {
    return _then(_$_Quest(
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
      createdBy: createdBy == freezed
          ? _value.createdBy
          : createdBy // ignore: cast_nullable_to_non_nullable
              as String?,
      startMarker: startMarker == freezed
          ? _value.startMarker
          : startMarker // ignore: cast_nullable_to_non_nullable
              as AFKMarker?,
      finishMarker: finishMarker == freezed
          ? _value.finishMarker
          : finishMarker // ignore: cast_nullable_to_non_nullable
              as AFKMarker?,
      markers: markers == freezed
          ? _value._markers
          : markers // ignore: cast_nullable_to_non_nullable
              as List<AFKMarker>,
      markerNotes: markerNotes == freezed
          ? _value._markerNotes
          : markerNotes // ignore: cast_nullable_to_non_nullable
              as List<MarkerNote>?,
      afkCredits: afkCredits == freezed
          ? _value.afkCredits
          : afkCredits // ignore: cast_nullable_to_non_nullable
              as num,
      networkImagePath: networkImagePath == freezed
          ? _value.networkImagePath
          : networkImagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      afkCreditsPerMarker: afkCreditsPerMarker == freezed
          ? _value._afkCreditsPerMarker
          : afkCreditsPerMarker // ignore: cast_nullable_to_non_nullable
              as List<num>?,
      bonusAfkCreditsOnSuccess: bonusAfkCreditsOnSuccess == freezed
          ? _value.bonusAfkCreditsOnSuccess
          : bonusAfkCreditsOnSuccess // ignore: cast_nullable_to_non_nullable
              as num?,
      distanceFromUser: distanceFromUser == freezed
          ? _value.distanceFromUser
          : distanceFromUser // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceToTravelInMeter: distanceToTravelInMeter == freezed
          ? _value.distanceToTravelInMeter
          : distanceToTravelInMeter // ignore: cast_nullable_to_non_nullable
              as double?,
      repeatable: repeatable == freezed
          ? _value.repeatable
          : repeatable // ignore: cast_nullable_to_non_nullable
              as int,
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
      this.createdBy,
      this.startMarker,
      this.finishMarker,
      required final List<AFKMarker> markers,
      final List<MarkerNote>? markerNotes,
      required this.afkCredits,
      this.networkImagePath,
      final List<num>? afkCreditsPerMarker,
      this.bonusAfkCreditsOnSuccess,
      this.distanceFromUser,
      this.distanceToTravelInMeter,
      this.repeatable = 0})
      : _markers = markers,
        _markerNotes = markerNotes,
        _afkCreditsPerMarker = afkCreditsPerMarker;

  factory _$_Quest.fromJson(Map<String, dynamic> json) =>
      _$$_QuestFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String description;
  @override
  final QuestType type;
  @override
  final String? createdBy;
  @override
  final AFKMarker? startMarker;
  @override
  final AFKMarker? finishMarker;
  final List<AFKMarker> _markers;
  @override
  List<AFKMarker> get markers {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_markers);
  }

  final List<MarkerNote>? _markerNotes;
  @override
  List<MarkerNote>? get markerNotes {
    final value = _markerNotes;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final num afkCredits;
  @override
  final String? networkImagePath;
  final List<num>? _afkCreditsPerMarker;
  @override
  List<num>? get afkCreditsPerMarker {
    final value = _afkCreditsPerMarker;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final num? bonusAfkCreditsOnSuccess;
  @override
  final double? distanceFromUser;
  @override
  final double? distanceToTravelInMeter;
// for distance estimate
  @override
  @JsonKey()
  final int repeatable;

  @override
  String toString() {
    return 'Quest(id: $id, name: $name, description: $description, type: $type, createdBy: $createdBy, startMarker: $startMarker, finishMarker: $finishMarker, markers: $markers, markerNotes: $markerNotes, afkCredits: $afkCredits, networkImagePath: $networkImagePath, afkCreditsPerMarker: $afkCreditsPerMarker, bonusAfkCreditsOnSuccess: $bonusAfkCreditsOnSuccess, distanceFromUser: $distanceFromUser, distanceToTravelInMeter: $distanceToTravelInMeter, repeatable: $repeatable)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Quest &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.createdBy, createdBy) &&
            const DeepCollectionEquality()
                .equals(other.startMarker, startMarker) &&
            const DeepCollectionEquality()
                .equals(other.finishMarker, finishMarker) &&
            const DeepCollectionEquality().equals(other._markers, _markers) &&
            const DeepCollectionEquality()
                .equals(other._markerNotes, _markerNotes) &&
            const DeepCollectionEquality()
                .equals(other.afkCredits, afkCredits) &&
            const DeepCollectionEquality()
                .equals(other.networkImagePath, networkImagePath) &&
            const DeepCollectionEquality()
                .equals(other._afkCreditsPerMarker, _afkCreditsPerMarker) &&
            const DeepCollectionEquality().equals(
                other.bonusAfkCreditsOnSuccess, bonusAfkCreditsOnSuccess) &&
            const DeepCollectionEquality()
                .equals(other.distanceFromUser, distanceFromUser) &&
            const DeepCollectionEquality().equals(
                other.distanceToTravelInMeter, distanceToTravelInMeter) &&
            const DeepCollectionEquality()
                .equals(other.repeatable, repeatable));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(description),
      const DeepCollectionEquality().hash(type),
      const DeepCollectionEquality().hash(createdBy),
      const DeepCollectionEquality().hash(startMarker),
      const DeepCollectionEquality().hash(finishMarker),
      const DeepCollectionEquality().hash(_markers),
      const DeepCollectionEquality().hash(_markerNotes),
      const DeepCollectionEquality().hash(afkCredits),
      const DeepCollectionEquality().hash(networkImagePath),
      const DeepCollectionEquality().hash(_afkCreditsPerMarker),
      const DeepCollectionEquality().hash(bonusAfkCreditsOnSuccess),
      const DeepCollectionEquality().hash(distanceFromUser),
      const DeepCollectionEquality().hash(distanceToTravelInMeter),
      const DeepCollectionEquality().hash(repeatable));

  @JsonKey(ignore: true)
  @override
  _$$_QuestCopyWith<_$_Quest> get copyWith =>
      __$$_QuestCopyWithImpl<_$_Quest>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_QuestToJson(
      this,
    );
  }
}

abstract class _Quest implements Quest {
  factory _Quest(
      {required final String id,
      required final String name,
      required final String description,
      required final QuestType type,
      final String? createdBy,
      final AFKMarker? startMarker,
      final AFKMarker? finishMarker,
      required final List<AFKMarker> markers,
      final List<MarkerNote>? markerNotes,
      required final num afkCredits,
      final String? networkImagePath,
      final List<num>? afkCreditsPerMarker,
      final num? bonusAfkCreditsOnSuccess,
      final double? distanceFromUser,
      final double? distanceToTravelInMeter,
      final int repeatable}) = _$_Quest;

  factory _Quest.fromJson(Map<String, dynamic> json) = _$_Quest.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get description;
  @override
  QuestType get type;
  @override
  String? get createdBy;
  @override
  AFKMarker? get startMarker;
  @override
  AFKMarker? get finishMarker;
  @override
  List<AFKMarker> get markers;
  @override
  List<MarkerNote>? get markerNotes;
  @override
  num get afkCredits;
  @override
  String? get networkImagePath;
  @override
  List<num>? get afkCreditsPerMarker;
  @override
  num? get bonusAfkCreditsOnSuccess;
  @override
  double? get distanceFromUser;
  @override
  double? get distanceToTravelInMeter;
  @override // for distance estimate
  int get repeatable;
  @override
  @JsonKey(ignore: true)
  _$$_QuestCopyWith<_$_Quest> get copyWith =>
      throw _privateConstructorUsedError;
}
