import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/layout/layout_service.dart';
import 'package:afkcredits/services/payments/transfers_history_service.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
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
  final DialogService dialogService = locator<DialogService>();
  final TransfersHistoryService transfersHistoryService =
      locator<TransfersHistoryService>();
  final LayoutService layoutService = locator<LayoutService>();
  final StopWatchService _stopWatchService = locator<StopWatchService>();
  StreamSubscription<int>? _timerSubscription;

  User get currentUser => userService.currentUser;
  UserStatistics get currentUserStats => userService.currentUserStats;
  bool get userIsAdmin => currentUser.role == UserRole.admin;

  final log = getLogger("BaseModel");
  bool get hasActiveQuest => questService.hasActiveQuest;
  // only access this
  ActivatedQuest get activeQuest => questService.activatedQuest!;
  String? seconds;
  String? hours;
  String? minutes;

  String get getActiveHours => hours!;
  String get getActiveMinutes => minutes!;
  String? get getActiveSeconds => seconds!;

  StreamSubscription<int>? get timeSubscription => _timerSubscription;

  void setTimer() {
    //Clock Timer
    final timerStream = _stopWatchService.stopWatchStream();

    _timerSubscription = timerStream.listen((int time) {
      hours = ((time / (60 * 60)) % 60).floor().toString().padLeft(2, '0');

      minutes = ((time / 60) % 60).floor().toString().padLeft(2, '0');

      seconds = (time % 60).floor().toString().padLeft(2, '0');
    });
    _stopWatchService.setTimerStreamSubscription(
        timerSubscription: _timerSubscription!);
    setBusy(false);
    notifyListeners();
  }

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
    questService.clearData();
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

  Future startQuest({required Quest quest}) async {
    try {
      /// Once The user Click on Start a Quest. It tks her/him to new Page
      /// Differents Markers will Display as Part of the quest as well The App showing the counting of the
      /// Quest.
      await questService.startQuest(quest: quest, uids: [currentUser.uid]);
      navigationService.replaceWith(Routes.activeQuestView);
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

  Future<bool> showAdminDialogAndGetResponse() async {
    bool adminMode = true;
    dynamic response = await dialogService.showDialog(
        title: "You are in admin mode!",
        description:
            "Do you want to continue with admin mode (to see qr codes, ...) or normal user mode?",
        cancelTitle: "User Mode",
        buttonTitle: "Admin Mode");
    if (response?.confirmed == true) {
      adminMode = true;
    } else {
      adminMode = false;
    }
    return adminMode;
  }

  //////////////////////////////////////////
  /// Clean-up
  @override
  void dispose() {
    _activeQuestSubscription?.cancel();
    _timerSubscription!.cancel();
    super.dispose();
  }
}
