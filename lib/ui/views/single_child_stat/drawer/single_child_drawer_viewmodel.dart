import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class SingleChildDrawerViewModel extends BaseModel {
  // services
  final log = getLogger("SingleChildDrawerViewModel");

  // constructor
  final User? explorer;
  SingleChildDrawerViewModel({required this.explorer});

  Future removeChildFromParentAccount() async {
    if (explorer != null) {
      log.i("Selected user with id = ${explorer!.uid}");
      final result = await showConfirmationBottomSheet(explorer!.fullName);
      if (result?.confirmed == true) {
        try {
          final result = await runBusyFuture(userService
              .removeExplorerFromSupportedExplorers(uid: explorer!.uid));
          if (result is String) {
            await showFailureBottomSheet(result);
            return;
          }
        } catch (e) {
          log.e("$e");
        }
        await showSuccessBottomSheet();
        replaceWithHomeView();
      }
    } else {
      log.wtf("Explorer is null!");
    }
  }

  /////////////////////////////////////////////
  /// bottom sheets
  Future showConfirmationBottomSheet(String name) async {
    return await bottomSheetService.showBottomSheet(
      barrierDismissible: true,
      title: 'Do you want to remove user with name $name',
      confirmButtonTitle: 'Yes',
      cancelButtonTitle: 'No',
    );
  }

  Future showSuccessBottomSheet() async {
    await bottomSheetService.showBottomSheet(
      barrierDismissible: true,
      title: 'Successfully removed user!',
    );
  }

  Future showFailureBottomSheet(String result) async {
    await bottomSheetService.showBottomSheet(
      barrierDismissible: true,
      title: result.toString(),
    );
  }
}
