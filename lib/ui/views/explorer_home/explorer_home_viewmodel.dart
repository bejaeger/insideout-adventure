import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'dart:async';

class ExplorerHomeViewModel extends BaseModel {
  Future listenToData() async {
    setBusy(true);
    Completer completer = Completer<void>();
    userService.setupUserDataListeners(
        completer: completer, callback: () => super.notifyListeners());
    await completer.future;
    setBusy(false);
  }
}
