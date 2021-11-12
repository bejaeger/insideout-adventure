import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';

/// Possible result when qr code is scanned

class QuestQRCodeScanResult {
  /// AFK Credits user
  final AFKMarker? marker;
  final List<Quest>? quests;

  /// Contains the error message for the request
  final String? errorMessage;

  QuestQRCodeScanResult.quests({this.quests})
      : errorMessage = null,
        marker = null;

  QuestQRCodeScanResult.marker({this.marker})
      : errorMessage = null,
        quests = null;

  QuestQRCodeScanResult.error({this.errorMessage})
      : marker = null,
        quests = null;

  QuestQRCodeScanResult.empty()
      : marker = null,
        errorMessage = null,
        quests = null;

  /// Returns true if the response has an error associated with it
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
  bool get isEmpty => errorMessage == null && marker == null && quests == null;
}
