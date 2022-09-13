// ignore_for_file: non_constant_identifier_names

import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'marker_note/marker_note.dart';
/* part 'quest.freezed.dart';
part 'quest.g.dart';

@freezed
class Quest with _$Quest {
  @JsonSerializable(explicitToJson: true)
  factory Quest({
    required String id,
    required String name,
    required String description,
    required QuestType type,
    //GeoFirePoint? location,
    String? createdBy,
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
    @Default(0) int repeatable,
  }) = _Quest;

  factory Quest.fromJson(Map<String, dynamic> json) => _$QuestFromJson(json);
} */

class Quest {
  late String id;
  late String name;
  late String description;
  String? createdBy;
  GeoFirePoint? location;
  AFKMarker? startMarker;
  AFKMarker? finishMarker;
  late List<AFKMarker> markers;
  List<MarkerNote>? markerNotes;
  late num afkCredits;
  String? networkImagePath;
  List<num>? afkCreditsPerMarker;
  num? bonusAfkCreditsOnSuccess;
  double? distanceFromUser;
  double? distanceToTravelInMeter;
  late QuestType type;
  int repeatable = 0;

  Quest({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.afkCredits,
    this.markerNotes,
    this.startMarker,
    this.finishMarker,
    required this.markers,
    required this.location,
    this.createdBy,
    this.afkCreditsPerMarker,
    this.bonusAfkCreditsOnSuccess,
    this.distanceFromUser,
    this.distanceToTravelInMeter,
    this.networkImagePath,
  });

  Quest copyWith({
    String? id,
    String? name,
    String? description,
    String? createdBy,
    GeoFirePoint? location,
    AFKMarker? startMarker,
    AFKMarker? finishMarker,
    List<AFKMarker>? markers,
    List<MarkerNote>? markerNotes,
    num? afkCredits,
    String? networkImagePath,
    List<num>? afkCreditsPerMarker,
    num? bonusAfkCreditsOnSuccess,
    double? distanceFromUser,
    double? distanceToTravelInMeter,
    QuestType? type,
  }) =>
      Quest(
        id: id ?? this.id,
        name: name ?? this.name,
        description: description ?? this.description,
        createdBy: createdBy ?? this.createdBy,
        location: location ?? this.location,
        startMarker: startMarker ?? this.startMarker,
        finishMarker: finishMarker ?? this.finishMarker,
        markers: markers ?? this.markers,
        markerNotes: markerNotes ?? this.markerNotes,
        afkCredits: afkCredits ?? this.afkCredits,
        networkImagePath: networkImagePath ?? this.networkImagePath,
        afkCreditsPerMarker: afkCreditsPerMarker ?? this.afkCreditsPerMarker,
        bonusAfkCreditsOnSuccess:
            bonusAfkCreditsOnSuccess ?? this.bonusAfkCreditsOnSuccess,
        distanceFromUser: distanceFromUser ?? this.distanceFromUser,
        distanceToTravelInMeter:
            distanceToTravelInMeter ?? this.distanceToTravelInMeter,
        type: type ?? this.type,
      );
  Quest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    type = questTypeFromString(json['type']);
    createdBy = json['createdBy'];
    afkCredits = json['afkCredits'];
    startMarker = AFKMarker.fromJson(json['startMarker']!);
    finishMarker = AFKMarker.fromJson(json['finishMarker']!);
    markers = List<dynamic>.from(json['markers'])
        .map((i) => AFKMarker.fromJson(i))
        .toList();
    markerNotes = json['markerNotes'] != null
        ? List<dynamic>.from(json['markerNotes'])
            .map((i) => MarkerNote.fromJson(i))
            .toList()
        : null;
    afkCreditsPerMarker = json['afkCreditsPerMarker'];
    bonusAfkCreditsOnSuccess = json['bonusAfkCreditsOnSuccess'];
    distanceFromUser = json['distanceFromUser'];
    distanceToTravelInMeter = json['distanceToTravelInMeter'];
    networkImagePath = json['networkImagePath'];
    location = json['location'] != null
        ? GeoFirePoint(json['location']!['geopoint'].latitude,
            json['location']!['geopoint'].longitude)
        : null; // need to convert geopoint to GeoFirePoint
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['type'] = this.type.toSimpleString();
    data['createdBy'] = this.createdBy;
    data['afkCredits'] = this.afkCredits;
    data['markers'] = this.markers.map((e) => e.toJson()).toList();
    data['markerNotes'] = this.markerNotes != null
        ? this.markerNotes!.map((e) => e.toJson()).toList()
        : null;
    data['afkCreditsPerMarker'] = this.afkCreditsPerMarker;
    data['startMarker'] = this.startMarker!.toJson();
    data['finishMarker'] = this.finishMarker!.toJson();
    data['bonusAfkCreditsOnSuccess'] = this.bonusAfkCreditsOnSuccess;
    data['distanceFromUser'] = this.distanceFromUser;
    data['distanceToTravelInMeter'] = this.distanceToTravelInMeter;
    data['networkImagePath'] = this.networkImagePath;
    data['location'] = this.location != null
        ? this.location!.data
        : null; // will convert GeoFirePoint to GeoPoint for firebase!
    return data;
  }
}

QuestType questTypeFromString(String value) {
  return QuestType.values.firstWhere(
      (e) => e.toString().split('.')[1].toUpperCase() == value.toUpperCase());
}
