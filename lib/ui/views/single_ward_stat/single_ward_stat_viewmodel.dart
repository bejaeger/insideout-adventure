import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/data/app_strings.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/ui/views/common_viewmodels/switch_accounts_viewmodel.dart';
import 'package:afkcredits/utils/string_utils.dart';

class SingleWardStatViewModel extends SwitchAccountsViewModel {
  final String wardUid;
  SingleWardStatViewModel({required this.wardUid});

  final log = getLogger("SingleWardViewModel");

  User? get ward => userService.supportedWards[wardUid];
  UserStatistics get stats => userService.supportedWardStats[wardUid]!;
  List<dynamic> get sortedHistory => userService.sortedHistory(uid: wardUid);
  int? get totalWardScreenTimeLastDays =>
      userService.totalWardScreenTimeLastDays(uid: wardUid)[wardUid];
  int? get totalWardActivityLastDays =>
      userService.totalWardActivityLastDays(uid: wardUid)[wardUid];
  int? get totalWardScreenTimeTrend =>
      userService.totalWardScreenTimeTrend(uid: wardUid)[wardUid];
  int? get totalWardActivityTrend =>
      userService.totalWardActivityTrend(uid: wardUid)[wardUid];
  String get totalWardScreenTimeLastDaysString =>
      totalWardScreenTimeLastDays != null
          ? totalWardScreenTimeLastDays.toString()
          : "0";
  String get totalWardActivityLastDaysString =>
      totalWardActivityLastDays != null
          ? totalWardActivityLastDays.toString()
          : "0";

  String wardNameFromUid(String uid) {
    return userService.wardNameFromUid(uid);
  }

  ScreenTimeSession? getScreenTimeSession({required String uid}) {
    return screenTimeService.getActiveScreenTimeInMemory(uid: uid);
  }

  Future removeWardFromGuardianAccount() async {
    if (ward != null) {
      log.i("Remove user with id = ${ward!.uid}");
      // ! Very peculiar. Without this we get an error of
      // !_TypeError (type '_DropdownRouteResult<MenuItem>' is not a subtype of type 'SheetResponse<dynamic>?' of 'result')
      // ! From the navigator from the custom_drop_down_button
      await Future.delayed(Duration(milliseconds: 10));
      final confirmation = await showConfirmationBottomSheet(ward!.fullName);
      if (confirmation?.confirmed == true) {
        try {
          setBusy(true);
          final result =
              await userService.removeWardFromSupportedWards(uid: ward!.uid);
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
      log.wtf("Ward is null!");
    }
  }

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

  void showWardSettingsDialogDialog() async {
    // ! Very peculiar. Without this we get an error of
    // !_TypeError (type '_DropdownRouteResult<MenuItem>' is not a subtype of type 'SheetResponse<dynamic>?' of 'result')
    // ! From the navigator from the custom_drop_down_button
    await Future.delayed(Duration(milliseconds: 10));

    await dialogService.showCustomDialog(
      variant: DialogType.WardSettingsForGuardian,
      barrierDismissible: true,
      data: {
        "name": ward?.fullName,
        "wardUid": ward?.uid,
      },
    );
  }

  void showExplainCreditConversionDialog() async {
    await dialogService.showCustomDialog(
      variant: DialogType.CreditConversionInfo,
      barrierDismissible: true,
    );
  }

  void showWardStatDetailsDialog() async {
    await dialogService.showCustomDialog(
        variant: DialogType.WardStatCard,
        data: stats,
        barrierDismissible: true);
  }

  Future navigateToAddFundsView() async {
    if (ward != null) {
      await navigationService.navigateTo(Routes.transferFundsView,
          arguments: TransferFundsViewArguments(
              senderInfo: PublicUserInfo(
                  name: currentUser.fullName, uid: currentUser.uid),
              recipientInfo:
                  PublicUserInfo(name: ward!.fullName, uid: ward!.uid)));
      await Future.delayed(Duration(milliseconds: 300));
      notifyListeners();
    } else {
      log.wtf("No ward found!");
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
