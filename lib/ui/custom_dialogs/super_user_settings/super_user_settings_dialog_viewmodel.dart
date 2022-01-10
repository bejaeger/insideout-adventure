import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/helpers/quest_data_point.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';

class SuperUserSettingsDialogViewModel extends QuestViewModel {
  final QuestTestingService _questTestingService =
      locator<QuestTestingService>();

  bool get isRecordingLocationData =>
      _questTestingService.isRecordingLocationData;
  bool get isPermanentAdminMode => _questTestingService.isPermanentAdminMode;
  bool get isPermanentUserMode => _questTestingService.isPermanentUserMode;
  List<QuestDataPoint> get allRecordedLocations =>
      _questTestingService.allQuestDataPoints;
  bool addingPositionToNotionDB = false;
  bool get isAllPositionsPushed =>
      _questTestingService.allQuestDataPointsPushed();
  int get numberPushedLocations => _questTestingService.numberPushedLocations();

  void setIsRecordingLocationData(bool b) {
    _questTestingService.setIsRecordingLocationData(b);
    notifyListeners();
  }

  void resetLocationsList() {
    _questTestingService.resetLocationsList();
    notifyListeners();
  }

  void setIsPermanentAdminMode(bool b) {
    _questTestingService.setIsPermanentAdminMode(b);
    notifyListeners();
  }

  void setIsPermanentUserMode(bool b) {
    _questTestingService.setIsPermanentUserMode(b);
    notifyListeners();
  }

  Future pushAllPositionsToNotion() async {
    if (_questTestingService.allQuestDataPointsPushed()) {
      snackbarService.showSnackbar(
          title: "Done",
          message: "All data were already pushed to notion");
      return;
    }
    addingPositionToNotionDB = true;
    notifyListeners();
    bool ok = await _questTestingService.pushAllPositionsToNotion();
    showResponseInfo(ok);
    if (ok == false) {
      snackbarService.showSnackbar(title: "Failed uploading data", message: "Connect to a network and try again.");
    }
    addingPositionToNotionDB = false;
    notifyListeners();
  }

  void showResponseInfo(bool ok) {
    if (ok) {
      snackbarService.showSnackbar(
          title: "Success", message: "Added quest data to notion db");
    } else {
      snackbarService.showSnackbar(
          title: "Failure", message: "Connect to a network and try again");
    }
  }
}
