import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/exceptions/geolocation_service_exception.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_state_control_mixin.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';

abstract class QuestViewModel extends BaseModel with MapStateControlMixin {
  final log = getLogger("QuestViewModel");

  // -----------------------------------------------
  // Setters
  final GeolocationService _geolocationService = locator<GeolocationService>();
  final AppConfigProvider appConfigProvider = locator<AppConfigProvider>();
  final QRCodeService qrCodeService = locator<QRCodeService>();

  final MapViewModel mapViewModel = locator<MapViewModel>();

  // ------------------------------------------
  // Getters
  bool get isDevFlavor => appConfigProvider.flavor == Flavor.dev;
  List<Quest> get nearbyQuests => questService.getNearByQuest;

  // -----------------------------------------
  // State
  List<double> distancesFromQuests = [];

  // ---------------------------------------
  // Methods

  List<Quest> getQuestsOfType({required QuestType type}) {
    return questService.extractQuestsOfType(
        quests: nearbyQuests, questType: type);
  }

  Future getLocation(
      {bool forceAwait = false, bool forceGettingNewPosition = true}) async {
    try {
      if (_geolocationService.getUserLivePositionNullable == null) {
        await _geolocationService.getAndSetCurrentLocation(
            forceGettingNewPosition: forceGettingNewPosition);
      } else {
        if (forceAwait) {
          await _geolocationService.getAndSetCurrentLocation(
              forceGettingNewPosition: forceGettingNewPosition);
        } else {
          _geolocationService.getAndSetCurrentLocation(
              forceGettingNewPosition: forceGettingNewPosition);
        }
      }
    } catch (e) {
      if (e is GeolocationServiceException) {
        // if (kIsWeb) {
        //   await dialogService.showDialog(
        //       title: "Sorry", description: "Map not supported on PWA version");
        // } else {
        if (appConfigProvider.enableGPSVerification) {
          await dialogService.showDialog(
              title: "Sorry", description: e.prettyDetails);
        } else {
          if (!shownDummyModeDialog) {
            await dialogService.showDialog(
                title: "Dummy mode active",
                description:
                    "GPS connection not available, you can still try out the quests by tapping on the markers");
            shownDummyModeDialog = true;
          }
        }
        // }
      } else {
        log.wtf("Could not get location of user");
        await showGenericInternalErrorDialog();
      }
    }
  }

/*   Future getDistancesToStartOfQuests() async {
    if (nearbyQuests.isNotEmpty) {
      log.i("Check distances for current quest list");

      // need to use normal for loop to await results
      for (var i = 0; i < nearbyQuests.length; i++) {
        if (nearbyQuests[i].startMarker != null) {
          double distance =
              await _geolocationService.distanceBetweenUserAndCoordinates(
                  lat: nearbyQuests[i].startMarker!.lat,
                  lon: nearbyQuests[i].startMarker!.lon);
          nearbyQuests[i] =
              nearbyQuests[i].copyWith(distanceFromUser: distance);
        }
      }
    } else {
      log.w(
          "Curent quests empty, or distance check not required. Can't check distances");
    }
    log.i("Notify listeners");
    notifyListeners();
  } */

  Future onQuestInListTapped(Quest quest) async {
    if (hasActiveQuest == false) {
      removeQuestListOverlay();
      changeNavigatedFromQuestList(true);
      showQuestDetailsFromList(quest: quest);
      //await navigateToActiveQuestUI(quest: quest);

      // ! This notify listeners is important as the
      // ! the view renders the state based on whether a quest is active or not
      //notifyListeners();
    } else {
      dialogService.showDialog(title: "You currently have a running quest!");
    }
  }

  // TODO: MAYBE this can go into the base_viewmodel as it's needed also in other screens!
  Future scanQrCode() async {
    // navigate to qr code view, validate results in quest service, and continue
    MarkerAnalysisResult result = await navigateToQrcodeViewAndReturnResult();
    if (result.isEmpty) {
      log.wtf("The object QuestQRCodeScanResult is empty!");
      return;
    }
    if (result.hasError) {
      log.e("Error occured: ${result.errorMessage}");
      dialogService.showDialog(
        title: "Failed to collect marker!",
        description: result.errorMessage!,
      );
      return;
    }
    return await handleMarkerAnalysisResult(result);
  }

  Future<MarkerAnalysisResult> navigateToQrcodeViewAndReturnResult() async {
    final marker = await navigationService.navigateTo(Routes.qRCodeView);
    if (useSuperUserFeatures && marker != null) {
      final adminMode = await showAdminDialogAndGetResponse();
      if (adminMode == true) {
        String qrCodeString =
            qrCodeService.getQrCodeStringFromMarker(marker: marker);
        await navigationService.navigateTo(Routes.qRCodeView,
            arguments: QRCodeViewArguments(qrCodeString: qrCodeString));
        return MarkerAnalysisResult.empty();
      }
    }
    MarkerAnalysisResult scanResult =
        await activeQuestService.analyzeMarker(marker: marker);
    return scanResult;
  }

  ////////////////////////////
  // can be overriden?
  Future handleMarkerAnalysisResult(MarkerAnalysisResult result) async {
    log.i("Handling marker analysis result");
    if (!hasActiveQuest &&
        (result.quests == null ||
            (result.quests != null && result.quests!.length == 0))) {
      await dialogService.showDialog(
          title:
              "The scanned marker is not a start of a quest. Please go to the starting point");
    }
    if (result.quests != null && result.quests!.length > 0) {
      // TODO: Handle case where more than one quest is returned here!
      // For now, just start first quest!
      if (!hasActiveQuest) {
        log.i("Found quests associated to the scanned start marker.");
        await displayQuestBottomSheet(
          quest: result.quests![0],
          startMarker: result.quests![0].startMarker,
        );
      }
    }
    return false;
  }

  void showQuestDetailsFromList({required Quest quest}) {
    mapViewModel.animateToQuestDetails(quest: quest);
  }

  int currentIndex = 0;
  void toggleIndex() {
    if (currentIndex == 0) {
      currentIndex = 1;
    } else {
      currentIndex = 0;
    }
    notifyListeners();
  }

  //////////////////////////////////////////
  /// Clean-up
  ///
  // void cancelQuestListener() {
  //   log.i("Cancelling subscription to quest");
  //   _activeQuestSubscription?.cancel();
  //   _activeQuestSubscription = null;
  // }

  @override
  void dispose() {
    // _activeQuestSubscription?.cancel();
    super.dispose();
  }
}
