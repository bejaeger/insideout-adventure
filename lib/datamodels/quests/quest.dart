// ignore_for_file: non_constant_identifier_names

import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:geoflutterfire/geoflutterfire.dart';
import 'package:insideout_ui/insideout_ui.dart';

import 'marker_note/marker_note.dart';

class Quest {
  late String id;
  late String name;
  late String description;
  String? createdBy;
  GeoFirePoint? location;
  AFKMarker? startMarker;
  AFKMarker? finishMarker;
  late List<AFKMarker> markers;
  double? distanceMarkers; // in meters
  List<MarkerNote>? markerNotes;
  late num credits;
  String? networkImagePath;
  List<num>? creditsPerMarker;
  num? bonusCreditsOnSuccess;
  double? distanceFromUser;
  double? distanceToTravelInMeter;
  late QuestType type;
  int? repeatable;

  Quest({
    required this.id,
    required this.name,
    required this.description,
    required this.type,
    required this.credits,
    this.markerNotes,
    this.distanceMarkers,
    this.startMarker,
    this.finishMarker,
    required this.markers,
    required this.location,
    this.createdBy,
    this.creditsPerMarker,
    this.bonusCreditsOnSuccess,
    this.distanceFromUser,
    this.distanceToTravelInMeter,
    this.networkImagePath,
    this.repeatable = 0,
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
    double? distanceMarkers, // in meters
    List<MarkerNote>? markerNotes,
    num? credits,
    String? networkImagePath,
    List<num>? creditsPerMarker,
    num? bonusCreditsOnSuccess,
    double? distanceFromUser,
    double? distanceToTravelInMeter,
    QuestType? type,
    int? repeatable,
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
        distanceMarkers: distanceMarkers ?? this.distanceMarkers, // in meters
        markerNotes: markerNotes ?? this.markerNotes,
        credits: credits ?? this.credits,
        networkImagePath: networkImagePath ?? this.networkImagePath,
        creditsPerMarker: creditsPerMarker ?? this.creditsPerMarker,
        bonusCreditsOnSuccess:
            bonusCreditsOnSuccess ?? this.bonusCreditsOnSuccess,
        distanceFromUser: distanceFromUser ?? this.distanceFromUser,

        distanceToTravelInMeter:
            distanceToTravelInMeter ?? this.distanceToTravelInMeter,
        type: type ?? this.type,
        repeatable: repeatable ?? this.repeatable,
      );
  Quest.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    name = json['name'];
    description = json['description'];
    type = questTypeFromString(json['type']);
    createdBy = json['createdBy'];
    credits = json['credits'];
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
    distanceMarkers = json['distanceMarkers'];
    creditsPerMarker = json['creditsPerMarker'];
    bonusCreditsOnSuccess = json['bonusCreditsOnSuccess'];
    distanceFromUser = json['distanceFromUser'];
    distanceToTravelInMeter = json['distanceToTravelInMeter'];
    networkImagePath = json['networkImagePath'];
    location = json['location'] != null
        ? GeoFirePoint(json['location']!['geopoint'].latitude,
            json['location']!['geopoint'].longitude)
        : null; // need to convert geopoint to GeoFirePoint
    repeatable = json['repeatable'] != null ? json['repeatable'] : 0;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = Map<String, dynamic>();
    data['id'] = this.id;
    data['name'] = this.name;
    data['description'] = this.description;
    data['type'] = this.type.toSimpleString();
    data['createdBy'] = this.createdBy;
    data['credits'] = this.credits;
    data['markers'] = this.markers.map((e) => e.toJson()).toList();
    data['markerNotes'] = this.markerNotes != null
        ? this.markerNotes!.map((e) => e.toJson()).toList()
        : null;
    data['distanceMarkers'] = this.distanceMarkers;
    data['creditsPerMarker'] = this.creditsPerMarker;
    data['startMarker'] = this.startMarker!.toJson();
    data['finishMarker'] = this.finishMarker!.toJson();
    data['bonusCreditsOnSuccess'] = this.bonusCreditsOnSuccess;
    data['distanceFromUser'] = this.distanceFromUser;
    data['distanceToTravelInMeter'] = this.distanceToTravelInMeter;
    data['networkImagePath'] = this.networkImagePath;
    data['location'] = this.location != null
        ? this.location!.data
        : null; // will convert GeoFirePoint to GeoPoint for firebase!
    data['repeatable'] = this.repeatable;
    return data;
  }

  @override
  bool operator ==(dynamic other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is Quest &&
            const DeepCollectionEquality().equals(other.id, id) &&
            const DeepCollectionEquality().equals(other.name, name) &&
            const DeepCollectionEquality()
                .equals(other.description, description) &&
            const DeepCollectionEquality().equals(other.type, type) &&
            const DeepCollectionEquality().equals(other.createdBy, createdBy) &&
            const DeepCollectionEquality()
                .equals(other.startMarker, startMarker) &&
            const DeepCollectionEquality()
                .equals(other.finishMarker, finishMarker) &&
            const DeepCollectionEquality().equals(other.markers, markers) &&
            const DeepCollectionEquality()
                .equals(other.markerNotes, markerNotes) &&
            const DeepCollectionEquality().equals(other.credits, credits) &&
            const DeepCollectionEquality()
                .equals(other.networkImagePath, networkImagePath) &&
            const DeepCollectionEquality()
                .equals(other.creditsPerMarker, creditsPerMarker) &&
            const DeepCollectionEquality()
                .equals(other.bonusCreditsOnSuccess, bonusCreditsOnSuccess) &&
            const DeepCollectionEquality()
                .equals(other.distanceFromUser, distanceFromUser) &&
            const DeepCollectionEquality().equals(
                other.distanceToTravelInMeter, distanceToTravelInMeter) &&
            const DeepCollectionEquality()
                .equals(other.repeatable, repeatable));
  }
}

QuestType questTypeFromString(String value) {
  return QuestType.values.firstWhere(
      (e) => e.toString().split('.')[1].toUpperCase() == value.toUpperCase());
}
