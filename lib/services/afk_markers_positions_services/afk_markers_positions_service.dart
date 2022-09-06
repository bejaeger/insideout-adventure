import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

class AFKMarkersPositionService {
  Geoflutterfire geo = Geoflutterfire();

  // Stateful Data
  BehaviorSubject<double>? radius;
  // ignore: close_sinks
  BehaviorSubject<double> radiusQuery = BehaviorSubject();

  // This is the Stream for the query of the data store.
  Stream<dynamic>? query;

  // Subscription
  StreamSubscription? subscription;

  void startQuery({required updateMarkers}) async {
    // Get users location
    final pos = await Location.instance.getLocation();

    // Make a referece to firestore
    final ref = FirebaseFirestore.instance.collection('afkMarkersPositions');
    GeoFirePoint center =
        geo.point(latitude: pos.latitude!, longitude: pos.longitude!);

    // subscribe to query
    subscription = radius!.switchMap(
      (rad) {
        return geo.collection(collectionRef: ref).within(
            center: center, radius: rad, field: 'position', strictMode: true);
      },
    ).listen(updateMarkers);
  }
}
