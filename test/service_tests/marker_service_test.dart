import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_data/test_datamodels.dart';
import '../helpers/test_helpers.dart';

MarkerService _getService() => MarkerService();

void main() {
  group('MarkerServiceTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    group('isUserCloseby -', () {
      test(
          'When isUserCloseby is called call locationService with marker coordinates',
          () async {
        //arrange
        final locationService =
            getAndRegisterGeolocationService(isCloseBy: true);
        final service = _getService();
        //acts
        await service.isUserCloseby(marker: getTestMarker1());
        //asset
        verify(locationService.isUserCloseby(
            lat: getTestMarker1().lat!, lon: getTestMarker1().lon!));
      });
    });
  });
}
