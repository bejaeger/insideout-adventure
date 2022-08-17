import 'dart:io' show Platform;
import 'package:afkcredits/notifications/notification_controller.dart';
import 'package:afkcredits/services/local_storage_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/environment_services.dart';
import 'package:afkcredits/ui/views/common_viewmodels/transfer_base_viewmodel.dart';
import 'package:places_service/places_service.dart';

class StartUpViewModel extends TransferBaseViewModel {
  final PlacesService _placesService = locator<PlacesService>();
  //final _geolocationService = locator<GeolocationService>();
  final EnvironmentService _environmentService = locator<EnvironmentService>();
  final LocalStorageService _localStorageService =
      locator<LocalStorageService>();
  //final _markersService = locator<MarkerService>();

  //dynamic position;

  final log = getLogger("StartUpViewModel");

  Future<void> runStartupLogic() async {
    // Only after at least the action method is set, the notification events are delivered
    NotificationController().initializeNotificationsEventListeners();
    await _environmentService.initialise();
    //final placesKey =  _environment.getValue(key)
    if (!kIsWeb) {
      // Platform call causes crash when running on web (22.02.22)
      if (Platform.isIOS) {
        _placesService.initialize(
            apiKey: _environmentService.getValue(GoogleMapsEnvKeyIOS));
      } else if (Platform.isAndroid) {
        _placesService.initialize(
            apiKey: _environmentService.getValue(GoogleMapsEnvKey));
      }
    }
    // TODO: Check for network connection!

    try {
      String? localUserId;
      UserRole? localUserRole;
      if (!kIsWeb) {
        localUserId = await userService.getLocallyLoggedInUserId();
        localUserRole = await userService.getLocallyLoggedUserRole();
      }

      // TODO: Need to rethink the following logic. What if the app is closed once we are in the children area? We should go back to the children area!

      if (localUserId != null) {
        log.v(
            'We have a user session on local storage. Sync the user profile ...');
        await userService.syncUserAccount(
            uid: localUserId, fromLocalStorage: true);
      } else {
        if (userService.hasLoggedInUser) {
          log.v(
              'We have an active user session on firebase. Sync the user profile ...');
          await userService.syncUserAccount();
        }
      }

      if (userService.hasLoggedInUser || localUserId != null) {
        if (userService.currentUserNullable == null) {
          // This means we used a third party provider when loggin in
          // the first time but didn't make it until
          // the role selection. Do it now!
          // TODO: Revisit this! Not clear if that is a case that will ever occur!
          log.wtf(
              "We found a logged in user but no user document in the database. This happens at the first time when logging in with a third party service and not choosing a role. So it is very rare and might also be due to some inconsistency in the backend during development! Maybe look into it but you might not need to worry about it.");
          await navigationService.replaceWith(
            Routes.selectRoleAfterLoginView,
            arguments: SelectRoleAfterLoginViewArguments(
                authMethod: AuthenticationMethod.google),
          );
          return;
        } else {
          final currentUser = userService.currentUser;
          log.v('User sync complete. User profile: $currentUser');

          // TODO: check whether there is an active screen time and if yes navigate to it, potentially handling completion event which includes an update of the database
          final String? id = await _localStorageService.getFromDisk(
              key: kLocalStorageScreenTimeSessionKey);
          if (id != null && localUserRole! == UserRole.explorer) {
            // FOUND SCREEN TIME! Navigate to screen time view
            log.i("Found active screen time, navigating to active view");
            navToActiveScreenTimeView(sessionId: id);
          } else {
            if (localUserRole == UserRole.adminMaster) {
              navToAdminHomeView(role: localUserRole!);
            } else {
              replaceWithHomeView();
            }
          }
        }
      } else {
        log.v('No user on disk, navigate to the LoginView');
        navigationService.replaceWith(Routes.loginView);
      }
    } catch (e) {
      log.e("Error, possibly no network connection? Error message: $e");
      navigationService.replaceWith(Routes.loginView);
    }
  }

  bool showLoadingScreen() {
    return true;
  }
}
