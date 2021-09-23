import 'dart:convert';

import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/datamodels/quests/markers/marker.dart';
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/exceptions/qrcode_service_exception.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class QRCodeService {
  final log = getLogger("qr_code_service.dart");
  final FirestoreApi _firestoreApi = locator<FirestoreApi>();

  AFKMarker convertQrCodeStringToMarker({required String qrCodeString}) {
    try {
      final json = jsonDecode(qrCodeString);
      return AFKMarker.fromJson(json);
    } catch (e) {
      throw QRCodeServiceException(
          message: "Qr Code is not valid",
          devDetails:
              "Could not create a Marker datamodel from the qrCodeString. Error thrown: $e");
    }
  }

  String convertMarkerToQrCodeString({required AFKMarker marker}) {
    try {
      // need to remove lat and lon info cause we don't know the
      // exact geolocation at the time when the qr code is generated!
      // So we should not encode that in the qr code itself but
      // add the info later on!
      final newMarker = marker.copyWith(lat: marker.lat, lon: marker.lon);
      return json.encode(newMarker.toJson()).toString();
    } catch (e) {
      throw QRCodeServiceException(
          message: "Qr Code String could not be build for given marker",
          devDetails:
              "Could not create string from  Marker datamodel. Error thrown: $e");
    }
  }

  Future getMarkerFromQrCodeString({required String qrCodeString}) async {
    AFKMarker marker = convertQrCodeStringToMarker(qrCodeString: qrCodeString);
    return await _firestoreApi.getMarkerFromQrCodeId(qrCodeId: marker.qrCodeId);
  }

  String getEncodedUserInfo(User currentUser) {
    // Format for data stored in QR image
    // the format: key1: name, key2: name
    // easily converted later on
    return jsonEncode({
      "uid": currentUser.uid.toString(),
      "name": currentUser.fullName.toString()
    });
  }

  PublicUserInfo analyzeScanResult(Barcode result) {
    try {
      var json = jsonDecode(result.code);
      if (json["uid"] != null && json["name"] != null) {
        return PublicUserInfo(uid: json["uid"], name: json["name"]);
      }
      throw QRCodeServiceException(
          message:
              "QR code has wrong format. If this error persists please contact support.",
          prettyDetails:
              "QR code has wrong format. If this error persists please contact support.");
    } on FormatException catch (e) {
      log.e(
          "Scanned code does not seem to be a Good Wallet users QR code. Failed with error ${e.toString()}");
      throw QRCodeServiceException(
          message:
              "Scanned code does not seem to be a Good Wallet users' QR code. Please try again.",
          prettyDetails:
              "Scanned code does not seem to be a Good Wallet users' QR code. Please try again.");
    } catch (e) {
      log.e(
          "Could not find user information in scanned code because of error ${e.toString()}");
      throw QRCodeServiceException(
          message:
              "Failed to scan QR code. Try to increase the brightness of your screen.",
          prettyDetails:
              "Failed to scan QR code. Try to increase the brightness of your screen.");
    }
  }
}
