import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/ui/views/startup/startup_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_data/test_constants.dart';
import '../test_data/test_datamodels.dart';
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
          'When called should check if there is a logged in user in local storage',
          () async {
        final userService = getAndRegisterUserService();
        final model = _getModel();
        await model.runStartupLogic();
        verify(userService.getLocallyLoggedInUserId());
      });

      test(
          'When called should check if there is a logged in user in local storage and if yes, call syncUserAccount',
          () async {
        final userService = getAndRegisterUserService(localUserId: kTestUid);
        final model = _getModel();
        await model.runStartupLogic();
        verify(userService.syncUserAccount(
            uid: anyNamed("uid"), fromLocalStorage: true));
      });

      test(
          'When called should check if we have a logged in firebase user on UserService',
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

      test(
          'When hasLoggedInUser is true but no user account is created yet (third-party login), navigate to selectRoleAfterLoginView',
          () async {
        final navigationService = getAndRegisterNavigationService();
        getAndRegisterUserService(
            hasLoggedInUser: true, currentUser: null, newUser: true);
        final model = _getModel();
        await model.runStartupLogic();
        verify(navigationService.replaceWith(Routes.selectRoleAfterLoginView));
      });

      test('When currentUser has role sponsor, navigate to sponsorHomeView',
          () async {
        final navigationService = getAndRegisterNavigationService();
        getAndRegisterUserService(
            hasLoggedInUser: true, currentUser: getTestUserSponsor());
        final model = _getModel();
        await model.runStartupLogic();
        verify(navigationService.replaceWith(Routes.bottomBarLayoutTemplateView, arguments: BottomBarLayoutTemplateViewArguments(userRole: UserRole.sponsor)));
      });

      test('When currentUser has role sponsor, navigate to adminHomeView',
          () async {
        final navigationService = getAndRegisterNavigationService();
        getAndRegisterUserService(
            hasLoggedInUser: true, currentUser: getTestUserAdmin());
        final model = _getModel();
        await model.runStartupLogic();
        verify(navigationService.replaceWith(Routes.adminHomeView));
      });

      test('When currentUser has role explorer, navigate to explorerHomeView',
          () async {
        final navigationService = getAndRegisterNavigationService();
        getAndRegisterUserService(
            hasLoggedInUser: true, currentUser: getTestUserExplorer());
        final model = _getModel();
        await model.runStartupLogic();

        verify(await navigationService.replaceWith(Routes.bottomBarLayoutTemplateView, arguments: BottomBarLayoutTemplateViewArguments(userRole: UserRole.explorer)));
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
