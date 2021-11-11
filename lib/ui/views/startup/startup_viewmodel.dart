import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/services/environment_services.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/layout_template_viewmodel.dart';
import 'package:geolocator/geolocator.dart';
import 'package:places_service/places_service.dart';

class StartUpViewModel extends LayoutTemplateViewModel {
  final PlacesService _placesService = locator<PlacesService>();
  final _geolocationService = locator<GeolocationService>();
  final EnvironmentService _environmentService = locator<EnvironmentService>();
  final _markersService = locator<MarkerService>();

  dynamic position;

  final log = getLogger("StartUpViewModel");

  Future<void> runStartupLogic() async {
    await _environmentService.initialise();
    //final placesKey =  _environment.getValue(key)
    _placesService.initialize(
        apiKey: _environmentService.getValue(GoogleMapsEnvKey));

    // TODO: Check for network connection!

    try {
      final localUserId = await userService.getLocallyLoggedInUserId();
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
          log.w(
              "We found a logged in user but no user document in the database. This happens at the first time when logging in with a third party service and not choosing a role. So it is very rare and might also be due to some inconsistency in the backend during development! Maybe look into it but you might not need to worry about it.");
          await navigationService.replaceWith(Routes.selectRoleAfterLoginView);
          return;
        } else {
          final currentUser = userService.currentUser;
          log.v('User sync complete. User profile: $currentUser');
          replaceToHomeView();
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
