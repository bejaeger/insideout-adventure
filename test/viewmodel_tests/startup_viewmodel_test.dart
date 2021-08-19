import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/ui/views/startup/startup_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../helpers/datamodel_helpers.dart';
import '../helpers/test_helpers.dart';

StartUpViewModel _getModel() => StartUpViewModel();

void main() {
  group('StartupViewmodelTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    group('runStartupLogic -', () {
      test('When called should initiliase EnvironmentService', () async {
        final environmentService = getAndRegisterEnvironmentService();
        var model = _getModel();
        await model.runStartupLogic();
        verify(environmentService.initialise());
      });

      test(
          'When called should check if we have a logged in user on UserService',
          () async {
        final userService = getAndRegisterUserService();
        final model = _getModel();
        await model.runStartupLogic();
        verify(userService.hasLoggedInUser);
      });

      test('When we have no logged in user, should navigate to the login view',
          () async {
        final navigationService = getAndRegisterNavigationService();
        final model = _getModel();
        await model.runStartupLogic();

        verify(navigationService.replaceWith(Routes.loginView));
      });

      test(
          'When hasLoggedInUser is true, should call syncUserAccount on the userService',
          () async {
        final userService = getAndRegisterUserService(hasLoggedInUser: true);
        final model = _getModel();
        await model.runStartupLogic();

        verify(userService.syncUserAccount());
      });

      test(
          'When hasLoggedInUser is true, should get currentUser from userService',
          () async {
        final userService = getAndRegisterUserService(hasLoggedInUser: true);
        final model = _getModel();
        await model.runStartupLogic();

        verify(userService.currentUserNullable);
      });

      test('When currentUser has role sponsor, navigate to sponsorHomeView',
          () async {
        final navigationService = getAndRegisterNavigationService();
        getAndRegisterUserService(
            hasLoggedInUser: true, currentUser: getTestUserSponsor());
        final model = _getModel();
        await model.runStartupLogic();
        verify(navigationService.replaceWith(Routes.sponsorHomeView));
      });

      test('When currentUser has role explorer, navigate to explorerHomeView',
          () async {
        final navigationService = getAndRegisterNavigationService();
        getAndRegisterUserService(
            hasLoggedInUser: true, currentUser: getTestUserExplorer());
        final model = _getModel();
        await model.runStartupLogic();

        verify(navigationService.replaceWith(Routes.explorerHomeView));
      });

      // Next things to add!

      // test('When currentUser has role admin, navigate to adminHomeView',
      //     () async {
      //   final navigationService = getAndRegisterNavigationService();
      //   getAndRegisterUserService(
      //       hasLoggedInUser: true, currentUser: getTestUserAdmin());
      //   final model = _getModel();
      //   await model.runStartupLogic();

      //   verify(navigationService.replaceWith(Routes.adminHomeView));
      // });
    });
  });
}