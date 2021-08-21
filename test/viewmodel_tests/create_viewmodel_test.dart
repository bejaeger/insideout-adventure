import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/ui/views/create_account/create_account_viewmodel.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import '../helpers/test_helpers.dart';

CreateAccountViewModel _getModelSponsor() =>
    CreateAccountViewModel(role: UserRole.sponsor);
CreateAccountViewModel _getModelExplorer() =>
    CreateAccountViewModel(role: UserRole.explorer);

void main() {
  group('CreateAccountViewModel -', () {
    setUp(() => registerServices());
    tearDown(() => unregisterServices());

    group('saveData Function - Handling user input when an account is created',
        () {
      test(
          'When called for creating user with sponsor as role, navigate to sponsor home view',
          () async {
        final navigationService = getAndRegisterNavigationService();
        final model = _getModelSponsor();
        await model.saveData(AuthenticationMethod.email);
        verify(navigationService.replaceWith(Routes.sponsorHomeView));
      });

      test(
          'When called for creating user with explorer as role, navigate to explorer home view',
          () async {
        final navigationService = getAndRegisterNavigationService();
        final model = _getModelExplorer();
        await model.saveData(AuthenticationMethod.email);
        verify(navigationService.replaceWith(Routes.explorerHomeView));
      });
    });
  });
}
