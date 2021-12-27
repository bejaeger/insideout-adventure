import 'dart:io' show Platform;
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/environment_services.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/navigation/navigation_mixin.dart';
import 'package:afkcredits/ui/views/common_viewmodels/transfer_base_viewmodel.dart';
import 'package:places_service/places_service.dart';

class StartUpViewModel extends TransferBaseViewModel with NavigationMixin {
  final PlacesService _placesService = locator<PlacesService>();
  final _geolocationService = locator<GeolocationService>();
  final EnvironmentService _environmentService = locator<EnvironmentService>();
  final _markersService = locator<MarkerService>();

  dynamic position;

  final log = getLogger("StartUpViewModel");

  Future<void> runStartupLogic() async {
    await _environmentService.initialise();
    //final placesKey =  _environment.getValue(key)
    if (Platform.isIOS) {
      _placesService.initialize(
          apiKey: _environmentService.getValue(GoogleMapsEnvKeyIOS));
    } else if (Platform.isAndroid)
      _placesService.initialize(
          apiKey: _environmentService.getValue(GoogleMapsEnvKey));

    // TODO: Check for network connection!

    try {
      final localUserId = await userService.getLocallyLoggedInUserId();
      final localUserRole = await userService.getLocallyLoggedUserRole();
      if (localUserId != null) {
        log.v(
            'We have a user session on local storage. Sync the user profile ...');
        await userService.syncUserAccount(
            uid: localUserId, fromLocalStorage: true);
      }
      if (userService.hasLoggedInUser) {
        log.v(
            'We have an active user session on firebase. Sync the user profile ...');
        await userService.syncUserAccount();
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
          if (localUserRole == UserRole.adminMaster) {
            goToAdminHomeView(role: localUserRole!);
          } else {
            replaceWithHomeView();
          }
        }
      } else {
        log.v('No user on disk, navigate to the LoginView');
        navigationService.replaceWith(Routes.loginView);
      }
    } catch (e) {
      log.e(
          "Error, possibly no network connection could not be found? Error message: $e");
      navigationService.replaceWith(Routes.loginView);
    }
  }

  bool showLoadingScreen() {
    return true;
  }
}
