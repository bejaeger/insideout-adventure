import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:location/location.dart';
import 'package:rxdart/rxdart.dart';

class AFKMarkersPositionService {
  Geoflutterfire geo = Geoflutterfire();

  // ignore: close_sinks
  BehaviorSubject<double>? radius;
  // ignore: close_sinks
  BehaviorSubject<double> radiusQuery = BehaviorSubject();

  Stream<dynamic>? query;
  StreamSubscription? subscription;

  void startQuery({required updateMarkers}) async {
    final pos = await Location.instance.getLocation();

    final ref = FirebaseFirestore.instance.collection('afkMarkersPositions');
    GeoFirePoint center =
        geo.point(latitude: pos.latitude!, longitude: pos.longitude!);
    subscription = radius!.switchMap(
      (rad) {
        return geo.collection(collectionRef: ref).within(
            center: center, radius: rad, field: 'position', strictMode: true);
      },
    ).listen(updateMarkers);
  }
}
