import 'package:afkcredits/services/maps/google_map_service.dart';
import 'package:afkcredits/services/maps/google_map_service.dart';
import 'package:afkcredits/services/maps/google_map_service.dart';
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked_core/stacked_core.dart';
import 'package:stacked_firebase_auth/src/firebase_authentication_service.dart';
import 'package:stacked_services/src/bottom_sheet/bottom_sheet_service.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_services/src/snackbar/snackbar_service.dart';

import '../apis/firestore_api.dart';
import '../apis/notion_api.dart';
import '../app_config_provider.dart';
import '../notifications/notifications_service.dart';
import '../services/cloud_storage_service.dart/cloud_storage_service.dart';
import '../services/connectivity/connectivity_service.dart';
import '../services/environment_services.dart';
import '../services/feedback_service/feedback_service.dart';
import '../services/gamification/gamification_service.dart';
import '../services/geolocation/geolocation_service.dart';
import '../services/layout/layout_service.dart';
import '../services/local_storage_service.dart';
import '../services/maps/google_map_service.dart';
import '../services/maps/map_state_service.dart';
import '../services/markers/marker_service.dart';
import '../services/permission_service.dart';
import '../services/quest_testing_service/quest_testing_service.dart';
import '../services/quests/active_quest_service.dart';
import '../services/quests/quest_service.dart';
import '../services/quests/stopwatch_service.dart';
import '../services/screentime/screen_time_service.dart';
import '../services/users/user_service.dart';
import '../ui/views/explorer_home/explorer_home_viewmodel.dart';
import '../ui/views/map/map_viewmodel.dart';
import '../ui/views/parent_home/parent_home_viewmodel.dart';
import '../utils/image_selector.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator(
    {String? environment, EnvironmentFilter? environmentFilter}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => ConnectivityService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => GeolocationService());
  locator.registerLazySingleton(() => EnvironmentService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => FirestoreApi());
  locator.registerLazySingleton(() => FirebaseAuthenticationService());
  locator.registerLazySingleton(() => AppConfigProvider());
  locator.registerLazySingleton(() => LayoutService());
  locator.registerLazySingleton(() => LocalStorageService());
  locator.registerLazySingleton(() => FlutterSecureStorage());
  locator.registerLazySingleton(() => QuestService());
  locator.registerLazySingleton(() => ActiveQuestService());
  locator.registerLazySingleton(() => StopWatchService());
  locator.registerLazySingleton(() => MarkerService());
  locator.registerLazySingleton(() => QuestTestingService());
  locator.registerLazySingleton(() => GamificationService());
  locator.registerLazySingleton(() => MapStateService());
  locator.registerLazySingleton(() => CloudStorageService());
  locator.registerLazySingleton(() => ImageSelector());
  locator.registerLazySingleton(() => NotionApi());
  locator.registerLazySingleton(() => FeedbackService());
  locator.registerLazySingleton(() => ScreenTimeService());
  locator.registerLazySingleton(() => PermissionService());
  locator.registerLazySingleton(() => NotificationsService());
  locator.registerLazySingleton(() => ParentHomeViewModel());
  locator.registerLazySingleton(() => ExplorerHomeViewModel());
  final mapViewModel = await presolveMapViewModel();
  locator.registerSingleton(mapViewModel);

  locator.registerLazySingleton(() => GoogleMapService());
}
