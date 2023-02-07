import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';

class ExplorerSettingsDialogViewModel extends BaseModel {
  final String explorerUid;
  ExplorerSettingsDialogViewModel({required this.explorerUid});

  final AppConfigProvider appConfigProvider = locator<AppConfigProvider>();
  final MapViewModel mapViewModel = locator<MapViewModel>();

  bool get isARAvailable => appConfigProvider.isARAvailable;
  User? get explorer => userService.supportedExplorers[explorerUid];
  bool get isUsingAR => userService.isUsingAR;
  bool get isShowAvatarAndMapEffects => userService.isShowAvatarAndMapEffects;
  bool get isShowingCompletedQuests =>
      userService.currentUserSettings.isShowingCompletedQuests;

  void setIsShowAvatarAndMapEffects(bool b) async {
    userService.setIsShowingAvatarAndMapEffects(value: b);
    notifyListeners();
    mapViewModel.notifyListeners();
  }

  // ! Duplicated in raise_quest_bottom_sheet_viewmodel.dart
  void setIsShowingCompletedQuests(bool b) async {
    userService.setIsShowingCompletedQuests(value: b);
    mapViewModel.resetMapMarkers();
    mapViewModel.extractStartMarkersAndAddToMap();
    await Future.delayed(Duration(milliseconds: 50));
    mapViewModel.notifyListeners();
    notifyListeners();
  }

  void setARFeatureEnabled(bool b) async {
    if (b == true && isARAvailable) {
      userService.setIsUsingAr(value: true);
    } else {
      userService.setIsUsingAr(value: false);
    }
    if (b == true && !isARAvailable) {
      await dialogService.showDialog(
          title: "AR feature not supported",
          description:
              "We do not support augmented reality for this device, unfortunately.");
    }
    notifyListeners();
  }
}
