import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/ui/views/quests_overview/edit_quest/basic_dialog_content/basic_dialog_content.form.dart';
import 'package:stacked/stacked.dart';

class CreateQuestViewModel extends FormViewModel with NavigationMixin {
  List<AFKMarker?>? _afkMarkers;
  final _markerService = locator<MarkerService>();
  final _log = getLogger('CreateQuestViewModel');
  AFKMarker? _startMarker;
  AFKMarker? _finishMarker;
  List<String>? markerIds = [];
  @override
  void setFormStatus() {
    _log.i('Set the Form With Data: $formValueMap');
    if (nameValue?.isEmpty ?? true) {
      setValidationMessage('You Must Give a Value into this field');
    }
    // TODO: implement setFormStatus
  }

  void setMarkersId({required AFKMarker? startOrFinishMarker}) {
    setBusy(true);
    _startMarker = startOrFinishMarker;
    setBusy(false);
    notifyListeners();
    _log.i("Harguilar You Have tried Look at the code Below");
    _log.i(nameValue);
    _log.i(_startMarker!);
  }

  List<AFKMarker?>? get getAFKMarkers => _afkMarkers;

  Future<void> getQuestMarkers() async {
    setBusy(true);
    // ignore: await_only_futures
    _afkMarkers = await _markerService.getQuestMarkers();
    setBusy(false);
    notifyListeners();
  }
}
