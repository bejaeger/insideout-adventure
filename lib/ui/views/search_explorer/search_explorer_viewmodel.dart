import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/users/public_user_info.dart';
import 'package:afkcredits/ui/views/common_viewmodels/search_functionality_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';

class SearchExplorerViewModel extends SearchFunctionalityViewModel {
  List<PublicUserInfo> userInfoList = [];
  final BottomSheetService _bottomSheetService = locator<BottomSheetService>();
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();
  final log = getLogger("SearchExplorerViewModel");

  bool autofocus = true;

  Future selectUserAndProceed(PublicUserInfo data) async {
    autofocus = false;
    final uid = data.uid;
    log.i("Selected user with id = $uid");
    final result = await showConfirmationBottomSheet(data.name);
    if (result?.confirmed == true) {
      try {
        final result = await runBusyFuture(
            userService.addExplorerToSupportedExplorers(uid: uid));
        if (result is String) {
          await showFailureBottomSheet(result);
          return;
        }
      } catch (e) {
        log.e("$e");
      }
      await showSuccessBottomSheet();
      navigateBack();
    }
  }

  Future queryUsers(String queryString) async {
    try {
      userInfoList =
          await _firestoreApi.queryExplorers(queryString: queryString);
      notifyListeners();
    } catch (e) {
      log.e("Something went wrong when querying for the input '$queryString'");
    }
  }

  /////////////////////////////////////////////
  /// bottom sheets
  Future showConfirmationBottomSheet(String name) async {
    return await _bottomSheetService.showBottomSheet(
      barrierDismissible: true,
      title: 'Do you want to add explorer $name',
      confirmButtonTitle: 'Yes',
      cancelButtonTitle: 'No',
    );
  }

  Future showSuccessBottomSheet() async {
    await _bottomSheetService.showBottomSheet(
      barrierDismissible: true,
      title: 'Successfully added new explorer!',
    );
  }

  Future showFailureBottomSheet(String result) async {
    await _bottomSheetService.showBottomSheet(
      barrierDismissible: true,
      title: result.toString(),
    );
  }
}
