import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/users/admin/user_admin.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/exceptions/user_service_exception.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/users/afkcredits_authentication_result_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

abstract class AuthenticationViewModel extends FormViewModel
    with NavigationMixin {
  UserRole? role;
  AuthenticationViewModel({this.role});
  final NavigationService _navigationService = locator<NavigationService>();
  final UserService _userService = locator<UserService>();

  final log = getLogger("AuthenticationViewModel");

  @override
  void setFormStatus() {}

  Future saveData(AuthenticationMethod method, [UserRole? role]) async {
    // Run the authentication and set viewmodel to busy

    if (role != null && this.role == null) this.role = role;
    log.i("Trying to authenticate user with method $method and role $role ");
    final AFKCreditsAuthenticationResultService result = await (runBusyFuture(
        runAuthentication(method, this.role),
        throwException: true));

    if (!result.hasError) {
      log.i("Authentication successful, now initializing user data");

      try {
        await (runBusyFuture(
            initializeUser(
                uid: result.uid, fromLocalStorage: result.fromLocalStorage),
            throwException: true));
      } catch (e) {
        log.e("Failed initializing user with error: ${e.toString()}");
        String publicFacingMessage =
            "Authentication successful but initiliazation failed due to an internal problem. Please, try again later or contact our support.";
        if (e is UserServiceException)
          setValidationMessage(e.prettyDetails ?? publicFacingMessage);
        if (e is FirestoreApiException)
          setValidationMessage(e.prettyDetails ?? publicFacingMessage);
        else
          setValidationMessage(publicFacingMessage);
        return;
      }

      if (_userService.currentUserNullable == null) {
        // User logged in but account not created in database yet -> third party login
        // navigate to selectUserRoleView to select user role
        log.i(
            "User logged in with third-party provider. Navigate to select role view");
        _navigationService.replaceWith(Routes.selectRoleAfterLoginView,
            arguments: SelectRoleAfterLoginViewArguments(authMethod: method));
        return;
      } else {
        // User account found in database
        final role = this.role ?? _userService.getUserRole;

        log.i("User logged in with role $role");
        // ADD logic to navigate to different views depending on user role!
        // authenticated and initialized -> go to successRoute

        _navigationService.replaceWith(Routes.bottomBarLayoutTemplateView,
            arguments: BottomBarLayoutTemplateViewArguments(userRole: role));
        // if (role == UserRole.explorer) {
        //   navigationService.replaceWith(Routes.explorerHomeView);
        // } else if (role == UserRole.sponsor) {
        //   navigationService.replaceWith(Routes.sponsorHomeView);
        // } else if (role == UserRole.admin) {
        //   navigationService.replaceWith(Routes.adminHomeView);
        // }

        //_layoutService.setShowBottomNavBar(true);
      }
    } else {
      log.e(
          "User could not be logged in or signed-up, error: ${result.errorMessage}");
      // set validation message if we have an error
      setValidationMessage(result.errorMessage);
    }
  }

//Back Office Data Flow
  Future saveAdminData() async {
    log.v('Valued: $formValueMap');
    try {
      final result =
          await runBusyFuture(runAdminAuthResult(), throwException: true);
      log.i("This is the User Email: ${result.user!.email}");
      await _handleAuthResponse(authResult: result);
    } on FirestoreApiException catch (e) {
      log.i(e.toString());
    }
  }

  //This code needs to be moved accordingly, based on the discussion Ben and I will have.
  Future<void> _handleAuthResponse(
      {required FirebaseAuthenticationResult authResult}) async {
    log.v('AuthResult.hasError: ${authResult.hasError}');
    if (!authResult.hasError && authResult.user != null) {
      final adminUser = authResult.user;
      await _userService.syncOrCreateUserAdminAccount(
          userAdmin: UserAdmin(
              id: adminUser!.uid,
              email: adminUser.email,
              role: UserRole.adminMaster,
              name: 'Admin AFK'),
          method: AuthenticationMethod.dummy,
          fromLocalStorate: true);

      goToAdminHomeView(role: UserRole.adminMaster);
    } else {
      if (!authResult.hasError && authResult.user == null) {
        log.wtf('We have no Error But user is Null');
      }
    }
  }

  Future initializeUser({
    String? uid,
    bool fromLocalStorage = false,
  }) async {
    return await _userService.syncUserAccount(
        uid: uid, fromLocalStorage: fromLocalStorage);
  }

  //This is for the Back Office
  Future<FirebaseAuthenticationResult> runAdminAuthResult();

  // needs to be overrriden!
  Future<AFKCreditsAuthenticationResultService> runAuthentication(
      AuthenticationMethod method,
      [UserRole? role]);
}
