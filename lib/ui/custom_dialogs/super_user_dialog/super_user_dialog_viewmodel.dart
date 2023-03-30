import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/datamodels/helpers/quest_data_point.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

class SuperUserDialogViewModel extends BaseModel {
  final QuestTestingService _questTestingService =
      locator<QuestTestingService>();
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final AppConfigProvider _flavorConfigProvider = locator<AppConfigProvider>();
  final _firestoreApi = locator<FirestoreApi>();

  bool get isRecordingLocationData =>
      _questTestingService.isRecordingLocationData;
  bool get isPermanentAdminMode => _questTestingService.isPermanentAdminMode;
  bool get isPermanentUserMode => _questTestingService.isPermanentUserMode;
  List<QuestDataPoint> get allRecordedLocations =>
      _questTestingService.allQuestDataPoints;
  bool addingPositionToNotionDB = false;
  bool get isAllPositionsPushed =>
      _questTestingService.isAllQuestDataPointsPushed();
  int get numberPushedLocations => _questTestingService.numberPushedLocations();
  bool get isListeningToPosition => _geolocationService.isListeningToLocation;
  bool get isListeningToMainPosition =>
      _geolocationService.isListeningToMainLocation;
  bool get allowDummyMarkerCollection =>
      _flavorConfigProvider.allowDummyMarkerCollection;
  bool get enableGPSVerification => _flavorConfigProvider.enableGPSVerification;
  bool get dummyQuestCompletionVerification =>
      _flavorConfigProvider.dummyQuestCompletionVerification;
  bool get isARAvailable => _flavorConfigProvider.isARAvailable;

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

  void setAllowDummyMarkerCollection(bool b) {
    _flavorConfigProvider.allowDummyMarkerCollection = b;
    notifyListeners();
  }

  void setEnableGPSVerification(bool b) {
    _flavorConfigProvider.enableGPSVerification = b;
    notifyListeners();
  }

  void setARFeatureEnabled(bool b) async {
    if (b == true) {
      // TODO: Add check for AR feature
      // if (kIsWeb ||
      //     !Platform.isAndroid ||
      //     !(await ArCoreController.checkArCoreAvailability()) ||
      //     !(await ArCoreController.checkIsArCoreInstalled())) {
      //   showNotImplementedSnackbar();
      //   return;
      // }
      return;
    }
    if (b == true && isARAvailable) {
      userService.setIsUsingAr(value: true);
    } else {
      userService.setIsUsingAr(value: false);
    }
    if (b == true && !isARAvailable) {
      snackbarService.showSnackbar(message: "AR not supported on this device.");
    }
    notifyListeners();
  }

  void setDummyQuestCompletionVerification(bool b) {
    _flavorConfigProvider.dummyQuestCompletionVerification = b;
    notifyListeners();
  }

  bool isCheating = false;
  void addAfkCreditsCheat() async {
    isCheating = true;
    notifyListeners();
    await _firestoreApi.changeAfkCreditsBalanceCheat(uid: currentUser.uid);
    isCheating = false;
    notifyListeners();
  }

  void deductAfkCreditsCheat() async {
    isCheating = true;
    notifyListeners();
    await _firestoreApi.changeAfkCreditsBalanceCheat(
        uid: currentUser.uid, deltaCredits: -50);
    isCheating = false;
    notifyListeners();
  }

  Future pushAllPositionsToNotion() async {
    if (_questTestingService.isAllQuestDataPointsPushed()) {
      snackbarService.showSnackbar(
          title: "Done", message: "All data were already pushed to notion");
      return;
    }
    addingPositionToNotionDB = true;
    notifyListeners();
    bool ok = await _questTestingService.pushAllPositionsToNotion();
    showResponseInfo(ok);
    if (ok == false) {
      snackbarService.showSnackbar(
          title: "Failed uploading data",
          message: "Connect to a network and try again.");
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
