import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/views/common_viewmodels/switch_accounts_viewmodel.dart';

class SwitchAreaBottomSheetViewModel extends SwitchAccountsViewModel {
  List<User> get supportedWards => userService.supportedWardsList;
}
