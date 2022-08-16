import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

import '../../../../../../utils/markers/markers.dart';

class SingleMarkerViewModel extends AFKMarks with NavigationMixin {
  int? _group;
  @override
  void setFormStatus() {
    // TODO: implement setFormStatus
  }

  void checkMarkerStatus({int? checkMarkerStatus}) {
    if (checkMarkerStatus == 1) {
      _group = 1;
    } else {
      _group = 2;
    }
    notifyListeners();
  }

  void setGroupNumber() {
    _group = null;
    notifyListeners();
  }

  void addMarkerToMap(LatLng position) {
    setBusy(true);
    addMarkerOnMap(pos: position, number: getAFKMarkers.length);
    setBusy(false);
    notifyListeners();
  }

  int? get getGroupId => _group;
}
