// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user_fav_places.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserFavPlaces _$UserFavPlacesFromJson(Map<String, dynamic> json) {
  return _UserFavPlaces.fromJson(json);
}

/// @nodoc
mixin _$UserFavPlaces {
  String get id => throw _privateConstructorUsedError;
  String? get name => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lon => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserFavPlacesCopyWith<UserFavPlaces> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserFavPlacesCopyWith<$Res> {
  factory $UserFavPlacesCopyWith(
          UserFavPlaces value, $Res Function(UserFavPlaces) then) =
      _$UserFavPlacesCopyWithImpl<$Res>;
  $Res call({String id, String? name, double? lat, double? lon, String? image});
}

/// @nodoc
class _$UserFavPlacesCopyWithImpl<$Res>
    implements $UserFavPlacesCopyWith<$Res> {
  _$UserFavPlacesCopyWithImpl(this._value, this._then);

  final UserFavPlaces _value;
  // ignore: unused_field
  final $Res Function(UserFavPlaces) _then;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? image = freezed,
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
    ));
  }
}

/// @nodoc
abstract class _$$_UserFavPlacesCopyWith<$Res>
    implements $UserFavPlacesCopyWith<$Res> {
  factory _$$_UserFavPlacesCopyWith(
          _$_UserFavPlaces value, $Res Function(_$_UserFavPlaces) then) =
      __$$_UserFavPlacesCopyWithImpl<$Res>;
  @override
  $Res call({String id, String? name, double? lat, double? lon, String? image});
}

/// @nodoc
class __$$_UserFavPlacesCopyWithImpl<$Res>
    extends _$UserFavPlacesCopyWithImpl<$Res>
    implements _$$_UserFavPlacesCopyWith<$Res> {
  __$$_UserFavPlacesCopyWithImpl(
      _$_UserFavPlaces _value, $Res Function(_$_UserFavPlaces) _then)
      : super(_value, (v) => _then(v as _$_UserFavPlaces));

  @override
  _$_UserFavPlaces get _value => super._value as _$_UserFavPlaces;

  @override
  $Res call({
    Object? id = freezed,
    Object? name = freezed,
    Object? lat = freezed,
    Object? lon = freezed,
    Object? image = freezed,
  }) {
    return _then(_$_UserFavPlaces(
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
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserFavPlaces implements _UserFavPlaces {
  _$_UserFavPlaces(
      {required this.id, this.name, this.lat, this.lon, this.image});

  factory _$_UserFavPlaces.fromJson(Map<String, dynamic> json) =>
      _$$_UserFavPlacesFromJson(json);

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
  String toString() {
    return 'UserFavPlaces(id: $id, name: $name, lat: $lat, lon: $lon, image: $image)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserFavPlaces &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality().equals(other.lat, lat) &&
            const DeepCollectionEquality().equals(other.lon, lon) &&
            const DeepCollectionEquality().equals(other.image, image));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(id),
      const DeepCollectionEquality().hash(name),
      const DeepCollectionEquality().hash(lat),
      const DeepCollectionEquality().hash(lon),
      const DeepCollectionEquality().hash(image));

  @JsonKey(ignore: true)
  @override
  _$$_UserFavPlacesCopyWith<_$_UserFavPlaces> get copyWith =>
      __$$_UserFavPlacesCopyWithImpl<_$_UserFavPlaces>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserFavPlacesToJson(
      this,
    );
  }
}

abstract class _UserFavPlaces implements UserFavPlaces {
  factory _UserFavPlaces(
      {required final String id,
      final String? name,
      final double? lat,
      final double? lon,
      final String? image}) = _$_UserFavPlaces;

  factory _UserFavPlaces.fromJson(Map<String, dynamic> json) =
      _$_UserFavPlaces.fromJson;

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
  @JsonKey(ignore: true)
  _$$_UserFavPlacesCopyWith<_$_UserFavPlaces> get copyWith =>
      throw _privateConstructorUsedError;
}
