// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
class _$UserTearOff {
  const _$UserTearOff();

  _User call(
      {required String uid,
      required String fullName,
      required String email,
      required List<String> sponsorIds,
      required List<String> explorerIds,
      required UserRole role,
      bool newUser = false,
      @JsonKey(toJson: User._checkIfKeywordsAreSet)
          List<String>? fullNameSearch}) {
    return _User(
      uid: uid,
      fullName: fullName,
      email: email,
      sponsorIds: sponsorIds,
      explorerIds: explorerIds,
      role: role,
      newUser: newUser,
      fullNameSearch: fullNameSearch,
    );
  }

  User fromJson(Map<String, Object> json) {
    return User.fromJson(json);
  }
}

/// @nodoc
const $User = _$UserTearOff();

/// @nodoc
mixin _$User {
  String get uid => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String get email => throw _privateConstructorUsedError;
  List<String> get sponsorIds => throw _privateConstructorUsedError;
  List<String> get explorerIds => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;
  bool get newUser => throw _privateConstructorUsedError;
  @JsonKey(toJson: User._checkIfKeywordsAreSet)
  List<String>? get fullNameSearch => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserCopyWith<User> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserCopyWith<$Res> {
  factory $UserCopyWith(User value, $Res Function(User) then) =
      _$UserCopyWithImpl<$Res>;
  $Res call(
      {String uid,
      String fullName,
      String email,
      List<String> sponsorIds,
      List<String> explorerIds,
      UserRole role,
      bool newUser,
      @JsonKey(toJson: User._checkIfKeywordsAreSet)
          List<String>? fullNameSearch});
}

/// @nodoc
class _$UserCopyWithImpl<$Res> implements $UserCopyWith<$Res> {
  _$UserCopyWithImpl(this._value, this._then);

  final User _value;
  // ignore: unused_field
  final $Res Function(User) _then;

  @override
  $Res call({
    Object? uid = freezed,
    Object? fullName = freezed,
    Object? email = freezed,
    Object? sponsorIds = freezed,
    Object? explorerIds = freezed,
    Object? role = freezed,
    Object? newUser = freezed,
    Object? fullNameSearch = freezed,
  }) {
    return _then(_value.copyWith(
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: fullName == freezed
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      sponsorIds: sponsorIds == freezed
          ? _value.sponsorIds
          : sponsorIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      explorerIds: explorerIds == freezed
          ? _value.explorerIds
          : explorerIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      role: role == freezed
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      newUser: newUser == freezed
          ? _value.newUser
          : newUser // ignore: cast_nullable_to_non_nullable
              as bool,
      fullNameSearch: fullNameSearch == freezed
          ? _value.fullNameSearch
          : fullNameSearch // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
abstract class _$UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$UserCopyWith(_User value, $Res Function(_User) then) =
      __$UserCopyWithImpl<$Res>;
  @override
  $Res call(
      {String uid,
      String fullName,
      String email,
      List<String> sponsorIds,
      List<String> explorerIds,
      UserRole role,
      bool newUser,
      @JsonKey(toJson: User._checkIfKeywordsAreSet)
          List<String>? fullNameSearch});
}

/// @nodoc
class __$UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res>
    implements _$UserCopyWith<$Res> {
  __$UserCopyWithImpl(_User _value, $Res Function(_User) _then)
      : super(_value, (v) => _then(v as _User));

  @override
  _User get _value => super._value as _User;

  @override
  $Res call({
    Object? uid = freezed,
    Object? fullName = freezed,
    Object? email = freezed,
    Object? sponsorIds = freezed,
    Object? explorerIds = freezed,
    Object? role = freezed,
    Object? newUser = freezed,
    Object? fullNameSearch = freezed,
  }) {
    return _then(_User(
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      fullName: fullName == freezed
          ? _value.fullName
          : fullName // ignore: cast_nullable_to_non_nullable
              as String,
      email: email == freezed
          ? _value.email
          : email // ignore: cast_nullable_to_non_nullable
              as String,
      sponsorIds: sponsorIds == freezed
          ? _value.sponsorIds
          : sponsorIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      explorerIds: explorerIds == freezed
          ? _value.explorerIds
          : explorerIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      role: role == freezed
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      newUser: newUser == freezed
          ? _value.newUser
          : newUser // ignore: cast_nullable_to_non_nullable
              as bool,
      fullNameSearch: fullNameSearch == freezed
          ? _value.fullNameSearch
          : fullNameSearch // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_User implements _User {
  _$_User(
      {required this.uid,
      required this.fullName,
      required this.email,
      required this.sponsorIds,
      required this.explorerIds,
      required this.role,
      this.newUser = false,
      @JsonKey(toJson: User._checkIfKeywordsAreSet) this.fullNameSearch});

  factory _$_User.fromJson(Map<String, dynamic> json) =>
      _$_$_UserFromJson(json);

  @override
  final String uid;
  @override
  final String fullName;
  @override
  final String email;
  @override
  final List<String> sponsorIds;
  @override
  final List<String> explorerIds;
  @override
  final UserRole role;
  @JsonKey(defaultValue: false)
  @override
  final bool newUser;
  @override
  @JsonKey(toJson: User._checkIfKeywordsAreSet)
  final List<String>? fullNameSearch;

  @override
  String toString() {
    return 'User(uid: $uid, fullName: $fullName, email: $email, sponsorIds: $sponsorIds, explorerIds: $explorerIds, role: $role, newUser: $newUser, fullNameSearch: $fullNameSearch)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _User &&
            (identical(other.uid, uid) ||
                const DeepCollectionEquality().equals(other.uid, uid)) &&
            (identical(other.fullName, fullName) ||
                const DeepCollectionEquality()
                    .equals(other.fullName, fullName)) &&
            (identical(other.email, email) ||
                const DeepCollectionEquality().equals(other.email, email)) &&
            (identical(other.sponsorIds, sponsorIds) ||
                const DeepCollectionEquality()
                    .equals(other.sponsorIds, sponsorIds)) &&
            (identical(other.explorerIds, explorerIds) ||
                const DeepCollectionEquality()
                    .equals(other.explorerIds, explorerIds)) &&
            (identical(other.role, role) ||
                const DeepCollectionEquality().equals(other.role, role)) &&
            (identical(other.newUser, newUser) ||
                const DeepCollectionEquality()
                    .equals(other.newUser, newUser)) &&
            (identical(other.fullNameSearch, fullNameSearch) ||
                const DeepCollectionEquality()
                    .equals(other.fullNameSearch, fullNameSearch)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(uid) ^
      const DeepCollectionEquality().hash(fullName) ^
      const DeepCollectionEquality().hash(email) ^
      const DeepCollectionEquality().hash(sponsorIds) ^
      const DeepCollectionEquality().hash(explorerIds) ^
      const DeepCollectionEquality().hash(role) ^
      const DeepCollectionEquality().hash(newUser) ^
      const DeepCollectionEquality().hash(fullNameSearch);

  @JsonKey(ignore: true)
  @override
  _$UserCopyWith<_User> get copyWith =>
      __$UserCopyWithImpl<_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$_$_UserToJson(this);
  }
}

abstract class _User implements User {
  factory _User(
      {required String uid,
      required String fullName,
      required String email,
      required List<String> sponsorIds,
      required List<String> explorerIds,
      required UserRole role,
      bool newUser,
      @JsonKey(toJson: User._checkIfKeywordsAreSet)
          List<String>? fullNameSearch}) = _$_User;

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  String get uid => throw _privateConstructorUsedError;
  @override
  String get fullName => throw _privateConstructorUsedError;
  @override
  String get email => throw _privateConstructorUsedError;
  @override
  List<String> get sponsorIds => throw _privateConstructorUsedError;
  @override
  List<String> get explorerIds => throw _privateConstructorUsedError;
  @override
  UserRole get role => throw _privateConstructorUsedError;
  @override
  bool get newUser => throw _privateConstructorUsedError;
  @override
  @JsonKey(toJson: User._checkIfKeywordsAreSet)
  List<String>? get fullNameSearch => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$UserCopyWith<_User> get copyWith => throw _privateConstructorUsedError;
}
