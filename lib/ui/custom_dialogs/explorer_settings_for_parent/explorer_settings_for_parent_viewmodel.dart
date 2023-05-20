import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/datamodels/users/settings/user_settings.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';

class ExplorerSettingsForGuardianDialogViewModel extends BaseModel {
  final String explorerUid;
  late bool isAcceptScreenTimeFirstTmp;
  late bool isUsingOwnPhoneTmp;
  ExplorerSettingsForGuardianDialogViewModel({required this.explorerUid}) {
    // use local variables here so UI state is immediately updated.
    isAcceptScreenTimeFirstTmp = isAcceptScreenTimeFirst;
    isUsingOwnPhoneTmp = isUsingOwnPhone;
  }

  final AppConfigProvider appConfigProvider = locator<AppConfigProvider>();
  final MapViewModel mapViewModel = locator<MapViewModel>();

  bool get isARAvailable => appConfigProvider.isARAvailable;
  User? get explorer => userService.supportedExplorers[explorerUid];
  bool get isAcceptScreenTimeFirst =>
      (explorer!.userSettings ?? UserSettings()).isAcceptScreenTimeFirst;
  bool get isUsingOwnPhone =>
      (explorer!.userSettings ?? UserSettings()).ownPhone;

  void setIsAcceptScreenTime(bool b) async {
    if (b == true && isUsingOwnPhone == false) {
      await dialogService.showDialog(
          title: "Not recommended",
          description:
              "Setting screen time verification to true is only possible when your child uses his own phone");
      return;
    }
    isAcceptScreenTimeFirstTmp = b;
    userService.setIsAcceptScreenTimeFirst(uid: explorerUid, value: b);
    notifyListeners();
  }

  void setIsUsingOwnPhone(bool b) async {
    isUsingOwnPhoneTmp = b;
    userService.setIsUsingOwnPhone(uid: explorerUid, value: b);
    notifyListeners();
  }
}
