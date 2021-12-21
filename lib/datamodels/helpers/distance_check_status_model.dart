import 'dart:async';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/enums/distance_check_status.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

part 'distance_check_status_model.freezed.dart';

@freezed
class DistanceCheckStatusModel with _$DistanceCheckStatusModel {
  factory DistanceCheckStatusModel({
    required Future<DistanceCheckStatus> futureStatus,
    required double distanceInMeter,
  }) = _DistanceCheckStatusModel;
}
