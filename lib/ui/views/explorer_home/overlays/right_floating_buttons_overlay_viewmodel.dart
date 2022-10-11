import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:afkcredits/ui/views/common_viewmodels/map_state_control_mixin.dart';
import 'dart:math' as m;
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';

class RightFloatingButtonsOverlayViewModel extends BaseModel
    with MapStateControlMixin {
  // --------------------------------
  // services
  final log = getLogger("RightFloatingButtonsOverlayViewModel");
  final MapViewModel mapViewModel = locator<MapViewModel>();

  // --------------------------------------------
  // getters
  //double get bearing => mapStateService.bearingSubject.value;
  double get bearing => mapStateService.bearing;
  double get angle => -bearing * m.pi / 180;
  bool get isAvatarView => mapStateService.isAvatarView;
  bool get hasActiveQuest => activeQuestService.hasActiveQuest;

  // ------------------------------------------
  // state
  StreamSubscription? _bearingListenerSubscription;
  bool prevValue = false;

  // ------------------------------------------
  // functions

  Future initialize() async {
    // Only listening to it because of compass so that it also rotates!
    // This only works in avatar view
    if (_bearingListenerSubscription == null) {
      _bearingListenerSubscription =
          mapStateService.isFingerOnScreenSubject.listen(
        (value) {
          if (value != prevValue) {
            if (!value) {
              notifyListeners();
            }
          }
          prevValue = value;
        },
      );
      // mapStateService.bearingSubject.listen(
      //   (bearingIn) {
      //     // only update compass when there is significant change
      //     // otherwise UI is updated too often.
      //     // if ((bearing - prevAngle).abs() > 10) {

      //     // TODO: This causes big lags on old phone!
      //     if (!isAvatarView) {
      //       notifyListeners();
      //     }
      //     // }
      //     //}
      //   },
      // );
    }
  }

  void rotateToNorth() async {
    if (userLocation == null) return;
    // Otherwise compass points in the wrong direction.
    await mapViewModel.animateCameraViewModel(customBearing: 0);
    changeCameraBearing(0);
    await Future.delayed(Duration(milliseconds: 200));
    notifyListeners();
  }

  @override
  void dispose() {
    _bearingListenerSubscription?.cancel();
    _bearingListenerSubscription = null;
    super.dispose();
  }
}
