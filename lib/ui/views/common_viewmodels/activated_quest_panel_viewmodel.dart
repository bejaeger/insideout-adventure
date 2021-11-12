import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/quest_viewmodel.dart';
import 'package:afkcredits/app/app.logger.dart';

class ActivatedQuestPanelViewModel extends QuestViewModel {
  final log = getLogger("CustomAppBarViewModel");
  @override
  Future handleQrCodeScanEvent(QuestQRCodeScanResult result) {
    // TODO: implement handleQrCodeScanEvent
    throw UnimplementedError();
  }
}
