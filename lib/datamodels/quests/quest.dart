// ignore_for_file: non_constant_identifier_names

import 'package:afkcredits/datamodels/quests/marker_note/marker_note.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'markers/afk_marker.dart';
part 'quest.freezed.dart';
part 'quest.g.dart';

@freezed
class Quest with _$Quest {
  @JsonSerializable(explicitToJson: true)
  factory Quest({
    required String id,
    required String name,
    required String description,
    required QuestType type,
    AFKMarker? startMarker,
    AFKMarker? finishMarker,
    required List<AFKMarker> markers,
    List<MarkerNote>? markerNotes,
    required num afkCredits,
    String? networkImagePath,
    List<num>? afkCreditsPerMarker,
    num? bonusAfkCreditsOnSuccess,
    double? distanceFromUser,
    double? distanceToTravelInMeter, // for distance estimate
  }) = _Quest;

  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);
}

/* class Quest {
  //GeoFirePoint? point;
  String? id;
  String? name;
  String? description;
  AFKMarker? startMarker;
  AFKMarker? finishMarker;
  List<AFKMarker>? markers;
  num? afkCredits;
  String? networkImagePath;
  List<num>? afkCreditsPerMarker;
  num? bonusAfkCreditsOnSuccess;
  double? distanceFromUser;
  double? distanceToTravelInMeter;
  String? type;

  Quest({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.afkCredits,
    this.markers,
    this.afkCreditsPerMarker,
    this.startMarker,
    this.finishMarker,
    this.bonusAfkCreditsOnSuccess,
    this.distanceFromUser,
    this.distanceToTravelInMeter,
    this.networkImagePath,
  });

  Quest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    type = json['type'];
    afkCredits = json['afkCredits'];
    markers = json['markers']!;
    afkCreditsPerMarker = json['afkCreditsPerMarker'];
    startMarker = json['startMarker']!;
    finishMarker = json['finishMarker']!;
    bonusAfkCreditsOnSuccess = json['bonusAfkCreditsOnSuccess'];
    distanceFromUser = json['distanceFromUser'];
    distanceToTravelInMeter = json['distanceToTravelInMeter'];
    networkImagePath = json['networkImagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['type'] = this.type!;
    data['afkCredits'] = this.afkCredits;
    data['afkMarkersPositions'] = this.markers!.map((e) => e.toJson()).toList();
    data['afkCreditsPerMarker'] = this.afkCreditsPerMarker;
    data['startMarker'] = this.startMarker!.toJson();
    data['finishAfkMarkersPositions'] = this.finishMarker!.toJson();
    data['bonusAfkCreditsOnSuccess'] = this.bonusAfkCreditsOnSuccess;
    data['distanceFromUser'] = this.distanceFromUser;
    data['distanceToTravelInMeter'] = this.distanceToTravelInMeter;
    data['networkImagePath'] = this.networkImagePath;
    return data;
  }
} */

class AFKQuest {
  //GeoFirePoint? point;
  String? id;
  String? name;
  String? description;
  AfkMarkersPositions? startAfkMarkersPositions;
  AfkMarkersPositions? finishAfkMarkersPositions;
  List<AfkMarkersPositions>? afkMarkersPositions;
  num? afkCredits;
  String? networkImagePath;
  List<num>? afkCreditsPerMarker;
  num? bonusAfkCreditsOnSuccess;
  double? distanceFromUser;
  double? distanceToTravelInMeter;
  String? type;

  AFKQuest({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.afkCredits,
    this.afkMarkersPositions,
    this.afkCreditsPerMarker,
    this.startAfkMarkersPositions,
    this.finishAfkMarkersPositions,
    this.bonusAfkCreditsOnSuccess,
    this.distanceFromUser,
    this.distanceToTravelInMeter,
    this.networkImagePath,
  });

  AFKQuest.fromJson(Map<String, dynamic> json) {
    final Map<String, dynamic> data = Map<String, dynamic>();
    id = json['id'];
    name = json['name'];
    description = json['description'];
    type = json['type'];
    afkCredits = json['afkCredits'];
    startAfkMarkersPositions =
        AfkMarkersPositions.fromJson(json['startAfkMarkersPositions']!);
    finishAfkMarkersPositions =
        AfkMarkersPositions.fromJson(json['finishAfkMarkersPositions']!);
    afkMarkersPositions = List<dynamic>.from(json['afkMarkersPositions'])
        .map((i) => AfkMarkersPositions.fromJson(i))
        .toList();

    afkCreditsPerMarker = json['afkCreditsPerMarker'];

    bonusAfkCreditsOnSuccess = json['bonusAfkCreditsOnSuccess'];
    distanceFromUser = json['distanceFromUser'];
    distanceToTravelInMeter = json['distanceToTravelInMeter'];
    networkImagePath = json['networkImagePath'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['type'] = this.type!;
    data['afkCredits'] = this.afkCredits;
    data['afkMarkersPositions'] =
        this.afkMarkersPositions!.map((e) => e.toJson()).toList();
    data['afkCreditsPerMarker'] = this.afkCreditsPerMarker;
    data['startAfkMarkersPositions'] = this.startAfkMarkersPositions!.toJson();
    data['finishAfkMarkersPositions'] =
        this.finishAfkMarkersPositions!.toJson();
    data['bonusAfkCreditsOnSuccess'] = this.bonusAfkCreditsOnSuccess;
    data['distanceFromUser'] = this.distanceFromUser;
    data['distanceToTravelInMeter'] = this.distanceToTravelInMeter;
    data['networkImagePath'] = this.networkImagePath;
    return data;
  }
}
