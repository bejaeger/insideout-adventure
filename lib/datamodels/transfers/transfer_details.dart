import 'package:afkcredits/enums/transfer_source.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer_details.freezed.dart';
part 'transfer_details.g.dart';

@freezed
class TransferDetails with _$TransferDetails {
  const factory TransferDetails({
    required String recipientId,
    required String recipientName,
    required String senderId,
    required String senderName,
    required num amount,
    required String currency,
    required TransferSource sourceType,
    @Default("") dynamic createdAt,
    String? id,
    /* legacy */
  }) = _TransferDetails;

  factory TransferDetails.fromJson(Map<String, dynamic> json) =>
      _$TransferDetailsFromJson(json);
}
