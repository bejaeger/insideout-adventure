import 'package:afkcredits/datamodels/transfers/transfer_details.dart';
import 'package:afkcredits/enums/transfer_status.dart';
import 'package:afkcredits/enums/transfer_type.dart';
import 'package:afkcredits/exceptions/datamodel_exception.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'transfer.freezed.dart';
part 'transfer.g.dart';

@freezed
class MoneyTransfer with _$MoneyTransfer {
  const MoneyTransfer._(); // private constructor for implemented methods to work

  // This function is deprecated for now since
  // we create the document in a server function now.
  // This means the document id will be added in this
  // server function.
  static String _checkIftransferIdIsSet(String id) {
    if (id == "placeholder") {
      throw DataModelException(
          message:
              "MoneyTransfer: You can't serialize a money transfer model that still has a placeholder for the 'transferId'!",
          devDetails:
              "Please provide a valid 'transferId' by creating a new 'Transaction' with the copyWith constructor and adding the firestore DocumentReference id as 'transferId'");
    } else
      return id;
  }

  // Transaction between peers
  // From the user perspective this can still be
  // an outgoing or incoming transaction
  @JsonSerializable(explicitToJson: true)
  const factory MoneyTransfer({
    required TransferDetails transferDetails,
    @Default("")
        dynamic createdAt,
    @Default(TransferStatus.Initialized)
        TransferStatus status,
    @Default(TransferType.Guardian2WardCredits)
        TransferType type,
    @JsonKey(
      name: "transferId",
    )
    @Default("placeholder")
        String transferId,
  }) = _MoneyTransfer;

  factory MoneyTransfer.fromJson(Map<String, dynamic> json) =>
      _$MoneyTransferFromJson(json);
}
