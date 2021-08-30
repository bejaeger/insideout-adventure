import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/datamodel_helpers.dart';
import '../helpers/test_helpers.dart';

UserService _getService() => UserService();

void main() {
  group('UserServiceTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    group('syncUserAccount -', () {
      test(
          'When called with uid as argument and isLocallyStoragedUser true, save uid to disk',
          () async {
        final localStorageService = getAndRegisterLocalStorageService();
        getAndRegisterFirestoreApi(user: getTestUserExplorer());
        final service = _getService();
        await service.syncUserAccount(uid: kTestUid, fromLocalStorage: true);
        verify(localStorageService.saveToDisk(
            key: anyNamed("key"), value: anyNamed("value")));
      });
    });

    group('handleLogoutEvent -', () {
      test(
          'When called need to delete uid from local disk and logout from firebase service',
          () async {
        final localStorageService = getAndRegisterLocalStorageService();
        final firebaseAuthenticationService =
            getAndRegisterFirebaseAuthenticationService();
        when(localStorageService.deleteFromDisk(key: kLocalStorageUidKey))
            .thenAnswer((_) async => null);
        final service = _getService();
        await service.handleLogoutEvent();
        verify(localStorageService.deleteFromDisk(key: kLocalStorageUidKey));
        verify(firebaseAuthenticationService.logout());
      });
    });
  });
}
