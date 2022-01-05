import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/exceptions/qrcode_service_exception.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:stacked_services/stacked_services.dart';

class QRCodeViewModel extends BaseModel {
  final log = getLogger("qrcode_viewmodel.dart");
  final QRCodeService _qrCodeService = locator<QRCodeService>();
  final SnackbarService? _snackbarService = locator<SnackbarService>();

  void popQrCodeView() {
    navigationService.back(result: null);
  }

  Future analyzeScanResult({required Barcode result}) async {
    if (isBusy) {
      return null;
    }
    setBusy(true);
    var deadTime = Duration(seconds: 3);
    log.i(
        "Scanned code with result '${result.code}' and format '${result.format}");
    try {
      AFKMarker marker =
          _qrCodeService.getMarkerFromQrCodeString(qrCodeString: result.code);
      log.i(
          "Successfully read marker information from QR Code, navigate back with scanResult");
      navigationService.back(result: marker);
    } catch (e) {
      if (e is QRCodeServiceException) {
        log.e("Error when reading QR Code: $e");
        _snackbarService!.showSnackbar(
            title: "Could not read QR code",
            message: "${e.prettyDetails}",
            duration: deadTime);
        await Future.delayed(deadTime);
      } else {
        rethrow;
      }
    }
    await Future.delayed(deadTime);
    setBusy(false);
    notifyListeners();
  }
}
