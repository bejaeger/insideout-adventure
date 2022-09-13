// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_Feedback _$$_FeedbackFromJson(Map<String, dynamic> json) => _$_Feedback(
      uid: json['uid'] as String,
      userName: json['userName'] as String,
      feedback: json['feedback'] as String,
      campaign: json['campaign'] as String,
      imageUrl: json['imageUrl'] as String?,
      imageFileName: json['imageFileName'] as String?,
      deviceInfo: json['deviceInfo'] as String?,
      questions:
          (json['questions'] as List<dynamic>).map((e) => e as String).toList(),
    );

Map<String, dynamic> _$$_FeedbackToJson(_$_Feedback instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'userName': instance.userName,
      'feedback': instance.feedback,
      'campaign': instance.campaign,
      'imageUrl': instance.imageUrl,
      'imageFileName': instance.imageFileName,
      'deviceInfo': instance.deviceInfo,
      'questions': instance.questions,
    };
