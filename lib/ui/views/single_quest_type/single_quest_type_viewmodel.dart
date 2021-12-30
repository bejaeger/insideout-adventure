import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

class SingleQuestViewModel extends QuestViewModel with NavigationMixin {
  final GeolocationService _geolocationService = locator<GeolocationService>();

  final log = getLogger("SingleQuestViewModel");
  final _questService = locator<QuestService>();
  final _dialogService = locator<DialogService>();

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
    //Remove Quest in the Firebase
    await _questService.removeQuest(quest: quest);
    //Remove Quest In the List.
    currentQuests.remove(quest);

    notifyListeners();
  }

  void setQuestToUpdate({required Quest quest}) {
    _questService.setQuestToUpdate(quest: quest);
  }

/*   void navigateToUpdatingQuest() {
    navToUpdatingQuestView();
  } */

  Future showConfirmationDialog({required Quest quest}) async {
    DialogResponse? response = await _dialogService.showCustomDialog(
      data: quest,
      title: quest.name,
      description: quest.description,
      mainButtonTitle: 'Edit',
      secondaryButtonTitle: 'Cancel',
      variant: DialogType.EditQuestInformation,

      // dialogPlatform: DialogPlatform.Cupertino, // DialogPlatform.Material
    );
    if (response!.confirmed) {
      log.i('Edit Button was pressed ${response.confirmed}');
      notifyListeners();
    }
  }

  @override
  Future handleMarkerAnalysisResult(MarkerAnalysisResult result) {
    // TODO: implement handleQrCodeScanEvent
    throw UnimplementedError();
  }
}
