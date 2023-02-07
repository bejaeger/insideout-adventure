import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/notifications/notification_controller.dart';
import 'package:afkcredits/services/permission_service.dart';
import 'package:afkcredits/ui/views/common_viewmodels/base_viewmodel.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:afkcredits/app/app.locator.dart';
import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/app/app.router.dart';

class StartUpViewModel extends BaseModel {
  final PermissionService _permissionService = locator<PermissionService>();
  final log = getLogger("StartUpViewModel");

  Future<void> runStartupLogic() async {
    // Only after at least the action method is set, the notification events are delivered
    NotificationController().initializeNotificationsEventListeners();

    // TODO: Check for network connection!

    try {
      String? localUserId;
      if (!kIsWeb) {
        localUserId = await userService.getLocallyLoggedInUserId();
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
          log.w(
              "We found a logged in user but no user document in the database. This happens when the process of logging in with a third party service is interrupted.");
          await navigationService.replaceWith(Routes.loginView);
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
        log.i('No user on disk, navigate to the LoginView');
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
