import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/exceptions/user_service_exception.dart';
import 'package:afkcredits/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

abstract class AuthenticationViewModel extends FormViewModel {
  UserRole? role;
  AuthenticationViewModel({this.role});
  final NavigationService navigationService = locator<NavigationService>();
  final UserService _userService = locator<UserService>();
  final log = getLogger("AuthenticationViewModel");

  @override
  void setFormStatus() {}

  Future saveData(AuthenticationMethod method, [UserRole? role]) async {
    // Run the authentication and set viewmodel to busy

    if (role != null && this.role == null) this.role = role;
    final FirebaseAuthenticationResult result =
        await (runBusyFuture(runAuthentication(method, this.role)));

    if (!result.hasError) {
      log.i("Authentication successful, now initializing user data");

      try {
        await (runBusyFuture(initializeUser()));
        // If current user is not yet set we need to create it
        // We end up here when the user signs up with third-party providers!
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
        // User logged in but account not created yet -> third party login
        // navigate to selectUserRoleView to select user role
        log.i(
            "User logged in with third-party provider. Navigate to select role view");
        navigationService.replaceWith(Routes.selectRoleAfterLoginView);
      } else {
        // User account found in database
        final role = this.role ?? _userService.getUserRole;

        log.i("User logged in with role $role");
        // ADD logic to navigate to different views depending on user role!
        // authenticated and initialized -> go to successRoute
        if (role == UserRole.explorer) {
          navigationService.replaceWith(Routes.explorerHomeView);
        } else if (role == UserRole.sponsor) {
          navigationService.replaceWith(Routes.sponsorHomeView);
        } else if (role == UserRole.admin) {
          navigationService.replaceWith(Routes.adminHomeView);
        }
      }
    } else {
      log.e(
          "User could not be logged in or signed-up, error: ${result.errorMessage}");
      // set validation message if we have an error
      setValidationMessage(result.errorMessage);
    }
  }

  Future initializeUser() async {
    return await _userService.syncUserAccount();
  }

  Future createUserAccount(UserRole role) async {
    return await _userService.createUserAccountFromFirebaseUser(role: role);
  }

  // needs to be overrriden!
  Future<FirebaseAuthenticationResult> runAuthentication(
      AuthenticationMethod method,
      [UserRole? role]);
}
