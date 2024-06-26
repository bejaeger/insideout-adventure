// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

User _$UserFromJson(Map<String, dynamic> json) {
  return _User.fromJson(json);
}

/// @nodoc
mixin _$User {
  String get uid => throw _privateConstructorUsedError;
  String get fullName => throw _privateConstructorUsedError;
  String? get email => throw _privateConstructorUsedError;
  List<String> get guardianIds => throw _privateConstructorUsedError;
  List<String> get wardIds => throw _privateConstructorUsedError;
  UserRole get role => throw _privateConstructorUsedError;
  UserSettings? get userSettings => throw _privateConstructorUsedError;
  AuthenticationMethod? get authMethod => throw _privateConstructorUsedError;
  bool get newUser => throw _privateConstructorUsedError;
  @JsonKey(toJson: User._checkIfKeywordsAreSet)
  List<String>? get fullNameSearch => throw _privateConstructorUsedError;
  String? get createdByUserWithId => throw _privateConstructorUsedError;
  String? get password => throw _privateConstructorUsedError;
  List<String>? get tokens => throw _privateConstructorUsedError;
  String? get deviceId => throw _privateConstructorUsedError;
  int? get avatarIdx => throw _privateConstructorUsedError;
  GuardianVerificationStatus? get guardianVerificationStatus =>
      throw _privateConstructorUsedError;

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
      String? email,
      List<String> guardianIds,
      List<String> wardIds,
      UserRole role,
      UserSettings? userSettings,
      AuthenticationMethod? authMethod,
      bool newUser,
      @JsonKey(toJson: User._checkIfKeywordsAreSet)
          List<String>? fullNameSearch,
      String? createdByUserWithId,
      String? password,
      List<String>? tokens,
      String? deviceId,
      int? avatarIdx,
      GuardianVerificationStatus? guardianVerificationStatus});

  $UserSettingsCopyWith<$Res>? get userSettings;
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
    Object? guardianIds = freezed,
    Object? wardIds = freezed,
    Object? role = freezed,
    Object? userSettings = freezed,
    Object? authMethod = freezed,
    Object? newUser = freezed,
    Object? fullNameSearch = freezed,
    Object? createdByUserWithId = freezed,
    Object? password = freezed,
    Object? tokens = freezed,
    Object? deviceId = freezed,
    Object? avatarIdx = freezed,
    Object? guardianVerificationStatus = freezed,
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
              as String?,
      guardianIds: guardianIds == freezed
          ? _value.guardianIds
          : guardianIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      wardIds: wardIds == freezed
          ? _value.wardIds
          : wardIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      role: role == freezed
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      userSettings: userSettings == freezed
          ? _value.userSettings
          : userSettings // ignore: cast_nullable_to_non_nullable
              as UserSettings?,
      authMethod: authMethod == freezed
          ? _value.authMethod
          : authMethod // ignore: cast_nullable_to_non_nullable
              as AuthenticationMethod?,
      newUser: newUser == freezed
          ? _value.newUser
          : newUser // ignore: cast_nullable_to_non_nullable
              as bool,
      fullNameSearch: fullNameSearch == freezed
          ? _value.fullNameSearch
          : fullNameSearch // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdByUserWithId: createdByUserWithId == freezed
          ? _value.createdByUserWithId
          : createdByUserWithId // ignore: cast_nullable_to_non_nullable
              as String?,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      tokens: tokens == freezed
          ? _value.tokens
          : tokens // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      deviceId: deviceId == freezed
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarIdx: avatarIdx == freezed
          ? _value.avatarIdx
          : avatarIdx // ignore: cast_nullable_to_non_nullable
              as int?,
      guardianVerificationStatus: guardianVerificationStatus == freezed
          ? _value.guardianVerificationStatus
          : guardianVerificationStatus // ignore: cast_nullable_to_non_nullable
              as GuardianVerificationStatus?,
    ));
  }

  @override
  $UserSettingsCopyWith<$Res>? get userSettings {
    if (_value.userSettings == null) {
      return null;
    }

    return $UserSettingsCopyWith<$Res>(_value.userSettings!, (value) {
      return _then(_value.copyWith(userSettings: value));
    });
  }
}

/// @nodoc
abstract class _$$_UserCopyWith<$Res> implements $UserCopyWith<$Res> {
  factory _$$_UserCopyWith(_$_User value, $Res Function(_$_User) then) =
      __$$_UserCopyWithImpl<$Res>;
  @override
  $Res call(
      {String uid,
      String fullName,
      String? email,
      List<String> guardianIds,
      List<String> wardIds,
      UserRole role,
      UserSettings? userSettings,
      AuthenticationMethod? authMethod,
      bool newUser,
      @JsonKey(toJson: User._checkIfKeywordsAreSet)
          List<String>? fullNameSearch,
      String? createdByUserWithId,
      String? password,
      List<String>? tokens,
      String? deviceId,
      int? avatarIdx,
      GuardianVerificationStatus? guardianVerificationStatus});

