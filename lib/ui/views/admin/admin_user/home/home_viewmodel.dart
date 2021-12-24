import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';

class HomeViewModel extends QuestViewModel {
  List<Quest>? _getListOfQUest;
  final _questService = locator<QuestService>();
  @override
  Future handleQrCodeScanEvent(MarkerAnalysisResult result) {
    // TODO: implement handleQrCodeScanEvent
    throw UnimplementedError();
  }

  int currentIndex = 0;
  void toggleIndex() {
    if (currentIndex == 0) {
      currentIndex = 1;
    } else {
      currentIndex = 0;
    }
    notifyListeners();
  }

  List<Quest>? get getListOfQuest => _getListOfQUest;

  Future<void> setQuestList() async {
    setBusy(true);
    _getListOfQUest = await _questService.downloadNearbyQuests();
    setBusy(false);
    notifyListeners();
  }

  Future onQuestInListTapped(Quest quest) async {
    log.i("Quest list item tapped!!!");
    if (hasActiveQuest == false) {
      /*    await displayQuestBottomSheet(
        quest: quest,
      ); */
    } else {
      /*    _dialogService.showDialog(
          title: "You Currently Have a Running Quest !!!"); */
    }
  }
}
