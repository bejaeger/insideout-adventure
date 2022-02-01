import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/marker_collection_failure_type.dart';

/// Possible result when qr code is scanned

class MarkerAnalysisResult {
  /// AFK Credits user
  final AFKMarker? marker;
  final List<Quest>? quests;

  /// Contains the error message for the request
  final String? errorMessage;
  final MarkerCollectionFailureType? errorType;

  MarkerAnalysisResult.quests({this.quests})
      : errorMessage = null,
        marker = null,
        errorType = null;

  MarkerAnalysisResult.marker({this.marker})
      : errorMessage = null,
        quests = null,
        errorType = null;

  MarkerAnalysisResult.error({this.errorMessage, this.errorType})
      : marker = null,
        quests = null;

  MarkerAnalysisResult.empty()
      : marker = null,
        errorMessage = null,
        quests = null,
        errorType = null;

  /// Returns true if the response has an error associated with it
  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
  bool get isEmpty => errorMessage == null && marker == null && quests == null;
}
