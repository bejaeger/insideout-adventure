import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class OnBoardingScreensViewModel extends BaseModel {
  final AppConfigProvider _appConfigProvider = locator<AppConfigProvider>();

  String get versionName => _appConfigProvider.versionName;

}
