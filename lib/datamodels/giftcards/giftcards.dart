import 'package:freezed_annotation/freezed_annotation.dart';
part 'giftcards.freezed.dart';
part 'giftcards.g.dart';

@freezed
class Giftcards with _$Giftcards {
  factory Giftcards({
    String? categoryId,
    double? amount,
    String? imageUrl,
    String? categoryName,
    String? name,
  }) = _Giftcards;

  factory Giftcards.fromJson(Map<String, dynamic> json) =>
      _$GiftcardsFromJson(json);
}
