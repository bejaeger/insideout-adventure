import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/exceptions/user_service_exception.dart';
import 'package:afkcredits/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;

abstract class AuthenticationViewModel extends FormViewModel {
  final NavigationService? navigationService = locator<NavigationService>();
  final UserService _userService = locator<UserService>();
  final log = getLogger("AuthenticationViewModel");

  @override
  void setFormStatus() {}

  Future saveData(AuthenticationMethod method) async {
    // Run the authentication and set viewmodel to busy
    final FirebaseAuthenticationResult result =
        await (runBusyFuture(runAuthentication(method)));

    if (!result.hasError) {
      log.i("Authentication successful, now initializing user data");

      try {
        await (runBusyFuture(initializeUser(result.user!)));
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

      // TODO
      // ADD logic to navigate to different views depending on user role!
      // authenticated and initialized -> go to successRoute
      if (method == AuthenticationMethod.dummy) {
        navigationService!.replaceWith(Routes.explorerHomeView);
      } else {
        navigationService!.replaceWith(Routes.explorerHomeView);
      }
    } else {
      log.e(
          "User could not be logged in or signed-up, error: ${result.errorMessage}");
      // set validation message if we have an error
      setValidationMessage(result.errorMessage);
    }
  }

  Future initializeUser(firebase.User user) async {
    return await _userService.syncOrCreateUserAccount(
        user: User(
      uid: user.uid,
      role: UserRole.explorer,
      fullName: user.displayName ?? "",
      email: user.email ?? "",
      newUser: true,
      explorerIds: [],
      sponsorIds: [],
    ));
  }

  // needs to be overrriden!
  Future<FirebaseAuthenticationResult> runAuthentication(
      AuthenticationMethod method);
}
