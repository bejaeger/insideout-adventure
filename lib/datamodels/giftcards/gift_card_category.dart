import 'package:afkcredits/enums/gift_card_type.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
part 'gift_card_category.freezed.dart';
part 'gift_card_category.g.dart';

@freezed
class GiftCardCategory with _$GiftCardCategory {
  factory GiftCardCategory({
    required String categoryId,
    required double amount,
    String? imageUrl,
    required GiftCardType categoryName,
  }) = _GiftCardCategory;

  factory GiftCardCategory.fromJson(Map<String, dynamic> json) =>
      _$GiftCardCategoryFromJson(json);
}
