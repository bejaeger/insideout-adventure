import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/bottom_sheet_type.dart';
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

  //  ---------------------------------
  String explorerNameFromUid(String uid) {
    return userService.explorerNameFromUid(uid);
  }

  // -------------------------------------------------
  // Listen to streams of latest donations and transactions to be displayed
  // instantly when pulling up bottom sheets
  Future listenToData() async {
    //setBusy(true);
    Completer completerOne = Completer<void>();
    userService.setupUserDataListeners(
        completer: completerOne, callback: () => notifyListeners());
    await runBusyFuture(
      Future.wait(
        [
          completerOne.future,
        ],
      ),
    );
    // ! This is important
    // ! We continue listening to screen time sessions here!
    // TODO: Should do the same on explorer account
    log.i(
        "Length active screen time ${screenTimeService.supportedExplorerScreenTimeSessionsActive.length}");
    screenTimeService.supportedExplorerScreenTimeSessionsActive.forEach(
      (key, value) {
        // also starts listeners
        screenTimeService.continueOrBookkeepScreenTimeSessionOnStartup(
          session: value,
          callback: () {
            log.i(
                "Listened to screen time event of user with name ${value.userName}");
            notifyListeners();
          },
        );
      },
    );
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

  void showSwitchAreaBottomSheet() async {
    await bottomSheetService.showCustomSheet(
        variant: BottomSheetType.switchArea);
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
