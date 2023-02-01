import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';

class QuestsOverviewViewModel extends QuestViewModel {
  List<QuestType> get questTypes => questService.allQuestTypes;
  final logger = getLogger('ManageQuestViewModel');

  // !!! THE SAME FUNCTION EXISTS IN EXPLORER HOME VIEWMODEL!
  Future initializeQuests({bool? force}) async {
    setBusy(true);
    try {
      if (questService.sortedNearbyQuests == false || force == true) {
        await questService.loadNearbyQuests(
            force: true, sponsorIds: currentUser.sponsorIds);
        await questService.sortNearbyQuests();
        questService.extractAllQuestTypes();
      }
    } catch (e) {
      if (e is QuestServiceException) {
        setBusy(false);
        await dialogService.showDialog(
            title: "No quests", description: e.prettyDetails);
      } else {
        log.wtf(
            "An unknown error occured loading quests, this should never happen. Error: $e");
        await showGenericInternalErrorDialog();
      }
    }
    mapViewModel.extractStartMarkersAndAddToMap();
    setBusy(false);
  }
}
