import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/services/quests/quest_qrcode_scan_result.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';

abstract class QuestViewModel extends BaseModel {
  Future scanQrCodeWithActiveQuest() async {
    QuestQRCodeScanResult result = await navigateToQrcodeViewAndReturnResult();
    handleQrCodeScanEvent(result);
  }

  Future<QuestQRCodeScanResult> navigateToQrcodeViewAndReturnResult() async {
    final marker = await navigationService.navigateTo(Routes.qRCodeView);
    QuestQRCodeScanResult scanResult =
        await questService.handleQrCodeScanEvent(marker: marker);
    return scanResult;
  }

  // needs to be overrriden!
  void handleQrCodeScanEvent(QuestQRCodeScanResult result);
}
