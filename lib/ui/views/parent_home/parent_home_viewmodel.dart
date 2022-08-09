import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/views/common_viewmodels/transfer_base_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:afkcredits/app/app.logger.dart';

class ParentHomeViewModel extends TransferBaseViewModel {
  // ----------------------------------------
  // services
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final log = getLogger("SponsorHomeViewModel");

  // -------------------------------------------------
  // getters
  List<User> get supportedExplorers => userService.supportedExplorersList;
  Map<String, UserStatistics> get childStats =>
      userService.supportedExplorerStats;
  Map<String, List<ActivatedQuest>> get childQuestsHistory =>
      userService.supportedExplorerQuestsHistory;
  Map<String, List<ScreenTimeSession>> get childScreenTimeSessions =>
      userService.supportedExplorerScreenTimeSessions;
  List<ScreenTimeSession> get childScreenTimeSessionsActive =>
      userService.supportedExplorerScreenTimeSessionsActive;

  // Listen to streams of latest donations and transactions to be displayed
  // instantly when pulling up bottom sheets
  Future listenToData() async {
    Completer completerOne = Completer<void>();
    //Completer completerTwo = Completer<void>();
    userService.setupUserDataListeners(
        completer: completerOne, callback: () => super.notifyListeners());
    await runBusyFuture(Future.wait([
      completerOne.future,
      //completerTwo.future,
    ]));
    notifyListeners();
  }

  // --------------------------------------------------
  // Helper functions

  List<ActivatedQuest> childQuestHistory() {
    // TODO: Also add screen time into the mix!
    List<ActivatedQuest> sortedQuests = [];
    childQuestsHistory.forEach((key, quests) {
      sortedQuests.addAll(quests);
    });
    sortedQuests
        .sort((a, b) => b.createdAt.toDate().compareTo(a.createdAt.toDate()));
    return sortedQuests;
  }

  List<ScreenTimeSession> sortedChildScreenTimeSessions() {
    List<ScreenTimeSession> sortedSessions = [];
    childScreenTimeSessions.forEach((key, session) {
      sortedSessions.addAll(session);
    });
    sortedSessions
        .sort((a, b) => b.startedAt.toDate().compareTo(a.startedAt.toDate()));
    return sortedSessions;
  }

  List<dynamic> sortedHistory() {
    List<dynamic> list = [
      ...sortedChildScreenTimeSessions(),
      ...childQuestHistory()
    ];
    list.sort((a, b) {
      DateTime? date1;
      DateTime? date2;
      if (a is ActivatedQuest)
        date1 = a.createdAt.toDate();
      else
        date1 = a.startedAt.toDate();
      if (b is ActivatedQuest)
        date2 = b.createdAt.toDate();
      else
        date2 = b.startedAt.toDate();
      return date2!.compareTo(date1!);
    });
    return list;
  }

  Map<String, int> totalChildScreenTimeLastDays(
      {int deltaDays = 7, int daysAgo = 0}) {
    Map<String, int> screenTime = {};
    childScreenTimeSessions.forEach((key, session) {
      session.forEach((element) {
        if (DateTime.now().difference(element.startedAt.toDate()).inDays >=
                daysAgo &&
            DateTime.now().difference(element.startedAt.toDate()).inDays <
                daysAgo + deltaDays) {
          if (screenTime.containsKey(element.uid)) {
            screenTime[element.uid] =
                screenTime[element.uid]! + element.minutes;
          } else {
            screenTime[element.uid] = element.minutes;
          }
        }
      });
    });
    return screenTime;
  }

  Map<String, int> totalChildActivityLastDays(
      {int deltaDays = 7, int daysAgo = 0}) {
    Map<String, int> activity = {};
    childQuestsHistory.forEach((key, session) {
      session.forEach((element) {
        if (DateTime.now().difference(element.createdAt.toDate()).inDays >=
                daysAgo &&
            DateTime.now().difference(element.createdAt.toDate()).inDays <
                daysAgo + deltaDays) {
          if (activity.containsKey(element.uids![0])) {
            // still multiple uids supported
            activity[element.uids![0]] = activity[element.uids![0]]! +
                (element.timeElapsed / 60).round();
          } else {
            activity[element.uids![0]] = (element.timeElapsed / 60).round();
          }
        }
      });
    });
    return activity;
  }

  Map<String, int> totalChildScreenTimeTrend(
      {int deltaDays = 7, int daysAgo = 7}) {
    Map<String, int> lastWeek =
        totalChildScreenTimeLastDays(deltaDays: deltaDays, daysAgo: 0);
    Map<String, int> previousWeek =
        totalChildScreenTimeLastDays(deltaDays: deltaDays, daysAgo: 7);
    Map<String, int> delta = {};
    for (String k in lastWeek.keys) {
      delta[k] = (lastWeek[k] ?? 0) - (previousWeek[k] ?? 0);
    }
    return delta;
  }

  Map<String, int> totalChildActivityTrend(
      {int deltaDays = 7, int daysAgo = 7}) {
    Map<String, int> lastWeek =
        totalChildActivityLastDays(deltaDays: deltaDays, daysAgo: 0);
    Map<String, int> previousWeek =
        totalChildActivityLastDays(deltaDays: deltaDays, daysAgo: 7);
    Map<String, int> delta = {};
    for (String k in lastWeek.keys) {
      delta[k] = (lastWeek[k] ?? 0) - (previousWeek[k] ?? 0);
    }
    return delta;
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
      title: 'Create new account or search for existing child account?',
      confirmButtonTitle: 'Create New Child Account',
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

  void navigateToSingleExplorerView({required String uid}) async {
    setShowBottomNavBar(false);
    await navigationService.navigateTo(Routes.singleChildStatView,
        arguments: SingleChildStatViewArguments(uid: uid));
    setShowBottomNavBar(true);
  }
}
