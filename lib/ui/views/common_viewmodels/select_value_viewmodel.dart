import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:stacked/stacked.dart';

abstract class SelectValueViewModel extends FormViewModel with NavigationMixin {
  final UserService _userService = locator<UserService>();
  final log = getLogger("SelectValueViewModel");

  User get currentUser => _userService.currentUser;

  num? amount;
  num? equivalentValue;

  final PublicUserInfo recipientInfo;
  final PublicUserInfo senderInfo;
  SelectValueViewModel({required this.recipientInfo, required this.senderInfo});

  // The functionality from stacked's form view is
  // not working properly (not sure exactly why).
  // This has to do with how we wrap the entire
  // App with the Unfocuser, see main.dart.
  // For the time being we just use our own validation
  // message string
  String? customValidationMessage;
  void setCustomValidationMessage(String msg) {
    print("SETTING VAL MESSAGE");
    customValidationMessage = msg;
  }
}
