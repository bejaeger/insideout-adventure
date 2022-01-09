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

  bool get isAllPositionsPushed => _questTestingService.allLocationsPushed();
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
}
