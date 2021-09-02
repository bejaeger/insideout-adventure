import 'dart:convert';

import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/datamodels/quests/markers/marker.dart';
import 'package:afkcredits/exceptions/qrcode_service_exception.dart';

class QRCodeService {
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();

  Markers convertQrCodeStringToMarker({required String qrCodeString}) {
    try {
      final json = jsonDecode(qrCodeString);
      return Markers.fromJson(json);
    } catch (e) {
      throw QRCodeServiceException(
          message: "Qr Code is not valid",
          devDetails:
              "Could not create a Marker datamodel from the qrCodeString. Error thrown: $e");
    }
  }

  String convertMarkerToQrCodeString({required Markers marker}) {
    try {
      // need to remove lat and lon info cause we don't know the
      // exact geolocation at the time when the qr code is generated!
      // So we should not encode that in the qr code itself but
      // add the info later on!
      final newMarker = marker.copyWith(lat: null, lon: null);
      return json.encode(newMarker.toJson()).toString();
    } catch (e) {
      throw QRCodeServiceException(
          message: "Qr Code String could not be build for given marker",
          devDetails:
              "Could not create string from  Marker datamodel. Error thrown: $e");
    }
  }

  Future getMarkerFromQrCodeString({required String qrCodeString}) async {
    Markers marker = convertQrCodeStringToMarker(qrCodeString: qrCodeString);
    return await _firestoreApi.getMarkerFromQrCodeId(qrCodeId: marker.qrCodeId);
  }
}