  @override
  $UserSettingsCopyWith<$Res>? get userSettings;
}

/// @nodoc
class __$$_UserCopyWithImpl<$Res> extends _$UserCopyWithImpl<$Res>
    implements _$$_UserCopyWith<$Res> {
  __$$_UserCopyWithImpl(_$_User _value, $Res Function(_$_User) _then)
      : super(_value, (v) => _then(v as _$_User));

  @override
  _$_User get _value => super._value as _$_User;

  @override
  $Res call({
    Object? uid = freezed,
    Object? fullName = freezed,
    Object? email = freezed,
    Object? guardianIds = freezed,
    Object? wardIds = freezed,
    Object? role = freezed,
    Object? userSettings = freezed,
    Object? authMethod = freezed,
    Object? newUser = freezed,
    Object? fullNameSearch = freezed,
    Object? createdByUserWithId = freezed,
    Object? password = freezed,
    Object? tokens = freezed,
    Object? deviceId = freezed,
    Object? avatarIdx = freezed,
    Object? guardianVerificationStatus = freezed,
  }) {
    return _then(_$_User(
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
              as String?,
      guardianIds: guardianIds == freezed
          ? _value._guardianIds
          : guardianIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      wardIds: wardIds == freezed
          ? _value._wardIds
          : wardIds // ignore: cast_nullable_to_non_nullable
              as List<String>,
      role: role == freezed
          ? _value.role
          : role // ignore: cast_nullable_to_non_nullable
              as UserRole,
      userSettings: userSettings == freezed
          ? _value.userSettings
          : userSettings // ignore: cast_nullable_to_non_nullable
              as UserSettings?,
      authMethod: authMethod == freezed
          ? _value.authMethod
          : authMethod // ignore: cast_nullable_to_non_nullable
              as AuthenticationMethod?,
      newUser: newUser == freezed
          ? _value.newUser
          : newUser // ignore: cast_nullable_to_non_nullable
              as bool,
      fullNameSearch: fullNameSearch == freezed
          ? _value._fullNameSearch
          : fullNameSearch // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      createdByUserWithId: createdByUserWithId == freezed
          ? _value.createdByUserWithId
          : createdByUserWithId // ignore: cast_nullable_to_non_nullable
              as String?,
      password: password == freezed
          ? _value.password
          : password // ignore: cast_nullable_to_non_nullable
              as String?,
      tokens: tokens == freezed
          ? _value._tokens
          : tokens // ignore: cast_nullable_to_non_nullable
              as List<String>?,
      deviceId: deviceId == freezed
          ? _value.deviceId
          : deviceId // ignore: cast_nullable_to_non_nullable
              as String?,
      avatarIdx: avatarIdx == freezed
          ? _value.avatarIdx
          : avatarIdx // ignore: cast_nullable_to_non_nullable
              as int?,
      guardianVerificationStatus: guardianVerificationStatus == freezed
          ? _value.guardianVerificationStatus
          : guardianVerificationStatus // ignore: cast_nullable_to_non_nullable
              as GuardianVerificationStatus?,
    ));
  }
}

/// @nodoc

@JsonSerializable(explicitToJson: true)
class _$_User implements _User {
  _$_User(
      {required this.uid,
      required this.fullName,
      this.email,
      required final List<String> guardianIds,
      required final List<String> wardIds,
      required this.role,
      this.userSettings,
      this.authMethod,
      this.newUser = true,
      @JsonKey(toJson: User._checkIfKeywordsAreSet)
          final List<String>? fullNameSearch,
      this.createdByUserWithId,
      this.password,
      final List<String>? tokens,
      this.deviceId,
      this.avatarIdx = 1,
      this.guardianVerificationStatus})
      : _guardianIds = guardianIds,
        _wardIds = wardIds,
        _fullNameSearch = fullNameSearch,
        _tokens = tokens;

  factory _$_User.fromJson(Map<String, dynamic> json) => _$$_UserFromJson(json);

