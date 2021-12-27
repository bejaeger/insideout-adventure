import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';

class ActiveQuestStandaloneUIViewModel extends QuestViewModel {
  final log = getLogger("ActiveQuestStandaloneUIViewModel");

  Future revealDistance() async {
    log.i("Distance is TBD");
  }

  @override
  Future handleMarkerAnalysisResult(MarkerAnalysisResult result) {
    // TODO: implement handleQrCodeScanEvent
    throw UnimplementedError();
  }
}
