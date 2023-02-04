import 'package:afkcredits/constants/hercules_world_credit_system.dart';
import 'package:stacked/stacked.dart';
import 'package:afkcredits/ui/shared/custom_dialogs/custom_screen_time_dialog_view.form.dart';
import 'package:afkcredits/app/app.logger.dart';

class CustomScreenTimeDialogViewModel extends FormViewModel {
  final log = getLogger("CustomScreenTimeDialogViewModel");

  int? minutes;
  num? creditsEquivalent;

  bool isValidData() {
    bool returnValue = true;
    if (timeValue == null || timeValue == "") {
      log.w("No valid amount");
      returnValue = false;
      setCustomValidationMessage("Please enter valid amount.");
    }
    if (int.tryParse(timeValue!) == null) {
      log.w("amount not int");
      returnValue = false;
      setCustomValidationMessage("Please enter a positive whole number.");
    }
    return returnValue;
  }

  String? customValidationMessage;
  void setCustomValidationMessage(String msg) {
    customValidationMessage = msg;
    notifyListeners();
  }

  @override
  void setFormStatus() {
    if (timeValue != null && timeValue != "") {
      if (isValidData()) {
        int tmpTime = int.parse(timeValue!);
        creditsEquivalent =
            HerculesWorldCreditSystem.screenTimeToCredits(tmpTime);
        minutes = tmpTime;
      }
    }
  }
}
