import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/ui/views/login/login_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_helpers.dart';

LoginViewModel _getModel() => LoginViewModel();

void main() {
  group('LoginViewModelTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    group('saveData Function - Handling user input', () {
      test(
          'When called for logging in and user is sponsor, navigate to sponsor home view',
          () async {
        final navigationService = getAndRegisterNavigationService();
        final userService = getAndRegisterUserService();
        when(userService.getUserRole).thenReturn(UserRole.sponsor);
        final model = _getModel();
        await model.saveData(AuthenticationMethod.email);
        verify(navigationService.replaceWith(Routes.bottomBarLayoutTemplateView,
            arguments: BottomBarLayoutTemplateViewArguments(
                userRole: UserRole.sponsor)));
      });

      test(
          'When called for logging in and user is admin, navigate to admin home view',
          () async {
        final navigationService = getAndRegisterNavigationService();
        final userService = getAndRegisterUserService();
        when(userService.getUserRole).thenReturn(UserRole.admin);
        final model = _getModel();
        await model.saveData(AuthenticationMethod.email);
        verify(navigationService.replaceWith(Routes.adminHomeView));
      });

      test(
          'When called for logging in and user is explorer, navigate to explorer home view',
          () async {
        final navigationService = getAndRegisterNavigationService();
        final userService = getAndRegisterUserService();
        when(userService.getUserRole).thenReturn(UserRole.explorer);
        final model = _getModel();
        await model.saveData(AuthenticationMethod.email);
        verify(await navigationService.replaceWith(
            Routes.bottomBarLayoutTemplateView,
            arguments: BottomBarLayoutTemplateViewArguments(
                userRole: UserRole.explorer)));
      });

      test(
          'When logging in with third party provider for the first time, need to make the user select a role',
          () async {
        final navigationService = getAndRegisterNavigationService();
        getAndRegisterUserService(newUser: true);
        final model = _getModel();
        await model.saveData(AuthenticationMethod.google);
        // currently select role with dialog
        verify(navigationService.replaceWith(Routes.selectRoleAfterLoginView));
      });
    });
  });
}
