import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/services/user_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

class SponsorHomeViewModel extends BaseModel {
  final UserService _userService = locator<UserService>();
  final NavigationService _navigationService = locator<NavigationService>();
  List<User> get supportedExplorers => _userService.supportedExplorers;
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();

  // Listen to streams of latest donations and transactions to be displayed
  // instantly when pulling up bottom sheets
  Future listenToData() async {
    Completer completerOne = Completer<void>();
    _userService.addExplorerListener(
        completer: completerOne, callback: () => notifyListeners());
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
      _navigationService.navigateTo(Routes.addExplorerView);
    } else {
      _navigationService.navigateTo(Routes.searchExplorerView);
    }
  }

  ///////////////////////////////////////////////////
  // navigation

  void navigateToAddExplorerView() {
    _navigationService.navigateTo(Routes.addExplorerView);
  }
}
