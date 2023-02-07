import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/marker_collection_failure_type.dart';

/// Possible result when checkpoint is reached

class MarkerAnalysisResult {
  final AFKMarker? marker;
  final List<Quest>? quests;

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

  bool get hasError => errorMessage != null && errorMessage!.isNotEmpty;
  bool get isEmpty => errorMessage == null && marker == null && quests == null;
}
