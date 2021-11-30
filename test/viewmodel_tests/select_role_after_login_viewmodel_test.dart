import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/ui/views/login/select_role_after_login_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';

import '../test_data/test_datamodels.dart';
import '../helpers/test_helpers.dart';

SelectRoleAfterLoginViewModel _getModel() => SelectRoleAfterLoginViewModel();

void main() {
  group('SelectRoleAfterLoginViewmodelTest -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    group('createSponsorAccountAndNavigateToSponsorHome -', () {
      test(
          'When called need to create user account, sync user, and navigate to the correct view',
          () async {
        final service =
            getAndRegisterUserService(currentUser: getTestUserSponsor());
        final navService = getAndRegisterNavigationService();
        when(service.createUserAccountFromFirebaseUser(role: UserRole.sponsor))
            .thenAnswer((_) async => getTestUserSponsor());
        when(service.syncUserAccount()).thenAnswer((_) async => null);
        final model = _getModel();
        await model.createSponsorAccountAndNavigateToSponsorHome();
        verify(
            service.createUserAccountFromFirebaseUser(role: UserRole.sponsor));
        verify(service.syncUserAccount());
        verify(navService.replaceWith(Routes.bottomBarLayoutTemplateView, arguments: BottomBarLayoutTemplateViewArguments(userRole: UserRole.sponsor)));
      });
    });

    group('createExploreAccountAndNavigateToExplorerHome -', () {
      test(
          'When called need to create user account, sync user, and navigate to the correct view',
          () async {
        final service =
            getAndRegisterUserService(currentUser: getTestUserExplorer());
        final navService = getAndRegisterNavigationService();
        when(service.createUserAccountFromFirebaseUser(role: UserRole.explorer))
            .thenAnswer((_) async => getTestUserExplorer());
        when(service.syncUserAccount()).thenAnswer((_) async => null);
        final model = _getModel();
        await model.createExploreAccountAndNavigateToExplorerHome();
        verify(
            service.createUserAccountFromFirebaseUser(role: UserRole.explorer));
        verify(service.syncUserAccount());
        verify(await navigationService.replaceWith(Routes.bottomBarLayoutTemplateView, arguments: BottomBarLayoutTemplateViewArguments(userRole: UserRole.explorer)));
      });
    });
  });
}
