import 'package:freezed_annotation/freezed_annotation.dart';

part 'marker_note.freezed.dart';
part 'marker_note.g.dart';

@freezed
class MarkerNote with _$MarkerNote {
  factory MarkerNote({
    required String note,
    String? imagePath,
    String? solution, //
    String? hint,
  }) = _MarkerNote;

  factory MarkerNote.fromJson(Map<String, dynamic> json) =>
      _$MarkerNoteFromJson(json);
}
