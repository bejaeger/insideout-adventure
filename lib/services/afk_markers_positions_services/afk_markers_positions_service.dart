import 'dart:async';

import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

import '../../constants/constants.dart';

class AFKMarkersPositionService {
  Geoflutterfire geo = Geoflutterfire();

  // Stateful Data
  BehaviorSubject<double>? radius;
  Stream<dynamic>? query;

  // Subscription
  StreamSubscription? subscription;

  void startQuery({required updateMarkers}) async {
    // Get users location
    var pos = await Location.instance.getLocation();

    // Make a referece to firestore
    final ref = afkMarkersPositionsCollection;
    GeoFirePoint center =
        geo.point(latitude: pos.latitude!, longitude: pos.longitude!);

    // subscribe to query
    subscription = radius!.switchMap((rad) {
      return geo.collection(collectionRef: ref).within(
          center: center, radius: rad, field: 'position', strictMode: true);
    }).listen(updateMarkers);
  }
}
