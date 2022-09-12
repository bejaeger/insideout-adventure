import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback_campaign_info.freezed.dart';
part 'feedback_campaign_info.g.dart';

@freezed
class FeedbackCampaignInfo with _$FeedbackCampaignInfo {
  factory FeedbackCampaignInfo({
    required String currentCampaign,
    required List<String> questions,
    required String surveyUrl,
  }) = _FeedbackCampaignInfo;

  factory FeedbackCampaignInfo.fromJson(Map<String, dynamic> json) =>
      _$FeedbackCampaignInfoFromJson(json);
}
