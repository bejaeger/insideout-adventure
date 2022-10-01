import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/enums/transfer_type.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/ui/views/common_viewmodels/switch_accounts_viewmodel.dart';
import 'package:afkcredits/utils/string_utils.dart';

// extend from switch account viewmodel for switch functionality
class SingleChildStatViewModel extends SwitchAccountsViewModel {
  final String explorerUid;
  SingleChildStatViewModel({required this.explorerUid});

  User? get explorer => userService.supportedExplorers[explorerUid];
  UserStatistics get stats => userService.supportedExplorerStats[explorerUid]!;

  // --------------------------------
  // services
  final log = getLogger("SingleExplorerViewModel");

  // ---------------------------------
  // getters
  List<dynamic> get sortedHistory =>
      userService.sortedHistory(uid: explorerUid);
  int? get totalChildScreenTimeLastDays =>
      userService.totalChildScreenTimeLastDays(uid: explorerUid)[explorerUid];
  int? get totalChildActivityLastDays =>
      userService.totalChildActivityLastDays(uid: explorerUid)[explorerUid];
  int? get totalChildScreenTimeTrend =>
      userService.totalChildScreenTimeTrend(uid: explorerUid)[explorerUid];
  int? get totalChildActivityTrend =>
      userService.totalChildActivityTrend(uid: explorerUid)[explorerUid];
  String get totalChildScreenTimeLastDaysString =>
      totalChildScreenTimeLastDays != null
          ? totalChildScreenTimeLastDays.toString()
          : "0";
  String get totalChildActivityLastDaysString =>
      totalChildActivityLastDays != null
          ? totalChildActivityLastDays.toString()
          : "0";

  // --------------------------------------
  // functions
  String explorerNameFromUid(String uid) {
    return userService.explorerNameFromUid(uid);
  }

  ScreenTimeSession? getScreenTimeSession({required String uid}) {
    return screenTimeService.getActiveScreenTimeInMemory(uid: uid);
  }

  // -----------------------------
  // remove child
  Future removeChildFromParentAccount() async {
    if (explorer != null) {
      log.i("Remove user with id = ${explorer!.uid}");
      // ! Very peculiar. Without this we get an error of
      // !_TypeError (type '_DropdownRouteResult<MenuItem>' is not a subtype of type 'SheetResponse<dynamic>?' of 'result')
      // ! From the navigator from the custom_drop_down_button
      await Future.delayed(Duration(milliseconds: 10));
      final confirmation =
          await showConfirmationBottomSheet(explorer!.fullName);
      log.i("WHAT IS HAPPENING");
      if (confirmation?.confirmed == true) {
        try {
          setBusy(true);
          final result = await userService.removeExplorerFromSupportedExplorers(
              uid: explorer!.uid);
          if (result is String) {
            await showFailureBottomSheet(result);
            return;
          }
        } catch (e) {
          log.e("$e");
        }
        await showSuccessBottomSheet();
        replaceWithHomeView();
      }
    } else {
      log.wtf("Explorer is null!");
    }
  }

  /////////////////////////////////////////////
  /// bottom sheets
  Future showConfirmationBottomSheet(String name) async {
    return await bottomSheetService.showBottomSheet(
      barrierDismissible: true,
      title: 'Remove $name from child list?',
      confirmButtonTitle: 'Yes',
      cancelButtonTitle: 'No',
    );
  }

  Future showSuccessBottomSheet() async {
    await bottomSheetService.showBottomSheet(
      barrierDismissible: true,
      title: 'Successfully removed user!',
    );
  }

  Future showFailureBottomSheet(String result) async {
    await bottomSheetService.showBottomSheet(
      barrierDismissible: true,
      title: result.toString(),
    );
  }

  // ---------------------------------
  // helpers
  void showHistoryItemInfoDialog(dynamic data) async {
    if (data is ActivatedQuest) {
      await dialogService.showDialog(
        title: "Finished: " + data.quest.name,
        description:
            "Successfully finished ${getShortQuestType(data.quest.type, noCaps: true)} and earned ${data.afkCreditsEarned} credits on " +
                formatDateDetailsType2(data.createdAt.toDate()),
      );
    } else if (data is ScreenTimeSession) {
      await dialogService.showDialog(
        title: "Used ${data.minutesUsed ?? data.minutes} min screen time",
        description: "Used screen time from " +
            formatDateDetailsType3(data.startedAt.toDate()) +
            " until " +
            formatDateDetailsType3(data.startedAt
                .toDate()
                .add(Duration(minutes: data.minutesUsed ?? data.minutes))),
      );
    }
  }

  void showExplainCreditConversionDialog() async {
    await dialogService.showCustomDialog(
      variant: DialogType.CreditConversionInfo,
      barrierDismissible: true,
    );
  }

  void showChildStatDetailsDialog() async {
    await dialogService.showCustomDialog(
        variant: DialogType.ChildStatCard,
        data: stats,
        barrierDismissible: true);
  }

  Future navigateToAddFundsView() async {
    //layoutService.setShowBottomNavBar(false);
    if (explorer != null) {
      await navigationService.navigateTo(Routes.transferFundsView,
          arguments: TransferFundsViewArguments(
              type: TransferType.Sponsor2ExplorerCredits,
              senderInfo: PublicUserInfo(
                  name: currentUser.fullName, uid: currentUser.uid),
              recipientInfo: PublicUserInfo(
                  name: explorer!.fullName, uid: explorer!.uid)));
      await Future.delayed(Duration(milliseconds: 300));
      //layoutService.setShowBottomNavBar(true);
      notifyListeners();
    } else {
      log.wtf("No explorer found!");
    }
  }

  Future refresh() async {
    notifyListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }
}
