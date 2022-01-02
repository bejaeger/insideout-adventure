import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:geolocator/geolocator.dart';

class AdminHomeViewModel extends BaseModel {
  List<ActivatedQuest> get activatedQuestsHistory =>
      questService.activatedQuestsHistory;
  final _geolocationService = locator<GeolocationService>();

  Future listenToData() async {
    setBusy(true);
    Completer completer = Completer<void>();
    Completer completerTwo = Completer<void>();
    userService.setupUserDataListeners(
        completer: completer, callback: () => notifyListeners());
    questService.setupPastQuestsListener(
        completer: completerTwo,
        uid: currentUser.uid,
        callback: () => notifyListeners());
    await Future.wait([
      completer.future,
      completerTwo.future,
    ]);
    setBusy(false);
  }

  Future<Position> getAndSetCurrentLocation() async {
    return _geolocationService.getAndSetCurrentLocation();
  }
}
