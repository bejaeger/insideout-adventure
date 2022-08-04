import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/ui/views/common_viewmodels/transfer_base_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:afkcredits/app/app.logger.dart';

class ParentHomeViewModel extends TransferBaseViewModel with NavigationMixin {
  // ----------------------------------------
  // services
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final log = getLogger("SponsorHomeViewModel");

  // -------------------------------------------------
  // getters
  List<User> get supportedExplorers => userService.supportedExplorersList;
  Map<String, UserStatistics> get supportedExplorerStats =>
      userService.supportedExplorerStats;
  Map<String, List<ActivatedQuest>> get supportedExplorerQuestsHistory =>
      userService.supportedExplorerQuestsHistory;
  Map<String, List<ScreenTimeSession>>
      get supportedExplorerScreenTimeSessions =>
          userService.supportedExplorerScreenTimeSessions;
  List<ScreenTimeSession> get supportedExplorerScreenTimeSessionsActive =>
      userService.supportedExplorerScreenTimeSessionsActive;

  // Listen to streams of latest donations and transactions to be displayed
  // instantly when pulling up bottom sheets
  Future listenToData() async {
    Completer completerOne = Completer<void>();
    Completer completerTwo = Completer<void>();
    userService.setupUserDataListeners(
        completer: completerOne, callback: () => super.notifyListeners());
    transfersHistoryService.addTransferDataListener(
        config: queryConfig,
        completer: completerTwo,
        callback: () => super.notifyListeners());
    await runBusyFuture(Future.wait([
      completerOne.future,
      completerTwo.future,
    ]));
    notifyListeners();
  }

  // --------------------------------------------------
  // Helper functions

  List<ActivatedQuest> sortedExplorerQuestHistory() {
    // TODO: Also add screen time into the mix!
    List<ActivatedQuest> sortedQuests = [];
    supportedExplorerQuestsHistory.forEach((key, quests) {
      sortedQuests.addAll(quests);
    });
    sortedQuests
        .sort((a, b) => b.createdAt.toDate().compareTo(a.createdAt.toDate()));
    return sortedQuests;
  }

  List<ScreenTimeSession> sortedExplorerScreenTimeSessions() {
    List<ScreenTimeSession> sortedSessions = [];
    supportedExplorerScreenTimeSessions.forEach((key, session) {
      sortedSessions.addAll(session);
    });
    //try {
    sortedSessions
        .sort((a, b) => b.startedAt.toDate().compareTo(a.startedAt.toDate()));
    // } catch (e) {
    //   log.wtf(sortedSessions[0].startedAt);
    // }
    return sortedSessions;
  }

  String explorerNameFromUid(String uid) {
    for (User user in supportedExplorers) {
      if (user.uid == uid) {
        return user.fullName;
      }
    }
    return "";
  }

  // ------------------------------------------------------
  // bottom sheets

  Future showAddExplorerBottomSheet() async {
    setShowBottomNavBar(false);
    final result = await _bottomSheetService.showBottomSheet(
      barrierDismissible: true,
      title: 'Create new account or search for existing explorer?',
      confirmButtonTitle: 'Create New Account',
      cancelButtonTitle: 'Search',
    );
    if (result?.confirmed == true) {
      await navigationService.navigateTo(Routes.addExplorerView);
    } else if (result?.confirmed == false) {
      await navigationService.navigateTo(Routes.searchExplorerView);
    }
    setShowBottomNavBar(true);
  }

  // -------------------------------------------------
  // navigation

  void navigateToTransferHistoryView() async {
    setShowBottomNavBar(false);
    await navigationService.navigateTo(Routes.transfersHistoryView);
    setShowBottomNavBar(true);
  }

  void navigateToSingleExplorerView({required String uid}) async {
    setShowBottomNavBar(false);
    await navigationService.navigateTo(Routes.singleChildStatView,
        arguments: SingleChildStatViewArguments(uid: uid));
    setShowBottomNavBar(true);
  }
}
