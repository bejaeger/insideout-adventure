import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/transfer_base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';

class ParentHomeViewModel extends TransferBaseViewModel {
  // ----------------------------------------
  // services
  final ScreenTimeService _screenTimeService = locator<ScreenTimeService>();

  final log = getLogger("SponsorHomeViewModel");

  // -------------------------------------------------
  // getters
  List<User> get supportedExplorers => userService.supportedExplorersList;
  Map<String, UserStatistics> get childStats =>
      userService.supportedExplorerStats;
  List<ScreenTimeSession> get childScreenTimeSessionsActive =>
      userService.supportedExplorerScreenTimeSessionsActive;

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
    Completer completerOne = Completer<void>();
    //Completer completerTwo = Completer<void>();

    userService.setupUserDataListeners(
        completer: completerOne, callback: () => notifyListeners());
    await runBusyFuture(
      Future.wait(
        [
          completerOne.future,
          //completerTwo.future,
        ],
      ),
    );
    notifyListeners();
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

  // ----------------------------
  // navigation
  void navigateToScreenTimeOrSingleChildView({required String uid}) async {
    if (usingScreenTime(uid: uid)) {
      navToActiveScreenTimeView(sessionId: screenTimeSessionId);
    } else {
      navToSingleChildView(uid: uid);
    }
  }
}