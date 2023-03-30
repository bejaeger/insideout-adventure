import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/feedback/feedback_campaign_info.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/bottom_sheet_type.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/services/feedback_service/feedback_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class ParentHomeViewModel extends BaseModel {
  final FeedbackService _feedbackService = locator<FeedbackService>();
  final log = getLogger("ParentHomeViewModel");

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

  bool navigatingToActiveScreenTimeView = false;

  String explorerNameFromUid(String uid) {
    return userService.explorerNameFromUid(uid);
  }

  Future listenToData({ScreenTimeSession? screenTimeSession}) async {
    setBusy(true);
    Completer completerOne = Completer<void>();

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
            session = session.copyWith(startedAt: DateTime.now());
            await screenTimeService.acceptScreenTimeSession(session: session);
            session = await screenTimeService.startScreenTime(
                session: session, callback: () {});
            navToActiveScreenTimeView(session: session);
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

  void showSwitchAreaBottomSheet() async {
    await bottomSheetService.showCustomSheet(
        variant: BottomSheetType.switchArea);
  }

  Future showFirstLoginDialog() async {
    await dialogService.showCustomDialog(
      variant: DialogType.OnboardingDialog,
    );
  }

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
