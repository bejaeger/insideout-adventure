import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/quest_view_index.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/exceptions/quest_service_exception.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:stacked_services/stacked_services.dart';

import '../../../app/app.locator.dart';

class QuestsOverviewViewModel extends QuestViewModel {
  List<QuestType> get questTypes => questService.allQuestTypes;
  final logger = getLogger('ManageQuestViewModel');
  final _dialogService = locator<DialogService>();
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

  void navigateToQuestViews({required int index}) {
    switch (index) {
      case 0:
        logger.i('User is Navigating to $navToCreateQuest');
        navToCreateQuest();
        break;
      case 1:
        logger.i('User is Navigating to $navToQuestOverView');
        _dialogService.showDialog();

        // navToQuestOverView();
        break;
      case 2:
        logger.i('User is Navigating to $navToQuestOverView');
        //navToQuestOverView();
        break;
      default:
        logger.i('User is Navigating to $navToCreateQuest');

        navToCreateQuest();
        break;
    }
  }
}
