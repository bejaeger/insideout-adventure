// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'marker_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more informations: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MarkerNote _$MarkerNoteFromJson(Map<String, dynamic> json) {
  return _MarkerNote.fromJson(json);
}

/// @nodoc
class _$MarkerNoteTearOff {
  const _$MarkerNoteTearOff();

  _MarkerNote call(
      {required String note,
      String? imagePath,
      String? solution,
      String? hint}) {
    return _MarkerNote(
      note: note,
      imagePath: imagePath,
      solution: solution,
      hint: hint,
    );
  }

  MarkerNote fromJson(Map<String, Object> json) {
    return MarkerNote.fromJson(json);
  }
}

/// @nodoc
const $MarkerNote = _$MarkerNoteTearOff();

/// @nodoc
mixin _$MarkerNote {
  String get note => throw _privateConstructorUsedError;
  String? get imagePath => throw _privateConstructorUsedError;
  String? get solution => throw _privateConstructorUsedError; //
  String? get hint => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $MarkerNoteCopyWith<MarkerNote> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $MarkerNoteCopyWith<$Res> {
  factory $MarkerNoteCopyWith(
          MarkerNote value, $Res Function(MarkerNote) then) =
      _$MarkerNoteCopyWithImpl<$Res>;
  $Res call({String note, String? imagePath, String? solution, String? hint});
}

/// @nodoc
class _$MarkerNoteCopyWithImpl<$Res> implements $MarkerNoteCopyWith<$Res> {
  _$MarkerNoteCopyWithImpl(this._value, this._then);

  final MarkerNote _value;
  // ignore: unused_field
  final $Res Function(MarkerNote) _then;

  @override
  $Res call({
    Object? note = freezed,
    Object? imagePath = freezed,
    Object? solution = freezed,
    Object? hint = freezed,
  }) {
    return _then(_value.copyWith(
      note: note == freezed
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: imagePath == freezed
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      solution: solution == freezed
          ? _value.solution
          : solution // ignore: cast_nullable_to_non_nullable
              as String?,
      hint: hint == freezed
          ? _value.hint
          : hint // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$MarkerNoteCopyWith<$Res> implements $MarkerNoteCopyWith<$Res> {
  factory _$MarkerNoteCopyWith(
          _MarkerNote value, $Res Function(_MarkerNote) then) =
      __$MarkerNoteCopyWithImpl<$Res>;
  @override
  $Res call({String note, String? imagePath, String? solution, String? hint});
}

/// @nodoc
class __$MarkerNoteCopyWithImpl<$Res> extends _$MarkerNoteCopyWithImpl<$Res>
    implements _$MarkerNoteCopyWith<$Res> {
  __$MarkerNoteCopyWithImpl(
      _MarkerNote _value, $Res Function(_MarkerNote) _then)
      : super(_value, (v) => _then(v as _MarkerNote));

  @override
  _MarkerNote get _value => super._value as _MarkerNote;

  @override
  $Res call({
    Object? note = freezed,
    Object? imagePath = freezed,
    Object? solution = freezed,
    Object? hint = freezed,
  }) {
    return _then(_MarkerNote(
      note: note == freezed
          ? _value.note
          : note // ignore: cast_nullable_to_non_nullable
              as String,
      imagePath: imagePath == freezed
          ? _value.imagePath
          : imagePath // ignore: cast_nullable_to_non_nullable
              as String?,
      solution: solution == freezed
          ? _value.solution
          : solution // ignore: cast_nullable_to_non_nullable
              as String?,
      hint: hint == freezed
          ? _value.hint
          : hint // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MarkerNote implements _MarkerNote {
  _$_MarkerNote({required this.note, this.imagePath, this.solution, this.hint});

  factory _$_MarkerNote.fromJson(Map<String, dynamic> json) =>
      _$$_MarkerNoteFromJson(json);

  @override
  final String note;
  @override
  final String? imagePath;
  @override
  final String? solution;
  @override //
  final String? hint;

  @override
  String toString() {
    return 'MarkerNote(note: $note, imagePath: $imagePath, solution: $solution, hint: $hint)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other is _MarkerNote &&
            (identical(other.note, note) ||
                const DeepCollectionEquality().equals(other.note, note)) &&
            (identical(other.imagePath, imagePath) ||
                const DeepCollectionEquality()
                    .equals(other.imagePath, imagePath)) &&
            (identical(other.solution, solution) ||
                const DeepCollectionEquality()
                    .equals(other.solution, solution)) &&
            (identical(other.hint, hint) ||
                const DeepCollectionEquality().equals(other.hint, hint)));
  }

  @override
  int get hashCode =>
      runtimeType.hashCode ^
      const DeepCollectionEquality().hash(note) ^
      const DeepCollectionEquality().hash(imagePath) ^
      const DeepCollectionEquality().hash(solution) ^
      const DeepCollectionEquality().hash(hint);

  @JsonKey(ignore: true)
  @override
  _$MarkerNoteCopyWith<_MarkerNote> get copyWith =>
      __$MarkerNoteCopyWithImpl<_MarkerNote>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MarkerNoteToJson(this);
  }
}

abstract class _MarkerNote implements MarkerNote {
  factory _MarkerNote(
      {required String note,
      String? imagePath,
      String? solution,
      String? hint}) = _$_MarkerNote;

  factory _MarkerNote.fromJson(Map<String, dynamic> json) =
      _$_MarkerNote.fromJson;

  @override
  String get note => throw _privateConstructorUsedError;
  @override
  String? get imagePath => throw _privateConstructorUsedError;
  @override
  String? get solution => throw _privateConstructorUsedError;
  @override //
  String? get hint => throw _privateConstructorUsedError;
  @override
  @JsonKey(ignore: true)
  _$MarkerNoteCopyWith<_MarkerNote> get copyWith =>
      throw _privateConstructorUsedError;
}
