import 'package:afkcredits/enums/dialog_type.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class MainHeaderOverlayViewModel extends BaseModel {
  void handleLogoutEvent() async {
    // ! Very peculiar. Without this we get an error of
    // !_TypeError (type '_DropdownRouteResult<MenuItem>' is not a subtype of type 'SheetResponse<dynamic>?' of 'result')
    // ! From the navigator from the custom_drop_down_button
    await Future.delayed(Duration(milliseconds: 10));
    final result = await dialogService.showDialog(
        barrierDismissible: true,
        title: "Sure",
        description: "Are you sure you want to logout?",
        buttonTitle: "YES",
        cancelTitle: "NO");
    if (result?.confirmed == true) {
      logout();
    }
  }

  void showExplorerSettingsDialog() async {
    // ! Very peculiar. Without this we get an error of
    // !_TypeError (type '_DropdownRouteResult<MenuItem>' is not a subtype of type 'SheetResponse<dynamic>?' of 'result')
    // ! From the navigator from the custom_drop_down_button
    await Future.delayed(Duration(milliseconds: 10));
    await dialogService.showCustomDialog(
        variant: DialogType.ExplorerSettings, barrierDismissible: true);
  }
}
