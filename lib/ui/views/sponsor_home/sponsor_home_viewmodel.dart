import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/views/common_viewmodels/layout_template_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:afkcredits/app/app.logger.dart';

class SponsorHomeViewModel extends LayoutTemplateViewModel {
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final log = getLogger("SponsorHomeViewModel");
  final DialogService _dialogService = locator<DialogService>();
  List<User> get supportedExplorers => userService.supportedExplorersList;
  Map<String, UserStatistics> get supportedExplorerStats =>
      userService.supportedExplorerStats;

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

  Future startQuest() async {
    try {
      final quest = await questService.getQuest(questId: kTestQuestId);
      await questService.startQuest(quest: quest);
      snackbarService.showSnackbar(message: "Started quest");
    } catch (e) {
      log.e("Could not start quest, error thrown: $e");
    }
  }

  Future finishQuest() async {
    try {
      final result = await questService.evaluateAndFinishQuest();
      if (result is String) {
        final continueQuest = await _dialogService.showConfirmationDialog(
            title: result.toString(),
            cancelTitle: "Cancel Quest",
            confirmationTitle: "Continue");
        if (continueQuest?.confirmed == true) {
          await questService.continueIncompleteQuest();
        } else {
          await questService.cancelIncompleteQuest();
          await _dialogService.showDialog(title: "Quest cancelled");
        }
      } else {
        await _dialogService.showDialog(
            title: "Congratz, you succesfully finished the quest!");
      }
    } catch (e) {
      log.e("Could not finish quest, error thrown: $e");
    }
  }

  /////////////////////////////////////////////////
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

  ///////////////////////////////////////////////////
  // navigation

  void navigateToTransferHistoryView() async {
    setShowBottomNavBar(false);
    await navigationService.navigateTo(Routes.transfersHistoryView);
    setShowBottomNavBar(true);
  }

  void navigateToSingleExplorerView({required String uid}) async {
    setShowBottomNavBar(false);
    await navigationService.navigateTo(Routes.singleExplorerView,
        arguments: SingleExplorerViewArguments(uid: uid));
    setShowBottomNavBar(true);
  }
}
