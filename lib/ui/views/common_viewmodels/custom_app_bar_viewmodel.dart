import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/exceptions/cloud_function_api_exception.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:afkcredits/app/app.logger.dart';

class CustomAppBarViewModel extends BaseModel {
  final DialogService _dialogService = locator<DialogService>();
  final _navigationService = locator<NavigationService>();

  final log = getLogger("CustomAppBarViewModel");
  Future finishQuest() async {
    try {
      final result = await questService.evaluateAndFinishQuest();
      if (result is String) {
        final continueQuest = await _dialogService.showConfirmationDialog(
            title: result.toString(),
            cancelTitle: "Cancel Quest",
            confirmationTitle: "Continue Quest");
        if (continueQuest?.confirmed == true) {
          await questService.continueIncompleteQuest();
        } else {
          //Running Quest Been Cancelled.
          checkRunningQuest = false;
          await questService.cancelIncompleteQuest();
          _navigationService.replaceWith(Routes.mapView);
          log.i("replaced view with mapView");
        }
      } else {
        await _dialogService.showDialog(
            title: "Congratz, you succesfully finished the quest!");
      }
    } catch (e) {
      if (e is CloudFunctionApiException) {
        await _dialogService.showDialog(
            title: e.prettyDetails, buttonTitle: 'Ok');
        return;
      } else {
        log.wtf("Could not finish quest, error thrown: $e");
      }
    }
  }
}
