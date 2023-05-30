import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/datamodels/users/settings/user_settings.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';

class WardSettingsForGuardianDialogViewModel extends BaseModel {
  final String wardUid;
  late bool isAcceptScreenTimeFirstTmp;
  late bool isUsingOwnPhoneTmp;
  WardSettingsForGuardianDialogViewModel({required this.wardUid}) {
    // use local variables here so UI state is immediately updated.
    isAcceptScreenTimeFirstTmp = isAcceptScreenTimeFirst;
    isUsingOwnPhoneTmp = isUsingOwnPhone;
  }

  final AppConfigProvider appConfigProvider = locator<AppConfigProvider>();
  final MapViewModel mapViewModel = locator<MapViewModel>();

  bool get isARAvailable => appConfigProvider.isARAvailable;
  User? get ward => userService.supportedWards[wardUid];
  bool get isAcceptScreenTimeFirst =>
      (ward!.userSettings ?? UserSettings()).isAcceptScreenTimeFirst;
  bool get isUsingOwnPhone => (ward!.userSettings ?? UserSettings()).ownPhone;

  void setIsAcceptScreenTime(bool b) async {
    if (b == true && isUsingOwnPhone == false) {
      await dialogService.showDialog(
          title: "Not recommended",
          description:
              "Setting screen time verification to true is only possible when your child uses their own phone");
      return;
    }
    isAcceptScreenTimeFirstTmp = b;
    userService.setIsAcceptScreenTimeFirst(uid: wardUid, value: b);
    notifyListeners();
  }

  void setIsUsingOwnPhone(bool b) async {
    isUsingOwnPhoneTmp = b;
    userService.setIsUsingOwnPhone(uid: wardUid, value: b);
    notifyListeners();
  }

  void showChildPassword() async {
    await dialogService.showDialog(
        barrierDismissible: true,
        title: "Child password",
        description: "The password is: ${ward!.password}");
  }
}
