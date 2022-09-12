import 'package:freezed_annotation/freezed_annotation.dart';

part 'feedback.freezed.dart';
part 'feedback.g.dart';

@freezed
class Feedback with _$Feedback {
  factory Feedback({
    required String uid,
    required String userName,
    required String feedback,
    required String campaign,
    String? imageUrl,
    String? imageFileName,
    String? deviceInfo,
    required List<String> questions,
  }) = _Feedback;

  factory Feedback.fromJson(Map<String, dynamic> json) =>
      _$FeedbackFromJson(json);
}
