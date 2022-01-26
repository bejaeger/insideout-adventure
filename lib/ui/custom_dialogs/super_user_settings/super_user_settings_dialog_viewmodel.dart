import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/helpers/location_entry.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class SuperUserSettingsDialogViewModel extends BaseModel {
  final QuestTestingService _questTestingService =
      locator<QuestTestingService>();

  bool get isRecordingLocationData =>
      _questTestingService.isRecordingLocationData;
  bool get isPermanentAdminMode => _questTestingService.isPermanentAdminMode;
  bool get isPermanentUserMode => _questTestingService.isPermanentUserMode;
  List<LocationEntry> get allRecordedLocations =>
      _questTestingService.allLocations;

  void setIsRecordingLocationData(bool b) {
    _questTestingService.setIsRecordingLocationData(b);
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
