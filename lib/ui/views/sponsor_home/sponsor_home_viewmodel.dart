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

  void navigateToAddExplorerView() {
    _navigationService.navigateTo(Routes.addExplorerView);
  }
}
