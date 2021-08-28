import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/services/layout/layout_service.dart';
import 'package:afkcredits/services/payments/transfers_history_service.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:afkcredits/app/app.logger.dart';
// The Basemodel
// All our ViewModels inherit from this class so
// put everything here that needs to be available throughout the
// entire App

class BaseModel extends BaseViewModel {
  final NavigationService navigationService = locator<NavigationService>();
  final UserService userService = locator<UserService>();
  final SnackbarService snackbarService = locator<SnackbarService>();
  final QuestService questService = locator<QuestService>();
  final TransfersHistoryService transfersHistoryService =
      locator<TransfersHistoryService>();
  final LayoutService layoutService = locator<LayoutService>();
  User get currentUser => userService.currentUser;

  final log = getLogger("BaseModel");
  bool get hasActiveQuest => questService.activatedQuest != null;
  // only access this
  ActivatedQuest get activeQuest => questService.activatedQuest!;
  int get numMarkersCollected =>
      activeQuest.markersCollected.where((element) => element == true).length;
  StreamSubscription? _activeQuestSubscription;

  BaseModel() {
    // listen to changes in wallet
    _activeQuestSubscription = questService.activatedQuestSubject.listen(
      (stats) {
        notifyListeners();
      },
    );
  }

  Future logout() async {
    // TODO: Check that there is no active quest present!
    await userService.handleLogoutEvent();
    transfersHistoryService.clearData();
    layoutService.setShowBottomNavBar(false);
    navigationService.clearStackAndShow(Routes.loginView);
  }

  Future setShowBottomNavBar(bool show) async {
    if (show == true) {
      await Future.delayed(Duration(milliseconds: 150));
    }
    layoutService.setShowBottomNavBar(show);
  }

  Future startQuest() async {
    try {
      final quest = await questService.getQuest(questId: kTestQuestId);
      await questService.startQuest(quest: quest);
    } catch (e) {
      log.e("Could not start quest, error thrown: $e");
    }
  }

  ////////////////////////////////////////
  // Navigation and dialogs
  void navigateBack() {
    navigationService.back();
  }

  void showNotImplementedSnackbar() {
    snackbarService.showSnackbar(
        title: "Not yet implemented.",
        message: "I know... it's sad",
        duration: Duration(seconds: 2));
  }

  //////////////////////////////////////////
  /// Clean-up
  @override
  void dispose() {
    _activeQuestSubscription?.cancel();
    super.dispose();
  }
}
