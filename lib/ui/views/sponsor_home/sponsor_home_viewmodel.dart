import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/users/public_user_info.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/datamodels/users/user_statistics.dart';
import 'package:afkcredits/services/user_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:afkcredits/app/app.logger.dart';

class SponsorHomeViewModel extends BaseModel {
  final UserService _userService = locator<UserService>();
  List<User> get supportedExplorers => _userService.supportedExplorersList;
  Map<String, UserStatistics> get supportedExplorerStats =>
      _userService.supportedExplorerStats;

  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  final log = getLogger("SponsorHomeViewModel");
  // Listen to streams of latest donations and transactions to be displayed
  // instantly when pulling up bottom sheets
  Future listenToData() async {
    Completer completerOne = Completer<void>();
    _userService.setupUserDataListeners(
        completer: completerOne, callback: () => super.notifyListeners());
    await runBusyFuture(Future.wait([
      completerOne.future,
    ]));
    notifyListeners();
  }

  /////////////////////////////////////////////////
  // bottom sheets

  Future showAddExplorerBottomSheet() async {
    final result = await _bottomSheetService.showBottomSheet(
      barrierDismissible: true,
      title: 'Create new account or search for existing explorer?',
      confirmButtonTitle: 'Create New Account',
      cancelButtonTitle: 'Search',
    );
    if (result?.confirmed == true) {
      navigationService.navigateTo(Routes.addExplorerView);
    } else {
      navigationService.navigateTo(Routes.searchExplorerView);
    }
  }

  ///////////////////////////////////////////////////
  // navigation

  void navigateToAddExplorerView() {
    navigationService.navigateTo(Routes.addExplorerView);
  }

  void navigateToSingleExplorerView({required String uid}) {
    navigationService.navigateTo(Routes.singleExplorerView,
        arguments: SingleExplorerViewArguments(uid: uid));
  }
}
