import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_data/test_constants.dart';
import '../test_data/test_datamodels.dart';
import '../helpers/test_helpers.dart';

QRCodeService _getService() => QRCodeService();

void main() {
  group('QRCodeServiceTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    group('convertMarkerToQrCodeString -', () {
      test('Marker represented as a string encoded in the qr code', () async {
        final service = _getService();
        expect(service.convertMarkerToQrCodeString(marker: getTestMarker1()),
            kTestMarker1QrCodeString);
      });
    });

    group('convertQrCodeStringToMarker -', () {
      test('Return marker object from qrcode string', () {
        final service = _getService();
        expect(
            service.convertQrCodeStringToMarker(
                qrCodeString: kTestMarker1QrCodeString),
            getTestMarker1NullCoordinates());
      });
    });

    group('getMarkerFromQrCodeString -', () {
      test('Return marker with actual coordinates looked up at in our database',
          () async {
        // arrange
        final firestoreApi = getAndRegisterFirestoreApi();
        when(firestoreApi.getMarkerFromQrCodeId(qrCodeId: anyNamed("qrCodeId")))
            .thenAnswer((_) async => getTestMarker1());
        // act
        final service = _getService();
        await service.getMarkerFromQrCodeString(
            qrCodeString: kTestMarker1QrCodeString);
        // assert
        verify(
            firestoreApi.getMarkerFromQrCodeId(qrCodeId: kTestMarker1QrCodeId));
      });
    });
  });
}
