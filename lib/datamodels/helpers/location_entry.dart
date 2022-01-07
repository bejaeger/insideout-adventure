import 'package:afkcredits/enums/position_retrieval.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

class LocationEntry {
  final Position? livePosition;
  final Position? currentPosition;
  final Position? lastKnownPosition;
  final LocationRetrievalTrigger triggeredBy;
  final int entryNumber;
  final String? activeQuestId;
  bool pushedToNotion = false;
  LocationEntry({
    required this.triggeredBy,
    required this.livePosition,
    required this.currentPosition,
    required this.lastKnownPosition,
    required this.entryNumber,
    this.activeQuestId,
  });
}


