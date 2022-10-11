// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'feedback_campaign_info.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FeedbackCampaignInfo _$FeedbackCampaignInfoFromJson(Map<String, dynamic> json) {
  return _FeedbackCampaignInfo.fromJson(json);
}

/// @nodoc
mixin _$FeedbackCampaignInfo {
  String get currentCampaign => throw _privateConstructorUsedError;
  List<String> get questions => throw _privateConstructorUsedError;
  String get surveyUrl => throw _privateConstructorUsedError;
  List<String>? get takenByUserWithUids => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FeedbackCampaignInfoCopyWith<FeedbackCampaignInfo> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FeedbackCampaignInfoCopyWith<$Res> {
  factory $FeedbackCampaignInfoCopyWith(FeedbackCampaignInfo value,
          $Res Function(FeedbackCampaignInfo) then) =
      _$FeedbackCampaignInfoCopyWithImpl<$Res>;
  $Res call(
      {String currentCampaign,
      List<String> questions,
      String surveyUrl,
      List<String>? takenByUserWithUids});
}

/// @nodoc
class _$FeedbackCampaignInfoCopyWithImpl<$Res>
    implements $FeedbackCampaignInfoCopyWith<$Res> {
  _$FeedbackCampaignInfoCopyWithImpl(this._value, this._then);

  final FeedbackCampaignInfo _value;
  // ignore: unused_field
  final $Res Function(FeedbackCampaignInfo) _then;

  @override
  $Res call({
    Object? currentCampaign = freezed,
    Object? questions = freezed,
    Object? surveyUrl = freezed,
    Object? takenByUserWithUids = freezed,
  }) {
    return _then(_value.copyWith(
      currentCampaign: currentCampaign == freezed
          ? _value.currentCampaign
          : currentCampaign // ignore: cast_nullable_to_non_nullable
              as String,
      questions: questions == freezed
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      surveyUrl: surveyUrl == freezed
          ? _value.surveyUrl
          : surveyUrl // ignore: cast_nullable_to_non_nullable
              as String,
      takenByUserWithUids: takenByUserWithUids == freezed
          ? _value.takenByUserWithUids
          : takenByUserWithUids // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
abstract class _$$_FeedbackCampaignInfoCopyWith<$Res>
    implements $FeedbackCampaignInfoCopyWith<$Res> {
  factory _$$_FeedbackCampaignInfoCopyWith(_$_FeedbackCampaignInfo value,
          $Res Function(_$_FeedbackCampaignInfo) then) =
      __$$_FeedbackCampaignInfoCopyWithImpl<$Res>;
  @override
  $Res call(
      {String currentCampaign,
      List<String> questions,
      String surveyUrl,
      List<String>? takenByUserWithUids});
}

/// @nodoc
class __$$_FeedbackCampaignInfoCopyWithImpl<$Res>
    extends _$FeedbackCampaignInfoCopyWithImpl<$Res>
    implements _$$_FeedbackCampaignInfoCopyWith<$Res> {
  __$$_FeedbackCampaignInfoCopyWithImpl(_$_FeedbackCampaignInfo _value,
      $Res Function(_$_FeedbackCampaignInfo) _then)
      : super(_value, (v) => _then(v as _$_FeedbackCampaignInfo));

  @override
  _$_FeedbackCampaignInfo get _value => super._value as _$_FeedbackCampaignInfo;

  @override
  $Res call({
    Object? currentCampaign = freezed,
    Object? questions = freezed,
    Object? surveyUrl = freezed,
    Object? takenByUserWithUids = freezed,
  }) {
    return _then(_$_FeedbackCampaignInfo(
      currentCampaign: currentCampaign == freezed
          ? _value.currentCampaign
          : currentCampaign // ignore: cast_nullable_to_non_nullable
              as String,
      questions: questions == freezed
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      surveyUrl: surveyUrl == freezed
          ? _value.surveyUrl
          : surveyUrl // ignore: cast_nullable_to_non_nullable
              as String,
      takenByUserWithUids: takenByUserWithUids == freezed
          ? _value._takenByUserWithUids
          : takenByUserWithUids // ignore: cast_nullable_to_non_nullable
              as List<String>?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FeedbackCampaignInfo implements _FeedbackCampaignInfo {
  _$_FeedbackCampaignInfo(
      {required this.currentCampaign,
      required final List<String> questions,
      required this.surveyUrl,
      final List<String>? takenByUserWithUids})
      : _questions = questions,
        _takenByUserWithUids = takenByUserWithUids;

  factory _$_FeedbackCampaignInfo.fromJson(Map<String, dynamic> json) =>
      _$$_FeedbackCampaignInfoFromJson(json);

  @override
  final String currentCampaign;
  final List<String> _questions;
  @override
  List<String> get questions {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  @override
  final String surveyUrl;
  final List<String>? _takenByUserWithUids;
  @override
  List<String>? get takenByUserWithUids {
    final value = _takenByUserWithUids;
    if (value == null) return null;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  @override
  String toString() {
    return 'FeedbackCampaignInfo(currentCampaign: $currentCampaign, questions: $questions, surveyUrl: $surveyUrl, takenByUserWithUids: $takenByUserWithUids)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FeedbackCampaignInfo &&
            const DeepCollectionEquality()
                .equals(other.currentCampaign, currentCampaign) &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions) &&
            const DeepCollectionEquality().equals(other.surveyUrl, surveyUrl) &&
            const DeepCollectionEquality()
                .equals(other._takenByUserWithUids, _takenByUserWithUids));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(currentCampaign),
      const DeepCollectionEquality().hash(_questions),
      const DeepCollectionEquality().hash(surveyUrl),
      const DeepCollectionEquality().hash(_takenByUserWithUids));

  @JsonKey(ignore: true)
  @override
  _$$_FeedbackCampaignInfoCopyWith<_$_FeedbackCampaignInfo> get copyWith =>
      __$$_FeedbackCampaignInfoCopyWithImpl<_$_FeedbackCampaignInfo>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FeedbackCampaignInfoToJson(
      this,
    );
  }
}

abstract class _FeedbackCampaignInfo implements FeedbackCampaignInfo {
  factory _FeedbackCampaignInfo(
      {required final String currentCampaign,
      required final List<String> questions,
      required final String surveyUrl,
      final List<String>? takenByUserWithUids}) = _$_FeedbackCampaignInfo;

  factory _FeedbackCampaignInfo.fromJson(Map<String, dynamic> json) =
      _$_FeedbackCampaignInfo.fromJson;

  @override
  String get currentCampaign;
  @override
  List<String> get questions;
  @override
  String get surveyUrl;
  @override
  List<String>? get takenByUserWithUids;
  @override
  @JsonKey(ignore: true)
  _$$_FeedbackCampaignInfoCopyWith<_$_FeedbackCampaignInfo> get copyWith =>
      throw _privateConstructorUsedError;
}
