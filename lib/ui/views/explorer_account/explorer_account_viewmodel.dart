import 'dart:async';

import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class ExplorerAccountViewModel extends BaseModel {
  final log = getLogger("ExplorerAccountViewModel");

  StreamSubscription? subscription;

  void listenToLayout() {
    if (subscription == null) {
      subscription =
          layoutService.isShowingExplorerAccountSubject.listen((show) {
        notifyListeners();
      });
    } else {
      log.wtf("isShowingExplorerAccount already listened to");
    }
  }

  // ! Duplicated in explorer_home_viewmodel.dart at the moment!
  Future showAndHandleAvatarSelection() async {
    final res = await dialogService.showCustomDialog(
      variant: DialogType.AvatarSelectDialog,
      barrierDismissible: true,
    );
    final characterNumber = res?.data;
    if (characterNumber is int) {
      log.i("Chose character with number $characterNumber");
      await setNewAvatarId(characterNumber);
      return true;
    } else {
      log.e("Selected data from avatar view is not an int!");
      return false;
    }
  }

  @override
  void dispose() {
    subscription?.cancel();
    subscription = null;
    super.dispose();
  }
}
