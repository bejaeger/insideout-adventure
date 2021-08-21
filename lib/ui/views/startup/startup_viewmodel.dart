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
      final localUserId = await _userService.getLocallyLoggedInUserId();
      if (localUserId != null) {
        log.v(
            'We have a user session on local storage. Sync the user profile ...');
        await _userService.syncUserAccount(
            uid: localUserId, fromLocalStorage: true);
      }
      if (_userService.hasLoggedInUser) {
        log.v(
            'We have an active user session on firebase. Sync the user profile ...');
        await _userService.syncUserAccount();
      }

      if (_userService.hasLoggedInUser || localUserId != null) {
        if (_userService.currentUserNullable == null) {
          // This means we used a third party provider when loggin in
          // the first time but didn't make it until
          // the role selection. Do it now!
          log.w(
              "We found a logged in user but no user document in the database. This happens at the first time when logging in with a third party service and not choosing a row. So this is very rare! Maybe look into it.");
          await _navigationService.replaceWith(Routes.selectRoleAfterLoginView);
          return;
        } else {
          final currentUser = _userService.currentUser;
          log.v('User sync complete. User profile: $currentUser');

          if (currentUser.role == UserRole.explorer) {
            log.v(
                'We found an explorer account, let\'s navigate to the home screen.');
            _navigationService.replaceWith(Routes.explorerHomeView);
          } else if (currentUser.role == UserRole.sponsor) {
            log.v('We have a sponsor account. Let\'s the sponsor home screen!');
            _navigationService.replaceWith(Routes.sponsorHomeView);
            // navigate to home view
          }
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
}