  @override
  final String uid;
  @override
  final String fullName;
  @override
  final String? email;
  final List<String> _guardianIds;
  @override
  List<String> get guardianIds {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_guardianIds);
  }

  final List<String> _wardIds;
  @override
  List<String> get wardIds {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_wardIds);
  }

  @override
  final UserRole role;
  @override
  final UserSettings? userSettings;
  @override
  final AuthenticationMethod? authMethod;
  @override
  @JsonKey()
  final bool newUser;
  final List<String>? _fullNameSearch;
  @override
  @JsonKey(toJson: User._checkIfKeywordsAreSet)
  List<String>? get fullNameSearch {
    final value = _fullNameSearch;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? createdByUserWithId;
  @override
  final String? password;
  final List<String>? _tokens;
  @override
  List<String>? get tokens {
    final value = _tokens;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  final String? deviceId;
  @override
  @JsonKey()
  final int? avatarIdx;
  @override
  final GuardianVerificationStatus? guardianVerificationStatus;

  @override
  String toString() {
    return 'User(uid: $uid, fullName: $fullName, email: $email, guardianIds: $guardianIds, wardIds: $wardIds, role: $role, userSettings: $userSettings, authMethod: $authMethod, newUser: $newUser, fullNameSearch: $fullNameSearch, createdByUserWithId: $createdByUserWithId, password: $password, tokens: $tokens, deviceId: $deviceId, avatarIdx: $avatarIdx, guardianVerificationStatus: $guardianVerificationStatus)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_User &&
            const DeepCollectionEquality().equals(other.uid, uid) &&
            const DeepCollectionEquality().equals(other.fullName, fullName) &&
            const DeepCollectionEquality().equals(other.email, email) &&
            const DeepCollectionEquality()
                .equals(other._guardianIds, _guardianIds) &&
            const DeepCollectionEquality().equals(other._wardIds, _wardIds) &&
            const DeepCollectionEquality().equals(other.role, role) &&
            const DeepCollectionEquality()
                .equals(other.userSettings, userSettings) &&
            const DeepCollectionEquality()
                .equals(other.authMethod, authMethod) &&
            const DeepCollectionEquality().equals(other.newUser, newUser) &&
            const DeepCollectionEquality()
                .equals(other._fullNameSearch, _fullNameSearch) &&
            const DeepCollectionEquality()
                .equals(other.createdByUserWithId, createdByUserWithId) &&
            const DeepCollectionEquality().equals(other.password, password) &&
            const DeepCollectionEquality().equals(other._tokens, _tokens) &&
            const DeepCollectionEquality().equals(other.deviceId, deviceId) &&
            const DeepCollectionEquality().equals(other.avatarIdx, avatarIdx) &&
            const DeepCollectionEquality().equals(
                other.guardianVerificationStatus, guardianVerificationStatus));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(uid),
      const DeepCollectionEquality().hash(fullName),
      const DeepCollectionEquality().hash(email),
      const DeepCollectionEquality().hash(_guardianIds),
      const DeepCollectionEquality().hash(_wardIds),
      const DeepCollectionEquality().hash(role),
      const DeepCollectionEquality().hash(userSettings),
      const DeepCollectionEquality().hash(authMethod),
      const DeepCollectionEquality().hash(newUser),
      const DeepCollectionEquality().hash(_fullNameSearch),
      const DeepCollectionEquality().hash(createdByUserWithId),
      const DeepCollectionEquality().hash(password),
      const DeepCollectionEquality().hash(_tokens),
      const DeepCollectionEquality().hash(deviceId),
      const DeepCollectionEquality().hash(avatarIdx),
      const DeepCollectionEquality().hash(guardianVerificationStatus));

  @JsonKey(ignore: true)
  @override
  _$$_UserCopyWith<_$_User> get copyWith =>
      __$$_UserCopyWithImpl<_$_User>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserToJson(
      this,
    );
  }
}

abstract class _User implements User {
  factory _User(
      {required final String uid,
      required final String fullName,
      final String? email,
      required final List<String> guardianIds,
      required final List<String> wardIds,
      required final UserRole role,
      final UserSettings? userSettings,
      final AuthenticationMethod? authMethod,
      final bool newUser,
      @JsonKey(toJson: User._checkIfKeywordsAreSet)
          final List<String>? fullNameSearch,
      final String? createdByUserWithId,
      final String? password,
      final List<String>? tokens,
      final String? deviceId,
      final int? avatarIdx,
      final GuardianVerificationStatus? guardianVerificationStatus}) = _$_User;

  factory _User.fromJson(Map<String, dynamic> json) = _$_User.fromJson;

  @override
  String get uid;
  @override
  String get fullName;
  @override
  String? get email;
  @override
  List<String> get guardianIds;
  @override
  List<String> get wardIds;
  @override
  UserRole get role;
  @override
  UserSettings? get userSettings;
  @override
  AuthenticationMethod? get authMethod;
  @override
  bool get newUser;
  @override
  @JsonKey(toJson: User._checkIfKeywordsAreSet)
  List<String>? get fullNameSearch;
  @override
  String? get createdByUserWithId;
  @override
  String? get password;
  @override
  List<String>? get tokens;
  @override
  String? get deviceId;
  @override
  int? get avatarIdx;
  @override
  GuardianVerificationStatus? get guardianVerificationStatus;
  @override
  @JsonKey(ignore: true)
  _$$_UserCopyWith<_$_User> get copyWith => throw _privateConstructorUsedError;
}
