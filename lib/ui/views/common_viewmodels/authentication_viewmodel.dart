import 'dart:async';

import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/exceptions/user_service_exception.dart';
import 'package:afkcredits/services/local_secure_storage_service.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/users/insideout_authentication_result_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

abstract class AuthenticationViewModel extends FormViewModel
    with NavigationMixin {
  UserRole? role;
  AuthenticationViewModel({this.role});

  final NavigationService _navigationService = locator<NavigationService>();
  final UserService _userService = locator<UserService>();
  final LocalSecureStorageService _localStorageService =
      locator<LocalSecureStorageService>();

  final log = getLogger("AuthenticationViewModel");

  @override
  void setFormStatus() {}

  Future saveData(AuthenticationMethod method, [UserRole? role]) async {
    if (role != null && this.role == null) this.role = role;
    log.i("Trying to authenticate user with method $method and role $role ");
    final InsideOutAuthenticationResultService result = await (runBusyFuture(
        runAuthentication(method, this.role),
        throwException: true));

    if (!result.hasError) {
      log.i("Authentication successful, now initializing user data");

      try {
        await (runBusyFuture(
            _userService.syncUserAccount(
                uid: result.uid, fromLocalStorage: result.fromLocalStorage),
            throwException: true));
      } catch (e) {
        log.e("Failed initializing user with error: ${e.toString()}");
        String publicFacingMessage =
            "You could not be logged in. We apologize. Please, try again later or contact our support.";
        if (e is UserServiceException)
          setValidationMessage(e.prettyDetails ?? publicFacingMessage);
        if (e is FirestoreApiException)
          setValidationMessage(e.prettyDetails ?? publicFacingMessage);
        else
          setValidationMessage(publicFacingMessage);
        return;
      }

      bool userAccountNotCreated = _userService.currentUserNullable == null;
      if (userAccountNotCreated) {
        // User logged in but account not created in database yet -> e.g. when process
        // was interrupted or user used third party login and something went wrong.
        // navigate back to loginView!
        log.w(
            "User logged in with third-party provider but no account has been created yet. Trying to create account");
        setBusy(true);
        await _userService.createUserAccountFromFirebaseUser(
            role: this.role ?? UserRole.guardian, authMethod: method);
        await _userService.syncUserAccount(
            uid: result.uid, fromLocalStorage: result.fromLocalStorage);
        setBusy(false);
      }
      userAccountNotCreated = _userService.currentUserNullable == null;
      if (userAccountNotCreated) {
        log.e(
            "Something went wrong with the authentication. Navigating to login view");
        _navigationService.replaceWith(Routes.loginView);
        setValidationMessage(
            "We could not authenticate this account. Please try again later.");
        return;
      } else {
        navigateToViewAfterSyncingAccount();
      }
    } else {
      log.e(
          "User could not be logged in or signed-up, error: ${result.errorMessage}");
      // HACK!
      // if 'canceled' in message it means the user dismissed the pop-up
      // For iOS, the message includes `ErrorCode.canceled`
      if (!result.errorMessage!.contains('canceled')) {
        setValidationMessage(result.errorMessage);
      }
    }
  }

  void navigateToViewAfterSyncingAccount() async {
    final role = this.role ?? _userService.getUserRole;
    log.i("User logged in with role $role");

    if (role == UserRole.ward || role == UserRole.superUser) {
      _navigationService.replaceWith(Routes.wardHomeView);
    } else {
      final onboarded = await _localStorageService.getFromDisk(
          key: kLocalStorageSawOnBoardingKey);
      if (onboarded == _userService.currentUser.uid) {
        await _navigationService.replaceWith(
          Routes.highlightGuardianHomeView,
        );
      } else {
        await _navigationService.replaceWith(
          Routes.onBoardingScreensView,
        );
        _localStorageService.saveToDisk(
            key: kLocalStorageSawOnBoardingKey,
            value: _userService.currentUser.uid);
      }
    }
  }

  Future<InsideOutAuthenticationResultService> runAuthentication(
      AuthenticationMethod method,
      [UserRole? role]);
}
