import 'package:freezed_annotation/freezed_annotation.dart';

part 'faqs.freezed.dart';
part 'faqs.g.dart';

@freezed
class FAQs with _$FAQs {
  factory FAQs({
    required List<String> questions,
    required List<String> answers,
  }) = _FAQs;

  factory FAQs.fromJson(Map<String, dynamic> json) => _$FAQsFromJson(json);
}
