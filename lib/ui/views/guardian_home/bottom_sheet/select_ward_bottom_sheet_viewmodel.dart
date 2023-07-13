import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class SelectWardBottomSheetViewModel extends BaseModel {
  List<User> get supportedWards => userService.supportedWardsList;
}
