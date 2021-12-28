import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';

class SingleQuestViewModel extends QuestViewModel {
  final GeolocationService _geolocationService = locator<GeolocationService>();

  final log = getLogger("SingleQuestViewModel");
  final _questService = locator<QuestService>();

  final QuestType? questType;
  List<Quest> currentQuests = [];

  SingleQuestViewModel({this.questType}) {
    if (questType != null) {
      currentQuests = getQuestsOfType(type: questType!);
      currentQuests
          .forEach((element) => distancesFromQuests.add(double.infinity));
    }
  }
  Future<void> removeQuest({required Quest quest}) async {
    await _questService.removeQuest(quest: quest);
    notifyListeners();
  }

  @override
  Future handleMarkerAnalysisResult(MarkerAnalysisResult result) {
    // TODO: implement handleQrCodeScanEvent
    throw UnimplementedError();
  }
}
