// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'user_settings.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

UserSettings _$UserSettingsFromJson(Map<String, dynamic> json) {
  return _UserSettings.fromJson(json);
}

/// @nodoc
mixin _$UserSettings {
// this is mostly used together with a check of appConfigProvide.isARAvailable!
  bool get isUsingAR =>
      throw _privateConstructorUsedError; // Switch to make completed quests visible/invisible
// (only done for search quests at the moment
// as hike quests can ALWAYS be redone))
  bool get isShowingCompletedQuests => throw _privateConstructorUsedError;
  bool get isShowAvatarAndMapEffects => throw _privateConstructorUsedError;
  bool get ownPhone =>
      throw _privateConstructorUsedError; // child using his/her own phone
  bool get isAcceptScreenTimeFirst => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $UserSettingsCopyWith<UserSettings> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $UserSettingsCopyWith<$Res> {
  factory $UserSettingsCopyWith(
          UserSettings value, $Res Function(UserSettings) then) =
      _$UserSettingsCopyWithImpl<$Res>;
  $Res call(
      {bool isUsingAR,
      bool isShowingCompletedQuests,
      bool isShowAvatarAndMapEffects,
      bool ownPhone,
      bool isAcceptScreenTimeFirst});
}

/// @nodoc
class _$UserSettingsCopyWithImpl<$Res> implements $UserSettingsCopyWith<$Res> {
  _$UserSettingsCopyWithImpl(this._value, this._then);

  final UserSettings _value;
  // ignore: unused_field
  final $Res Function(UserSettings) _then;

  @override
  $Res call({
    Object? isUsingAR = freezed,
    Object? isShowingCompletedQuests = freezed,
    Object? isShowAvatarAndMapEffects = freezed,
    Object? ownPhone = freezed,
    Object? isAcceptScreenTimeFirst = freezed,
  }) {
    return _then(_value.copyWith(
      isUsingAR: isUsingAR == freezed
          ? _value.isUsingAR
          : isUsingAR // ignore: cast_nullable_to_non_nullable
              as bool,
      isShowingCompletedQuests: isShowingCompletedQuests == freezed
          ? _value.isShowingCompletedQuests
          : isShowingCompletedQuests // ignore: cast_nullable_to_non_nullable
              as bool,
      isShowAvatarAndMapEffects: isShowAvatarAndMapEffects == freezed
          ? _value.isShowAvatarAndMapEffects
          : isShowAvatarAndMapEffects // ignore: cast_nullable_to_non_nullable
              as bool,
      ownPhone: ownPhone == freezed
          ? _value.ownPhone
          : ownPhone // ignore: cast_nullable_to_non_nullable
              as bool,
      isAcceptScreenTimeFirst: isAcceptScreenTimeFirst == freezed
          ? _value.isAcceptScreenTimeFirst
          : isAcceptScreenTimeFirst // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
abstract class _$$_UserSettingsCopyWith<$Res>
    implements $UserSettingsCopyWith<$Res> {
  factory _$$_UserSettingsCopyWith(
          _$_UserSettings value, $Res Function(_$_UserSettings) then) =
      __$$_UserSettingsCopyWithImpl<$Res>;
  @override
  $Res call(
      {bool isUsingAR,
      bool isShowingCompletedQuests,
      bool isShowAvatarAndMapEffects,
      bool ownPhone,
      bool isAcceptScreenTimeFirst});
}

/// @nodoc
class __$$_UserSettingsCopyWithImpl<$Res>
    extends _$UserSettingsCopyWithImpl<$Res>
    implements _$$_UserSettingsCopyWith<$Res> {
  __$$_UserSettingsCopyWithImpl(
      _$_UserSettings _value, $Res Function(_$_UserSettings) _then)
      : super(_value, (v) => _then(v as _$_UserSettings));

  @override
  _$_UserSettings get _value => super._value as _$_UserSettings;

  @override
  $Res call({
    Object? isUsingAR = freezed,
    Object? isShowingCompletedQuests = freezed,
    Object? isShowAvatarAndMapEffects = freezed,
    Object? ownPhone = freezed,
    Object? isAcceptScreenTimeFirst = freezed,
  }) {
    return _then(_$_UserSettings(
      isUsingAR: isUsingAR == freezed
          ? _value.isUsingAR
          : isUsingAR // ignore: cast_nullable_to_non_nullable
              as bool,
      isShowingCompletedQuests: isShowingCompletedQuests == freezed
          ? _value.isShowingCompletedQuests
          : isShowingCompletedQuests // ignore: cast_nullable_to_non_nullable
              as bool,
      isShowAvatarAndMapEffects: isShowAvatarAndMapEffects == freezed
          ? _value.isShowAvatarAndMapEffects
          : isShowAvatarAndMapEffects // ignore: cast_nullable_to_non_nullable
              as bool,
      ownPhone: ownPhone == freezed
          ? _value.ownPhone
          : ownPhone // ignore: cast_nullable_to_non_nullable
              as bool,
      isAcceptScreenTimeFirst: isAcceptScreenTimeFirst == freezed
          ? _value.isAcceptScreenTimeFirst
          : isAcceptScreenTimeFirst // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_UserSettings implements _UserSettings {
  _$_UserSettings(
      {this.isUsingAR = true,
      this.isShowingCompletedQuests = false,
      this.isShowAvatarAndMapEffects = true,
      this.ownPhone = false,
      this.isAcceptScreenTimeFirst = false});

  factory _$_UserSettings.fromJson(Map<String, dynamic> json) =>
      _$$_UserSettingsFromJson(json);

// this is mostly used together with a check of appConfigProvide.isARAvailable!
  @override
  @JsonKey()
  final bool isUsingAR;
// Switch to make completed quests visible/invisible
// (only done for search quests at the moment
// as hike quests can ALWAYS be redone))
  @override
  @JsonKey()
  final bool isShowingCompletedQuests;
  @override
  @JsonKey()
  final bool isShowAvatarAndMapEffects;
  @override
  @JsonKey()
  final bool ownPhone;
// child using his/her own phone
  @override
  @JsonKey()
  final bool isAcceptScreenTimeFirst;

  @override
  String toString() {
    return 'UserSettings(isUsingAR: $isUsingAR, isShowingCompletedQuests: $isShowingCompletedQuests, isShowAvatarAndMapEffects: $isShowAvatarAndMapEffects, ownPhone: $ownPhone, isAcceptScreenTimeFirst: $isAcceptScreenTimeFirst)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_UserSettings &&
            const DeepCollectionEquality().equals(other.isUsingAR, isUsingAR) &&
            const DeepCollectionEquality().equals(
                other.isShowingCompletedQuests, isShowingCompletedQuests) &&
            const DeepCollectionEquality().equals(
                other.isShowAvatarAndMapEffects, isShowAvatarAndMapEffects) &&
            const DeepCollectionEquality().equals(other.ownPhone, ownPhone) &&
            const DeepCollectionEquality().equals(
                other.isAcceptScreenTimeFirst, isAcceptScreenTimeFirst));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(isUsingAR),
      const DeepCollectionEquality().hash(isShowingCompletedQuests),
      const DeepCollectionEquality().hash(isShowAvatarAndMapEffects),
      const DeepCollectionEquality().hash(ownPhone),
      const DeepCollectionEquality().hash(isAcceptScreenTimeFirst));

  @JsonKey(ignore: true)
  @override
  _$$_UserSettingsCopyWith<_$_UserSettings> get copyWith =>
      __$$_UserSettingsCopyWithImpl<_$_UserSettings>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_UserSettingsToJson(
      this,
    );
  }
}

abstract class _UserSettings implements UserSettings {
  factory _UserSettings(
      {final bool isUsingAR,
      final bool isShowingCompletedQuests,
      final bool isShowAvatarAndMapEffects,
      final bool ownPhone,
      final bool isAcceptScreenTimeFirst}) = _$_UserSettings;

  factory _UserSettings.fromJson(Map<String, dynamic> json) =
      _$_UserSettings.fromJson;

  @override // this is mostly used together with a check of appConfigProvide.isARAvailable!
  bool get isUsingAR;
  @override // Switch to make completed quests visible/invisible
// (only done for search quests at the moment
// as hike quests can ALWAYS be redone))
  bool get isShowingCompletedQuests;
  @override
  bool get isShowAvatarAndMapEffects;
  @override
  bool get ownPhone;
  @override // child using his/her own phone
  bool get isAcceptScreenTimeFirst;
  @override
  @JsonKey(ignore: true)
  _$$_UserSettingsCopyWith<_$_UserSettings> get copyWith =>
      throw _privateConstructorUsedError;
}
