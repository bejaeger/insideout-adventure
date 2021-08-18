import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/environment_services.dart';
import 'package:afkcredits/services/user_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:places_service/places_service.dart';
import 'package:stacked_services/stacked_services.dart';

class StartUpViewModel extends BaseModel {
  final NavigationService _navigationService = locator<NavigationService>();
  final PlacesService _placesService = locator<PlacesService>();
  final EnvironmentService _environmentService = locator<EnvironmentService>();
  final UserService _userService = locator<UserService>();
  final log = getLogger("StartUpViewModel");

  Future<void> runStartupLogic() async {
    await _environmentService.initialise();
    //final placesKey =  _environment.getValue(key)
    _placesService.initialize(
        apiKey: _environmentService.getValue(GoogleMapsEnvKey));

    try {
      if (_userService.hasLoggedInUser) {
        log.v('We have a user session on disk. Sync the user profile ...');
        await _userService.syncUserAccount();

        final currentUserNullable = _userService.currentUserNullable;

        if (currentUserNullable == null) {
          log.wtf(
              "We found a logged in user but no user document in the database. This should never happen and is likely due to an inconsistency in the backend!");
          throw Exception("User signed in but not initialized!");
        }
        final currentUser = _userService.currentUser;
        log.v('User sync complete. User profile: $currentUser');

        if (currentUser.role == UserRole.explorer) {
          log.v(
              'We found an explorer account, let\'s navigate to the home screen.');
          navigateToExplorerHomeView();
        } else if (currentUser.role == UserRole.sponsor) {
          log.v('We have a sponsor account. Let\'s the sponsor home screen!');
          navigateToSponsorHomeView();
          // navigate to home view
        }
        // TODO:
        // else if (currentUser.role == UserRole.admin) {
        //   log.v('We have an admin account. We will go to the admin home view!');
        //   navigateToAdminHomeView();
        //   // navigate to home view
        // }
      } else {
        log.v('No user on disk, navigate to the LoginView');
        _navigationService.replaceWith(Routes.loginView);
      }
    } catch (e) {
      log.e("$e");
    }
  }

  bool showLoadingScreen() {
    return true;
  }

  void navigateToSponsorHomeView() {
    _navigationService.replaceWith(Routes.sponsorHomeView);
  }

  void navigateToExplorerHomeView() {
    _navigationService.replaceWith(Routes.explorerHomeView);
  }

  void navigateToMapView() {
    _navigationService.replaceWith(Routes.mapView);
  }
}
