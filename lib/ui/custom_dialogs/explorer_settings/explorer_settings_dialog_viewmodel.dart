import 'dart:io';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:arkit_plugin/arkit_plugin.dart';
import 'package:flutter/foundation.dart' show kIsWeb;

class ExplorerSettingsDialogViewModel extends BaseModel {
  // ----------------------------------------------
  // servies
  final AppConfigProvider appConfigProvider = locator<AppConfigProvider>();
  final MapViewModel mapViewModel = locator<MapViewModel>();
  // ----------------------------------------------
  // getters
  bool get isARAvailable => appConfigProvider.isARAvailable;
  bool get isUsingAR => appConfigProvider.isUsingAR;
  bool get isShowAvatarAndMapEffects =>
      appConfigProvider.isShowAvatarAndMapEffects;

  // -------------------------------------------------
  // functions

  void setIsShowAvatarAndMapEffects(bool b) async {
    print("b = $b");
    appConfigProvider.setIsShowingAvatarAndMapEffects(b);
    notifyListeners();
    mapViewModel.notifyListeners();
  }

  void setARFeatureEnabled(bool b) async {
    if (b == true && isARAvailable) {
      appConfigProvider.setIsUsingAR(true);
    } else {
      appConfigProvider.setIsUsingAR(false);
    }
    if (b == true && !isARAvailable) {
      await dialogService.showDialog(
          title: "AR feature not supported",
          description:
              "This device does not support augmented reality, unfortunately.");
    }
    notifyListeners();
  }
}
