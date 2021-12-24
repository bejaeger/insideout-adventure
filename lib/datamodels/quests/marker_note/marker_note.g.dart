// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'marker_note.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_MarkerNote _$$_MarkerNoteFromJson(Map<String, dynamic> json) =>
    _$_MarkerNote(
      note: json['note'] as String,
      imagePath: json['imagePath'] as String?,
      solution: json['solution'] as String?,
    );

Map<String, dynamic> _$$_MarkerNoteToJson(_$_MarkerNote instance) =>
    <String, dynamic>{
      'note': instance.note,
      'imagePath': instance.imagePath,
      'solution': instance.solution,
    };
