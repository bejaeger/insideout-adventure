import 'dart:async';
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/exceptions/firestore_api_exception.dart';
import 'package:afkcredits/exceptions/user_service_exception.dart';
import 'package:afkcredits/services/local_storage_service.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/services/users/afkcredits_authentication_result_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

abstract class AuthenticationViewModel extends FormViewModel
    with NavigationMixin {
  UserRole? role;
  AuthenticationViewModel({this.role});
  final NavigationService _navigationService = locator<NavigationService>();
  final UserService _userService = locator<UserService>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();

  final log = getLogger("AuthenticationViewModel");

  @override
  void setFormStatus() {}

  Future saveData(AuthenticationMethod method, [UserRole? role]) async {
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
        logout();
        log.i(
            "User logged in with third-party provider. Navigate to select role view");
        _navigationService.replaceWith(Routes.loginView,
            arguments: SelectRoleAfterLoginViewArguments(authMethod: method));
        return;
      } else {
        final role = this.role ?? _userService.getUserRole;
        log.i("User logged in with role $role");

        if (role == UserRole.explorer || role == UserRole.superUser) {
          _navigationService.replaceWith(Routes.explorerHomeView);
        } else {
          final onboarded = await _localStorageService.getFromDisk(
              key: kLocalStorageSawOnBoardingKey);
          if (onboarded == _userService.currentUser.uid) {
            await _navigationService.replaceWith(
              Routes.parentHomeView,
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
    } else {
      log.e(
          "User could not be logged in or signed-up, error: ${result.errorMessage}");
      setValidationMessage(result.errorMessage);
    }
  }

  Future initializeUser({
    String? uid,
    bool fromLocalStorage = false,
  }) async {
    return await _userService.syncUserAccount(
        uid: uid, fromLocalStorage: fromLocalStorage);
  }

  // needs to be overrriden!
  Future<AFKCreditsAuthenticationResultService> runAuthentication(
      AuthenticationMethod method,
      [UserRole? role]);
}
