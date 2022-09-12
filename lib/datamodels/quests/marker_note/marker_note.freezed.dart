// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target

part of 'marker_note.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#custom-getters-and-methods');

MarkerNote _$MarkerNoteFromJson(Map<String, dynamic> json) {
  return _MarkerNote.fromJson(json);
}

/// @nodoc
mixin _$MarkerNote {
  String get note => throw _privateConstructorUsedError;
  String? get imagePath => throw _privateConstructorUsedError;
  String? get solution => throw _privateConstructorUsedError; //
  String? get clue => throw _privateConstructorUsedError;

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
  $Res call({String note, String? imagePath, String? solution, String? clue});
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
    Object? clue = freezed,
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
      clue: clue == freezed
          ? _value.clue
          : clue // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
abstract class _$$_MarkerNoteCopyWith<$Res>
    implements $MarkerNoteCopyWith<$Res> {
  factory _$$_MarkerNoteCopyWith(
          _$_MarkerNote value, $Res Function(_$_MarkerNote) then) =
      __$$_MarkerNoteCopyWithImpl<$Res>;
  @override
  $Res call({String note, String? imagePath, String? solution, String? clue});
}

/// @nodoc
class __$$_MarkerNoteCopyWithImpl<$Res> extends _$MarkerNoteCopyWithImpl<$Res>
    implements _$$_MarkerNoteCopyWith<$Res> {
  __$$_MarkerNoteCopyWithImpl(
      _$_MarkerNote _value, $Res Function(_$_MarkerNote) _then)
      : super(_value, (v) => _then(v as _$_MarkerNote));

  @override
  _$_MarkerNote get _value => super._value as _$_MarkerNote;

  @override
  $Res call({
    Object? note = freezed,
    Object? imagePath = freezed,
    Object? solution = freezed,
    Object? clue = freezed,
  }) {
    return _then(_$_MarkerNote(
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
      clue: clue == freezed
          ? _value.clue
          : clue // ignore: cast_nullable_to_non_nullable
              as String?,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$_MarkerNote implements _MarkerNote {
  _$_MarkerNote({required this.note, this.imagePath, this.solution, this.clue});

  factory _$_MarkerNote.fromJson(Map<String, dynamic> json) =>
      _$$_MarkerNoteFromJson(json);

  @override
  final String note;
  @override
  final String? imagePath;
  @override
  final String? solution;
//
  @override
  final String? clue;

  @override
  String toString() {
    return 'MarkerNote(note: $note, imagePath: $imagePath, solution: $solution, clue: $clue)';
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$_MarkerNote &&
            const DeepCollectionEquality().equals(other.note, note) &&
            const DeepCollectionEquality().equals(other.imagePath, imagePath) &&
            const DeepCollectionEquality().equals(other.solution, solution) &&
            const DeepCollectionEquality().equals(other.clue, clue));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(note),
      const DeepCollectionEquality().hash(imagePath),
      const DeepCollectionEquality().hash(solution),
      const DeepCollectionEquality().hash(clue));

  @JsonKey(ignore: true)
  @override
  _$$_MarkerNoteCopyWith<_$_MarkerNote> get copyWith =>
      __$$_MarkerNoteCopyWithImpl<_$_MarkerNote>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$_MarkerNoteToJson(
      this,
    );
  }
}

abstract class _MarkerNote implements MarkerNote {
  factory _MarkerNote(
      {required final String note,
      final String? imagePath,
      final String? solution,
      final String? clue}) = _$_MarkerNote;

  factory _MarkerNote.fromJson(Map<String, dynamic> json) =
      _$_MarkerNote.fromJson;

  @override
  String get note;
  @override
  String? get imagePath;
  @override
  String? get solution;
  @override //
  String? get clue;
  @override
  @JsonKey(ignore: true)
  _$$_MarkerNoteCopyWith<_$_MarkerNote> get copyWith =>
      throw _privateConstructorUsedError;
}
