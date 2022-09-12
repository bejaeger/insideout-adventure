// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'feedback_campaign_info.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$_FeedbackCampaignInfo _$$_FeedbackCampaignInfoFromJson(
        Map<String, dynamic> json) =>
    _$_FeedbackCampaignInfo(
      currentCampaign: json['currentCampaign'] as String,
      questions:
          (json['questions'] as List<dynamic>).map((e) => e as String).toList(),
      surveyUrl: json['surveyUrl'] as String,
    );

Map<String, dynamic> _$$_FeedbackCampaignInfoToJson(
        _$_FeedbackCampaignInfo instance) =>
    <String, dynamic>{
      'currentCampaign': instance.currentCampaign,
      'questions': instance.questions,
      'surveyUrl': instance.surveyUrl,
    };
