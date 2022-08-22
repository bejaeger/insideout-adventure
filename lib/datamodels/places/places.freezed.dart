// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'places.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Places _$PlacesFromJson(Map<String, dynamic> json) {
  return _Places.fromJson(json);
}

/// @nodoc
mixin _$Places {
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lon => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;
  String? get questId => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PlacesCopyWith<Places> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PlacesCopyWith<$Res> {
  factory $PlacesCopyWith(Places value, $Res Function(Places) then) =
      _$PlacesCopyWithImpl<$Res>;
  $Res call(
      {String id,
      String? name,
      double? lat,
      double? lon,
      String? image,
      String? questId});
}

/// @nodoc
class _$PlacesCopyWithImpl<$Res> implements $PlacesCopyWith<$Res> {
  _$PlacesCopyWithImpl(this._value, this._then);

  final Places _value;
  // ignore: unused_field
  final $Res Function(Places) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? image = freezed,
    Object? questId = freezed,
  }) {
    return _then(_value.copyWith(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: lat == freezed
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: lon == freezed
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      questId: questId == freezed
          ? _value.questId
          : questId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_PlacesCopyWith<$Res> implements $PlacesCopyWith<$Res> {
  factory _$$_PlacesCopyWith(_$_Places value, $Res Function(_$_Places) then) =
      __$$_PlacesCopyWithImpl<$Res>;
  @override
  $Res call(
      {String id,
      String? name,
      double? lat,
      double? lon,
      String? image,
      String? questId});
}

/// @nodoc
class __$$_PlacesCopyWithImpl<$Res> extends _$PlacesCopyWithImpl<$Res>
    implements _$$_PlacesCopyWith<$Res> {
  __$$_PlacesCopyWithImpl(_$_Places _value, $Res Function(_$_Places) _then)
      : super(_value, (v) => _then(v as _$_Places));

  @override
  _$_Places get _value => super._value as _$_Places;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? image = freezed,
    Object? questId = freezed,
  }) {
    return _then(_$_Places(
      id: id == freezed
          ? _value.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      name: name == freezed
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: lat == freezed
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lon: lon == freezed
          ? _value.lon
          : lon // ignore: cast_nullable_to_non_nullable
              as double?,
      image: image == freezed
          ? _value.image
          : image // ignore: cast_nullable_to_non_nullable
              as String?,
      questId: questId == freezed
          ? _value.questId
          : questId // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Places implements _Places {
  _$_Places(
      {required this.id,
      this.name,
      this.lat,
      this.lon,
      this.image,
      this.questId});

  factory _$_Places.fromJson(Map<String, dynamic> json) =>
      _$$_PlacesFromJson(json);

  @override
  final String id;
  @override
  final String? name;
  @override
  final double? lat;
  @override
  final double? lon;
  @override
  final String? image;
  @override
  final String? questId;

  @override
  String toString() {
    return 'Places(id: $id, name: $name, lat: $lat, lon: $lon, image: $image, questId: $questId)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Places &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.lat, lat) &&
            const DeepCollectionEquality().equals(other.lon, lon) &&
            const DeepCollectionEquality().equals(other.image, image) &&
            const DeepCollectionEquality().equals(other.questId, questId));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(lat),
      const DeepCollectionEquality().hash(lon),
      const DeepCollectionEquality().hash(image),
      const DeepCollectionEquality().hash(questId));

  @JsonKey(ignore: true)
  @override
  _$$_PlacesCopyWith<_$_Places> get copyWith =>
      __$$_PlacesCopyWithImpl<_$_Places>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_PlacesToJson(
      this,
    );
  }
}

abstract class _Places implements Places {
  factory _Places(
      {required final String id,
      final String? name,
      final double? lat,
      final double? lon,
      final String? image,
      final String? questId}) = _$_Places;

  factory _Places.fromJson(Map<String, dynamic> json) = _$_Places.fromJson;

  @override
  String get id;
  @override
  String? get name;
  @override
  double? get lat;
  @override
  double? get lon;
  @override
  String? get image;
  @override
  String? get questId;
  @override
  @JsonKey(ignore: true)
  _$$_PlacesCopyWith<_$_Places> get copyWith =>
      throw _privateConstructorUsedError;
}
