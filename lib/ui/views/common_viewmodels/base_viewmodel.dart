import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/quests/active_quests/active_quest.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/services/layout/layout_service.dart';
import 'package:afkcredits/services/payments/transfers_history_service.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

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

  bool get hasActiveQuest => questService.activeQuest != null;
  // only access this
  ActiveQuest get activeQuest => questService.activeQuest!;

  StreamSubscription? _activeQuestSubscription;

  BaseModel() {
    // listen to changes in wallet
    _activeQuestSubscription = questService.activeQuestSubject.listen(
      (stats) {
        notifyListeners();
      },
    );
  }

  Future logout() async {
    await userService.handleLogoutEvent();
    transfersHistoryService.clearData();
    layoutService.setShowBottomNavBar(false);
    navigationService.clearStackAndShow(Routes.loginView);
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
