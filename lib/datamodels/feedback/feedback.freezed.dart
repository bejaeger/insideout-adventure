// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'feedback.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

Feedback _$FeedbackFromJson(Map<String, dynamic> json) {
  return _Feedback.fromJson(json);
}

/// @nodoc
mixin _$Feedback {
  String get uid => throw _privateConstructorUsedError;
  String get userName => throw _privateConstructorUsedError;
  String get feedback => throw _privateConstructorUsedError;
  String get campaign => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  String? get imageFileName => throw _privateConstructorUsedError;
  String? get deviceInfo => throw _privateConstructorUsedError;
  List<String> get questions => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedbackCopyWith<Feedback> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackCopyWith<$Res> {
  factory $FeedbackCopyWith(Feedback value, $Res Function(Feedback) then) =
      _$FeedbackCopyWithImpl<$Res>;
  $Res call(
      {String uid,
      String userName,
      String feedback,
      String campaign,
      String? imageUrl,
      String? imageFileName,
      String? deviceInfo,
      List<String> questions});
}

/// @nodoc
class _$FeedbackCopyWithImpl<$Res> implements $FeedbackCopyWith<$Res> {
  _$FeedbackCopyWithImpl(this._value, this._then);

  final Feedback _value;
  // ignore: unused_field
  final $Res Function(Feedback) _then;

  @override
  $Res call({
    Object? uid = freezed,
    Object? userName = freezed,
    Object? feedback = freezed,
    Object? campaign = freezed,
    Object? imageUrl = freezed,
    Object? imageFileName = freezed,
    Object? deviceInfo = freezed,
    Object? questions = freezed,
  }) {
    return _then(_value.copyWith(
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      userName: userName == freezed
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      feedback: feedback == freezed
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as String,
      campaign: campaign == freezed
          ? _value.campaign
          : campaign // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageFileName: imageFileName == freezed
          ? _value.imageFileName
          : imageFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceInfo: deviceInfo == freezed
          ? _value.deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      questions: questions == freezed
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
abstract class _$$_FeedbackCopyWith<$Res> implements $FeedbackCopyWith<$Res> {
  factory _$$_FeedbackCopyWith(
          _$_Feedback value, $Res Function(_$_Feedback) then) =
      __$$_FeedbackCopyWithImpl<$Res>;
  @override
  $Res call(
      {String uid,
      String userName,
      String feedback,
      String campaign,
      String? imageUrl,
      String? imageFileName,
      String? deviceInfo,
      List<String> questions});
}

/// @nodoc
class __$$_FeedbackCopyWithImpl<$Res> extends _$FeedbackCopyWithImpl<$Res>
    implements _$$_FeedbackCopyWith<$Res> {
  __$$_FeedbackCopyWithImpl(
      _$_Feedback _value, $Res Function(_$_Feedback) _then)
      : super(_value, (v) => _then(v as _$_Feedback));

  @override
  _$_Feedback get _value => super._value as _$_Feedback;

  @override
  $Res call({
    Object? uid = freezed,
    Object? userName = freezed,
    Object? feedback = freezed,
    Object? campaign = freezed,
    Object? imageUrl = freezed,
    Object? imageFileName = freezed,
    Object? deviceInfo = freezed,
    Object? questions = freezed,
  }) {
    return _then(_$_Feedback(
      uid: uid == freezed
          ? _value.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      userName: userName == freezed
          ? _value.userName
          : userName // ignore: cast_nullable_to_non_nullable
              as String,
      feedback: feedback == freezed
          ? _value.feedback
          : feedback // ignore: cast_nullable_to_non_nullable
              as String,
      campaign: campaign == freezed
          ? _value.campaign
          : campaign // ignore: cast_nullable_to_non_nullable
              as String,
      imageUrl: imageUrl == freezed
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      imageFileName: imageFileName == freezed
          ? _value.imageFileName
          : imageFileName // ignore: cast_nullable_to_non_nullable
              as String?,
      deviceInfo: deviceInfo == freezed
          ? _value.deviceInfo
          : deviceInfo // ignore: cast_nullable_to_non_nullable
              as String?,
      questions: questions == freezed
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_Feedback implements _Feedback {
  _$_Feedback(
      {required this.uid,
      required this.userName,
      required this.feedback,
      required this.campaign,
      this.imageUrl,
      this.imageFileName,
      this.deviceInfo,
      required final List<String> questions})
      : _questions = questions;

  factory _$_Feedback.fromJson(Map<String, dynamic> json) =>
      _$$_FeedbackFromJson(json);

  @override
  final String uid;
  @override
  final String userName;
  @override
  final String feedback;
  @override
  final String campaign;
  @override
  final String? imageUrl;
  @override
  final String? imageFileName;
  @override
  final String? deviceInfo;
  final List<String> _questions;
  @override
  List<String> get questions {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  String toString() {
    return 'Feedback(uid: $uid, userName: $userName, feedback: $feedback, campaign: $campaign, imageUrl: $imageUrl, imageFileName: $imageFileName, deviceInfo: $deviceInfo, questions: $questions)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_Feedback &&
            const DeepCollectionEquality().equals(other.uid, uid) &&
            const DeepCollectionEquality().equals(other.userName, userName) &&
            const DeepCollectionEquality().equals(other.feedback, feedback) &&
            const DeepCollectionEquality().equals(other.campaign, campaign) &&
            const DeepCollectionEquality().equals(other.imageUrl, imageUrl) &&
            const DeepCollectionEquality()
                .equals(other.imageFileName, imageFileName) &&
            const DeepCollectionEquality()
                .equals(other.deviceInfo, deviceInfo) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(uid),
      const DeepCollectionEquality().hash(userName),
      const DeepCollectionEquality().hash(feedback),
      const DeepCollectionEquality().hash(campaign),
      const DeepCollectionEquality().hash(imageUrl),
      const DeepCollectionEquality().hash(imageFileName),
      const DeepCollectionEquality().hash(deviceInfo),
      const DeepCollectionEquality().hash(_questions));

  @JsonKey(ignore: true)
  @override
  _$$_FeedbackCopyWith<_$_Feedback> get copyWith =>
      __$$_FeedbackCopyWithImpl<_$_Feedback>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FeedbackToJson(
      this,
    );
  }
}

abstract class _Feedback implements Feedback {
  factory _Feedback(
      {required final String uid,
      required final String userName,
      required final String feedback,
      required final String campaign,
      final String? imageUrl,
      final String? imageFileName,
      final String? deviceInfo,
      required final List<String> questions}) = _$_Feedback;

  factory _Feedback.fromJson(Map<String, dynamic> json) = _$_Feedback.fromJson;

  @override
  String get uid;
  @override
  String get userName;
  @override
  String get feedback;
  @override
  String get campaign;
  @override
  String? get imageUrl;
  @override
  String? get imageFileName;
  @override
  String? get deviceInfo;
  @override
  List<String> get questions;
  @override
  @JsonKey(ignore: true)
  _$$_FeedbackCopyWith<_$_Feedback> get copyWith =>
      throw _privateConstructorUsedError;
}
