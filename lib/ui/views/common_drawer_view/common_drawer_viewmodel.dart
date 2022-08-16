import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

import '../../../app/app.locator.dart';

class CommonDrawerViewModel extends BaseModel {
    final AppConfigProvider flavorConfigProvider = locator<AppConfigProvider>();

}
