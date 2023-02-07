// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'faqs.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

FAQs _$FAQsFromJson(Map<String, dynamic> json) {
  return _FAQs.fromJson(json);
}

/// @nodoc
mixin _$FAQs {
  List<String> get questions => throw _privateConstructorUsedError;
  List<String> get answers => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $FAQsCopyWith<FAQs> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $FAQsCopyWith<$Res> {
  factory $FAQsCopyWith(FAQs value, $Res Function(FAQs) then) =
      _$FAQsCopyWithImpl<$Res>;
  $Res call({List<String> questions, List<String> answers});
}

/// @nodoc
class _$FAQsCopyWithImpl<$Res> implements $FAQsCopyWith<$Res> {
  _$FAQsCopyWithImpl(this._value, this._then);

  final FAQs _value;
  // ignore: unused_field
  final $Res Function(FAQs) _then;

  @override
  $Res call({
    Object? questions = freezed,
    Object? answers = freezed,
  }) {
    return _then(_value.copyWith(
      questions: questions == freezed
          ? _value.questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      answers: answers == freezed
          ? _value.answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
abstract class _$$_FAQsCopyWith<$Res> implements $FAQsCopyWith<$Res> {
  factory _$$_FAQsCopyWith(_$_FAQs value, $Res Function(_$_FAQs) then) =
      __$$_FAQsCopyWithImpl<$Res>;
  @override
  $Res call({List<String> questions, List<String> answers});
}

/// @nodoc
class __$$_FAQsCopyWithImpl<$Res> extends _$FAQsCopyWithImpl<$Res>
    implements _$$_FAQsCopyWith<$Res> {
  __$$_FAQsCopyWithImpl(_$_FAQs _value, $Res Function(_$_FAQs) _then)
      : super(_value, (v) => _then(v as _$_FAQs));

  @override
  _$_FAQs get _value => super._value as _$_FAQs;

  @override
  $Res call({
    Object? questions = freezed,
    Object? answers = freezed,
  }) {
    return _then(_$_FAQs(
      questions: questions == freezed
          ? _value._questions
          : questions // ignore: cast_nullable_to_non_nullable
              as List<String>,
      answers: answers == freezed
          ? _value._answers
          : answers // ignore: cast_nullable_to_non_nullable
              as List<String>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_FAQs implements _FAQs {
  _$_FAQs(
      {required final List<String> questions,
      required final List<String> answers})
      : _questions = questions,
        _answers = answers;

  factory _$_FAQs.fromJson(Map<String, dynamic> json) => _$$_FAQsFromJson(json);

  final List<String> _questions;
  @override
  List<String> get questions {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_questions);
  }

  final List<String> _answers;
  @override
  List<String> get answers {
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_answers);
  }

  @override
  String toString() {
    return 'FAQs(questions: $questions, answers: $answers)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_FAQs &&
            const DeepCollectionEquality()
                .equals(other._questions, _questions) &&
            const DeepCollectionEquality().equals(other._answers, _answers));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_questions),
      const DeepCollectionEquality().hash(_answers));

  @JsonKey(ignore: true)
  @override
  _$$_FAQsCopyWith<_$_FAQs> get copyWith =>
      __$$_FAQsCopyWithImpl<_$_FAQs>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_FAQsToJson(
      this,
    );
  }
}

abstract class _FAQs implements FAQs {
  factory _FAQs(
      {required final List<String> questions,
      required final List<String> answers}) = _$_FAQs;

  factory _FAQs.fromJson(Map<String, dynamic> json) = _$_FAQs.fromJson;

  @override
  List<String> get questions;
  @override
  List<String> get answers;
  @override
  @JsonKey(ignore: true)
  _$$_FAQsCopyWith<_$_FAQs> get copyWith => throw _privateConstructorUsedError;
}
