import 'dart:async';

import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';

class QuestListOverlayViewModel extends QuestViewModel {
  StreamSubscription? subscription;

  void listenToLayout() {
    if (subscription == null) {
      subscription = layoutService.isShowingQuestListSubject.listen((show) {
        notifyListeners();
      });
    } else {
      log.wtf("isShowingQuestListSubject already listened to");
    }
  }

  // !!! THE SAME FUNCTION EXISTS IN WARD HOME VIEWMODEL!
  Future initializeQuests({bool? force}) async {
    setBusy(true);
    try {
      if (questService.sortedNearbyQuests == false || force == true) {
        await questService.loadNearbyQuests(
            force: true, guardianIds: currentUser.guardianIds);
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

  @override
  void dispose() {
    subscription?.cancel();
    subscription = null;
    super.dispose();
  }
}
