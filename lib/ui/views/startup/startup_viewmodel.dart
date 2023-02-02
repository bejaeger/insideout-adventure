import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/notifications/notification_controller.dart';
import 'package:afkcredits/services/permission_service.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';
import 'package:afkcredits/enums/authentication_method.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/services/environment_services.dart';
import 'package:afkcredits/ui/views/common_viewmodels/transfer_base_viewmodel.dart';

class StartUpViewModel extends TransferBaseViewModel {
  // ------------------------------------------------------------
  final EnvironmentService _environmentService = locator<EnvironmentService>();
  final PermissionService _permissionService = locator<PermissionService>();
  final log = getLogger("StartUpViewModel");

  // --------------------------------------------------------
  Future<void> runStartupLogic() async {
    // Only after at least the action method is set, the notification events are delivered
    NotificationController().initializeNotificationsEventListeners();
    await _environmentService.initialise();

    // TODO: Check for network connection!

    try {
      String? localUserId;
      UserRole? localUserRole;
      if (!kIsWeb) {
        localUserId = await userService.getLocallyLoggedInUserId();
        localUserRole = await userService.getLocallyLoggedUserRole();
      }

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
          if (!(await _permissionService.allPermissionsProvided())) {
            await navigationService.navigateTo(Routes.permissionsView);
          }
          await replaceWithHomeView(
              showBewareDialog: true, showNumberQuestsDialog: true);
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

  Future<void> runStartupScreenTimeLogic(
      {required ScreenTimeSession? screenTimeSession}) async {
    await replaceWithHomeView(
        showBewareDialog: true,
        screenTimeSession: screenTimeSession,
        showNumberQuestsDialog: true);
  }

  bool showLoadingScreen() {
    return true;
  }
}
