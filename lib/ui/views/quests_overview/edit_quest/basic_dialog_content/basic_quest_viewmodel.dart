import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/utils/snackbars/display_snack_bars.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked/stacked.dart';

class BasicQuestViewModel extends FormViewModel with NavigationMixin {
  final _log = getLogger('BasicQuestViewModel');
  final _questService = locator<QuestService>();
  //final _snackBarService = locator<SnackbarService>();
  final displaySnackBars = DisplaySnackBars();
  CameraPosition? _initialCameraPosition;

  @override
  void setFormStatus() {
    // TODO: implement setFormStatus
  }
  CameraPosition initialCameraPosition() {
    //if (_geolocationService.getUserLivePositionNullable != null) {
    _initialCameraPosition = CameraPosition(
      target: LatLng(37.773972,
          -122.431297) /* LatLng(_geolocationService.getUserLivePosition!.latitude,
              _geolocationService.getUserLivePosition!.longitude) */
      ,
      zoom: 11.5,
    );
    return _initialCameraPosition!;
  }

  Future<void> updateQuestData({required Quest quest}) async {
    //TODO: DO the Provisioning regarding empty data with.
    await _questService.updateQuestData(quest: quest);
    //_log.i("This is the Actual Quest: " + nameValue.toString());
    _log.i("This is the Actual Quest: " + quest.id);
    displaySnackBars.snackBarUpdateQuest(quest: quest);
    // await Future.delayed(const Duration(seconds: 11), () {
    //   this.navToAddGiftCard();
    // });
    this.navBackToPreviousView();
  }
}
