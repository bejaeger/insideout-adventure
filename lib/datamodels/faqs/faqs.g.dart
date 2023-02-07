// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'faqs.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FAQs _$$_FAQsFromJson(Map<String, dynamic> json) => _$_FAQs(
      questions:
          (json['questions'] as List<dynamic>).map((e) => e as String).toList(),
      answers:
          (json['answers'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$_FAQsToJson(_$_FAQs instance) => <String, dynamic>{
      'questions': instance.questions,
      'answers': instance.answers,
    };
