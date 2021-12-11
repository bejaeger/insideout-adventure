import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';

class SingleQuestViewModel extends QuestViewModel {
  final GeolocationService _geolocationService = locator<GeolocationService>();

  final log = getLogger("SingleQuestViewModel");

  final QuestType? questType;
  List<Quest> currentQuests = [];
  List<double?> distancesFromQuests = [];

  SingleQuestViewModel({this.questType}) {
    if (questType != null) {
      currentQuests = getQuestsOfType(type: questType!);
      currentQuests.forEach((element) => distancesFromQuests.add(null));
    }
  }

  Future getDistancesToStartOfQuests() async {
    if (currentQuests.isNotEmpty) {
      log.i("Check distances for current quest list");

      // need to use normal for loop to await results
      for (var i = 0; i < currentQuests.length; i++) {
        if (currentQuests[i].startMarker != null) {
          double distance =
              await _geolocationService.distanceBetweenUserAndCoordinates(
                  lat: currentQuests[i].startMarker!.lat,
                  lon: currentQuests[i].startMarker!.lon);
          distancesFromQuests[i] = distance;
        }
      }
    } else {
      log.w(
          "Curent quests empty, or distance check not required. Can't check distances");
    }
    log.i("Notify listeners");
    notifyListeners();
  }

  @override
  Future handleQrCodeScanEvent(QuestQRCodeScanResult result) {
    // TODO: implement handleQrCodeScanEvent
    throw UnimplementedError();
  }
}
