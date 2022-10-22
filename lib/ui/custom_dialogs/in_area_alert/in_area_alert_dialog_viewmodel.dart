import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class InAreaAlertDialogViewModel extends BaseModel {
  // ----------------------------------------------
  // servies
  final AppConfigProvider appConfigProvider = locator<AppConfigProvider>();

  // ----------------------------------------------
  // getters
  bool get isARAvailable => appConfigProvider.isARAvailable;
  bool get isUsingAR => userService.isUsingAR;

  // -------------------------------------------------
  // functions

}
