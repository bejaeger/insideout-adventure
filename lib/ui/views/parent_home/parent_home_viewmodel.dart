import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/bottom_sheet_type.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/transfer_base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';

class ParentHomeViewModel extends TransferBaseViewModel {
  // ----------------------------------------
  // services

  final log = getLogger("ParentHomeViewModel");

  // -------------------------------------------------
  // getters
  List<User> get supportedExplorers => userService.supportedExplorersList;
  Map<String, UserStatistics> get childStats =>
      userService.supportedExplorerStats;
  List<ScreenTimeSession> get childScreenTimeSessionsActive =>
      screenTimeService.supportedExplorerScreenTimeSessionsActive.values
          .toList();
  Map<String, ScreenTimeSession> get childScreenTimeSessionsActiveMap =>
      screenTimeService.supportedExplorerScreenTimeSessionsActive;

  List<dynamic> get sortedHistory => userService.sortedHistory();
  Map<String, int> get totalChildScreenTimeLastDays =>
      userService.totalChildScreenTimeLastDays();
  Map<String, int> get totalChildActivityLastDays =>
      userService.totalChildActivityLastDays();
  Map<String, int> get totalChildScreenTimeTrend =>
      userService.totalChildScreenTimeTrend();
  Map<String, int> get totalChildActivityTrend =>
      userService.totalChildActivityTrend();

// ------------------------------
// state
  bool navigatingToActiveScreenTimeView = false;

  //  ---------------------------------
  String explorerNameFromUid(String uid) {
    return userService.explorerNameFromUid(uid);
  }

  // -------------------------------------------------
  // Listen to streams of latest donations and transactions to be displayed
  // instantly when pulling up bottom sheets
  Future listenToData({ScreenTimeSession? screenTimeSession}) async {
    // navToActiveScreenTimeView is true when a notification is
    // clicked!
    if (screenTimeSession != null) {
      navigatingToActiveScreenTimeView = true;
    }
    Completer completerOne = Completer<void>();

    // adds several listeners to user data including the data from the supported explorers
    userService.setupUserDataListeners(
        completer: completerOne, callback: () => notifyListeners());
    await runBusyFuture(
      Future.wait(
        [
          completerOne.future,
        ],
      ),
    );

    // if screenTimeSession is null we want to navigate to that particular one!
    // ! This is duplicated in explorer_home_viewmodel.dart
    if (screenTimeSession != null) {
      log.v("started with non-null ScreenTimeSession");
      await screenTimeService.listenToPotentialScreenTimes(
          callback: notifyListeners);
      ScreenTimeSession? session =
          await screenTimeService.getSpecificScreenTime(
        uid: screenTimeSession.uid,
        sessionId: screenTimeSession.sessionId,
      );
      if (session != null) {
        await navToActiveScreenTimeView(session: session);
      } else {
        log.wtf(
            "NO screen time session found. This should never be the case. ");
      }
      navigatingToActiveScreenTimeView = false;
      notifyListeners();
    } else {
      // don't need to await for it
      screenTimeService.listenToPotentialScreenTimes(callback: notifyListeners);
      notifyListeners();
    }
  }

  ScreenTimeSession? getScreenTime({required String uid}) {
    try {
      return childScreenTimeSessionsActive
          .firstWhere((element) => element.uid == uid);
    } catch (e) {
      if (e is StateError) // thrown when no element was found
      {
        return null;
      } else {
        rethrow;
      }
    }
  }

  // ------------------------------------------------------
  // bottom sheets
  Future showAddExplorerBottomSheet() async {
    // ! NOT FOR MVP
    // final result = await _bottomSheetService.showBottomSheet(
    //   barrierDismissible: true,
    //   title: 'Create new account or search for existing child account?',
    //   confirmButtonTitle: 'Create New Child Account',
    //   cancelButtonTitle: 'Search',
    // );
    // if (result?.confirmed == true) {
    //   await navigationService.navigateTo(Routes.addExplorerView);
    // } else if (result?.confirmed == false) {
    //   await navigationService.navigateTo(Routes.searchExplorerView);
    // }
    // ! FOR MVP WE ONLY ALLOW CREATING CHILD ACCOUNTS
    await navigationService.navigateTo(Routes.addExplorerView);
  }

  Future setNewUserPropertyToFalse() async {
    log.i("Setting 'new user' property to false");
    userService.setNewUserPropertyToFalse(user: currentUser);
  }

  void showSwitchAreaBottomSheet() async {
    await bottomSheetService.showCustomSheet(
        variant: BottomSheetType.switchArea);
  }

  Future showFirstLoginDialog() async {
    await dialogService.showCustomDialog(
      variant: DialogType.OnboardingDialog,
    );
  }

  // ----------------------------
  // navigation
  void navigateToScreenTimeOrSingleChildView({required String uid}) async {
    final session = getScreenTime(uid: uid);
    if (session != null) {
      navToActiveScreenTimeView(session: session);
    } else {
      navToSingleChildView(uid: uid);
    }
  }
}
