import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/feedback/feedback_campaign_info.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/bottom_sheet_type.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/services/feedback_service/feedback_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/transfer_base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';

class ParentHomeViewModel extends TransferBaseViewModel {
  // ----------------------------------------
  // services
  final FeedbackService _feedbackService = locator<FeedbackService>();
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
  FeedbackCampaignInfo? get feedbackCampaignInfo =>
      _feedbackService.feedbackCampaignInfo;
  bool get userHasGivenFeedback => _feedbackService.userHasGivenFeedback();

  // ------------------------------
  // state
  bool navigatingToActiveScreenTimeView = false;

  //  ---------------------------------
  // functions
  String explorerNameFromUid(String uid) {
    return userService.explorerNameFromUid(uid);
  }

  // -------------------------------------------------
  // Listen to streams of latest donations and transactions to be displayed
  // instantly when pulling up bottom sheets
  Future listenToData({ScreenTimeSession? screenTimeSession}) async {
    // reset this flag! needed if we use parent_home_viewmodel.dart as singleton!
    // navigatingToActiveScreenTimeView = false;

    // ! Using this sometimes makes the screen stuck in loading state
    // ! When clicking expired screen time notification after a longer time
    // navToActiveScreenTimeView is true when a notification is
    // clicked!
    // if (screenTimeSession != null) {
    //   navigatingToActiveScreenTimeView = true;
    // }
    setBusy(true);
    Completer completerOne = Completer<void>();

    // adds several listeners to user data including the data from the supported explorers
    userService.setupUserDataListeners(
        completer: completerOne,
        callback: () => notifyListeners(),
        screenTimeRequestDialogCallback: showScreenTimeRequestDialog);
    await runBusyFuture(
      Future.wait(
        [
          completerOne.future,
          _feedbackService.loadFeedbackCampaignInfo(),
        ],
      ),
    );

    // if screenTimeSession is null we want to navigate to that particular one!
    // ! This is duplicated in explorer_home_viewmodel.dart
    if (screenTimeSession != null) {
      log.v("started with non-null ScreenTimeSession");

      // this will handle the current screen time!
      await screenTimeService.listenToPotentialScreenTimes(
          callback: notifyListeners);
      ScreenTimeSession? session;
      try {
        session = await screenTimeService.getSpecificScreenTime(
          uid: screenTimeSession.uid,
          sessionId: screenTimeSession.sessionId,
        );
      } catch (e) {
        log.wtf(
            "NO screen time session found. This should never be the case. Error: $e");
      }
      if (session != null) {
        await navToActiveScreenTimeView(session: session);
      }
      // } else {
      //   await dialogService.showDialog(
      //       title: "Screen time session not found",
      //       description:
      //           "An error occured loading the screen time. A restart of the app should fix this.");
      // }
      //navigatingToActiveScreenTimeView = false;
      notifyListeners();
    } else {
      // don't need to await for it
      // This is a little hacky! This awaits for the previous parent_home_viewmodel.dart to be disposed!
      // So that new parent_home_viewmodel.dart can listen to it again
      // Alternative might be to have a viewmodel that does not dispose at all and is a singleton!
      // await Future.delayed(Duration(milliseconds: 500));
      // For now, we go with the singleton. Seems to perform stable!
      screenTimeService.listenToPotentialScreenTimes(callback: notifyListeners);
      notifyListeners();
    }
    setBusy(false);
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

  Future showScreenTimeRequestDialog() async {
    List<ScreenTimeSession> sessionsRequested = List.from(
        screenTimeService.supportedExplorerScreenTimeSessionsRequested.values);
    for (ScreenTimeSession session in sessionsRequested) {
      final res = await dialogService.showDialog(
        title: session.userName +
            " is requesting ${session.minutes} min screen time",
        buttonTitle: "ACCEPT",
        cancelTitle: "DON'T ALLOW",
      );
      if (screenTimeService.supportedExplorerScreenTimeSessionsRequested
          .containsKey(session.uid)) {
        try {
          if (res?.confirmed == true) {
            // somehow need to check if screen time was not cancelled in exactly this moment!
            session = session.copyWith(startedAt: DateTime.now());
            await screenTimeService.acceptScreenTimeSession(session: session);
            session = await screenTimeService.startScreenTime(
                session: session, callback: () {});
            navToActiveScreenTimeView(session: session);
            // maybe also start with counter!? not clear!
            // navToScreenTimeCounterView(session: session);
          } else {
            await screenTimeService.denyScreenTimeSession(session: session);
          }
        } catch (e) {
          log.wtf("Error dealing with screen time request: $e");
          // when screen time request is cancelled at same time from child!
          await dialogService.showDialog(
              title: "Screen time request was cancelled",
              description: session.userName + " cancelled the request already",
              barrierDismissible: true);
        }
      } else {
        await dialogService.showDialog(
            title: "Screen time request was cancelled",
            description: session.userName + " cancelled the request already",
            barrierDismissible: true);
      }
    }
  }

  // ------------------------------------------------------
  // bottom sheets
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

  @override
  void dispose() {
    super.dispose();
    log.wtf("Disposed parent_home_viewmodel.dart");
  }
}
