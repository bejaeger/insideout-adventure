import 'package:afkcredits/enums/position_retrieval.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geolocator/geolocator.dart';

// class storing all information relevant for a "datapoint" during a quest
// has the option to be pushed to notion for later analysis

class QuestDataPoint {
  final Position? livePosition;
  final Position? currentPosition;
  final Position? lastKnownPosition;
  final QuestDataPointTrigger? triggeredBy;
  final int entryNumber;
  final String? questId;
  final String? questCategory;
  String? currentLocationDistance;
  String? liveLocationDistance;
  String? lastKnownLocationDistance;
  bool pushedToNotion = false;
  String? questTrialId;
  String? userEventDescription;
  QuestDataPoint({
    this.triggeredBy,
    this.questCategory,
    this.livePosition,
    this.currentPosition,
    this.lastKnownPosition,
    required this.entryNumber,
    this.questTrialId,
    this.currentLocationDistance,
    this.liveLocationDistance,
    this.lastKnownLocationDistance,
    this.questId,
    this.userEventDescription,
  });
}


