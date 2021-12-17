import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';

class HomeViewModel extends QuestViewModel {
  List<Quest> get nearbyQuests => questService.nearbyQuests;

  @override
  Future handleQrCodeScanEvent(QuestQRCodeScanResult result) {
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
