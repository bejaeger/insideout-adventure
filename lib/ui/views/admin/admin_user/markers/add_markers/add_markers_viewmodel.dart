// ignore_for_file: unrelated_type_equality_checks

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:stacked_services/stacked_services.dart';
import '../../../../../../constants/constants.dart';
import '../../../../../../utils/markers/markers.dart';

class AddMarkersViewModel extends AFKMarks with NavigationMixin {
  final log = getLogger("AddMarkersViewModel");
  final snackbarService = locator<SnackbarService>();
  // final markersInMap = locator<MarkersInMap>();
  final _questService = locator<QuestService>();
  final _dialogService = locator<DialogService>();
  //final afkMarkersobj = AFKMarks();

  int countTapped = 0;

  List<Quest>? _getListOfQuest;

  List<AFKMarker>? afkMarkers;
  Set<Marker> markers = {};

  int? _group;

  List<Quest>? get getListOfQuest => _getListOfQuest;

  Future<void> setQuestList() async {
    setBusy(true);
    _getListOfQuest = await _questService.loadNearbyQuests(sponsorIds: []);
    addStartMarkers(quest: _getListOfQuest!);
    setBusy(false);
    notifyListeners();
  }

  void addStartMarkers({required List<Quest> quest}) {
    int idx = 0;
    int i = 0;
    bool found = false;

    while (idx < quest.length) {
      for (AFKMarker _afkMarkers in quest[idx].markers!) {
        if (_afkMarkers.id.isNotEmpty) {
          markers.add(
            Marker(
              markerId: MarkerId(_afkMarkers.id),
              position: LatLng(
                  _afkMarkers.lat ?? latitude, _afkMarkers.lon ?? longitude),
              infoWindow: InfoWindow(snippet: quest[idx].name),
              onTap: () {
                log.i('HARGUILAR BELOW WAS CLICKED');
                log.i('$_afkMarkers');
                while (i < quest.length) {
                  if (_afkMarkers.id == quest[i].startMarker!.id) {
                    log.i('Started Marker IS HERE');
                    _dialogService.showConfirmationDialog(
                        title: 'Marker Information',
                        description:
                            'This Markers is a Start Marker ${_afkMarkers.id}');
                    found = true;
                    break;
                  } else if (_afkMarkers.id == quest[i].finishMarker!.id &&
                      quest[i].finishMarker!.id.isNotEmpty) {
                    log.i('Started Finish IS HERE');
                    _dialogService.showConfirmationDialog(
                        title: 'Marker Information',
                        description:
                            ' This Markers is a Finish ${_afkMarkers.id}');
                    found = true;
                    break;
                  }
                  i++;
                }
                if (!found) {
                  _dialogService.showConfirmationDialog(
                      title: 'Marker Information',
                      description:
                          'This Markers is a Between ${_afkMarkers.id}');
                }
              },
            ),
          );
        }
      }
      idx++;
    }
    notifyListeners();
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

  int? get getGroupId => _group;

  void addMarkerToMap(LatLng position) {
    setBusy(true);
    addMarkerOnMap(pos: position, number: getAFKMarkers.length);
    setBusy(false);
    notifyListeners();
  }

  @override
  void setFormStatus() {
    // TODO: implement setFormStatus
  }
}
