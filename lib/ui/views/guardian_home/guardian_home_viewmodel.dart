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
import 'package:afkcredits/ui/views/common_viewmodels/switch_accounts_viewmodel.dart';

class GuardianHomeViewModel extends SwitchAccountsViewModel {
  final FeedbackService _feedbackService = locator<FeedbackService>();
  final log = getLogger("GuardianHomeViewModel");

  List<User> get supportedWards => userService.supportedWardsList;
  Map<String, UserStatistics> get wardStats => userService.supportedWardStats;
  List<ScreenTimeSession> get wardScreenTimeSessionsActive =>
      screenTimeService.supportedWardScreenTimeSessionsActive.values.toList();
  Map<String, ScreenTimeSession> get childScreenTimeSessionsActiveMap =>
      screenTimeService.supportedWardScreenTimeSessionsActive;
  List<dynamic> get sortedHistory => userService.sortedHistory();
  Map<String, int> get totalWardScreenTimeLastDays =>
      userService.totalWardScreenTimeLastDays();
  Map<String, int> get totalWardActivityLastDays =>
      userService.totalWardActivityLastDays();
  Map<String, int> get totalWardScreenTimeTrend =>
      userService.totalWardScreenTimeTrend();
  Map<String, int> get totalWardActivityTrend =>
      userService.totalWardActivityTrend();
  FeedbackCampaignInfo? get feedbackCampaignInfo =>
      _feedbackService.feedbackCampaignInfo;
  bool get userHasGivenFeedback => _feedbackService.userHasGivenFeedback();

  bool navigatingToActiveScreenTimeView = false;

  String wardNameFromUid(String uid) {
    return userService.wardNameFromUid(uid);
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
    // ! This is duplicated in ward_home_viewmodel.dart
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
      // This is a little hacky! This awaits for the previous guardian_home_viewmodel.dart to be disposed!
      // So that new guardian_home_viewmodel.dart can listen to it again
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
      return wardScreenTimeSessionsActive
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
        screenTimeService.supportedWardScreenTimeSessionsRequested.values);
    for (ScreenTimeSession session in sessionsRequested) {
      final res = await dialogService.showDialog(
        title: session.userName +
            " is requesting ${session.minutes} min screen time",
        buttonTitle: "ACCEPT",
        cancelTitle: "DON'T ALLOW",
      );
      if (screenTimeService.supportedWardScreenTimeSessionsRequested
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
          // when screen time request is cancelled at same time from ward!
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

  Future selectWardToSelectScreenTime() async {
    await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.selectWard,
      title: "Select child to set screen time",
      data: {
        "callback": ({required String wardUidSelected}) async {
          await navigateToSelectScreenTimeGuardianView(wardId: wardUidSelected);
        },
      },
    );
  }

  Future selectWardToSwitchAccount() async {
    await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.selectWard,
      title: "Select child account",
      data: {
        "callback": ({required String wardUidSelected}) async {
          await handleSwitchToWardEvent(wardUidSelected: wardUidSelected);
        },
      },
    );
  }

  Future selectWardToReward() async {
    await bottomSheetService.showCustomSheet(
      variant: BottomSheetType.selectWard,
      title: "Select child to reward",
      data: {
        "callback": ({required String wardUidSelected}) async {
          await navigateToAddFundsView(wardId: wardUidSelected);
        },
      },
    );
  }

  Future showFirstLoginDialog() async {
    await dialogService.showCustomDialog(
      variant: DialogType.OnboardingDialog,
    );
  }

  void navigateToScreenTimeOrSingleWardView({required String uid}) async {
    final session = getScreenTime(uid: uid);
    if (session != null) {
      navToActiveScreenTimeView(session: session);
    } else {
      navToSingleWardView(uid: uid);
    }
  }

  @override
  void dispose() {
    super.dispose();
    log.wtf("Disposed guardian_home_viewmodel.dart");
  }
}
