import 'package:afkcredits/services/maps/google_map_service.dart';
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:dio/dio.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
import 'package:places_service/places_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

import '../apis/cloud_functions_api.dart';
import '../apis/direction_api.dart';
import '../apis/firestore_api.dart';
import '../app_config_provider.dart';
import '../services/cloud_firestore_storage/cloud_storage_services.dart';
import '../services/connectivity/connectivity_service.dart';
import '../services/environment_services.dart';
import '../services/gamification/gamification_service.dart';
import '../services/geolocation/geolocation_service.dart';
import '../services/giftcard/gift_card_service.dart';
import '../services/layout/layout_service.dart';
import '../services/local_storage_service.dart';
import '../services/maps/google_map_service.dart';
import '../services/maps/map_state_service.dart';
import '../services/markers/marker_service.dart';
import '../services/payments/payment_service.dart';
import '../services/payments/transfers_history_service.dart';
import '../services/pedometer/pedometer_service.dart';
import '../services/qrcodes/qrcode_service.dart';
import '../services/quest_testing_service/quest_testing_service.dart';
import '../services/quests/active_quest_service.dart';
import '../services/quests/quest_service.dart';
import '../services/quests/stopwatch_service.dart';
import '../services/screentime/screen_time_service.dart';
import '../services/users/user_service.dart';
import '../ui/views/map/map_viewmodel.dart';
import '../utils/cloud_storage_result/cloud_storage_result.dart';
import '../utils/image_selector/image_selector.dart';

final locator = StackedLocator.instance;

Future setupLocator(
    {String? environment, EnvironmentFilter? environmentFilter}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => CloudStorageService());
  locator.registerLazySingleton(() => CloudStorageResult());
  locator.registerLazySingleton(() => ImageSelector());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => ConnectivityService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => PlacesService());
  locator.registerLazySingleton(() => GeolocationService());
  locator.registerLazySingleton(() => EnvironmentService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => FirestoreApi());
  locator.registerLazySingleton(() => CloudFunctionsApi());
  locator.registerLazySingleton(() => FirebaseAuthenticationService());
  locator.registerLazySingleton(() => AppConfigProvider());
  locator.registerLazySingleton(() => LayoutService());
  locator.registerLazySingleton(() => LocalStorageService());
  locator.registerLazySingleton(() => FlutterSecureStorage());
  locator.registerLazySingleton(() => TransfersHistoryService());
  locator.registerLazySingleton(() => QuestService());
  locator.registerLazySingleton(() => ActiveQuestService());
  locator.registerLazySingleton(() => PaymentService());
  locator.registerLazySingleton(() => StopWatchService());
  locator.registerLazySingleton(() => QRCodeService());
  locator.registerLazySingleton(() => MarkerService());
  locator.registerLazySingleton(() => DirectionsAPI());
  locator.registerLazySingleton(() => GiftCardService());
  locator.registerLazySingleton(() => ScreenTimeService());
  locator.registerLazySingleton(() => QuestTestingService());
  locator.registerLazySingleton(() => GamificationService());
  locator.registerLazySingleton(() => MapStateService());
  locator.registerLazySingleton(() => PedometerService());
  final mapViewModel = await presolveMapViewModel();
  locator.registerSingleton(mapViewModel);

  locator.registerLazySingleton(() => GoogleMapService());
}
