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

import '../apis/direction_api.dart';
import '../apis/firestore_api.dart';
import '../flavor_config.dart';
import '../services/environment_services.dart';
import '../services/geolocation/geolocation_service.dart';
import '../services/giftcard/giftcard_services.dart';
import '../services/layout/layout_service.dart';
import '../services/local_storage_service.dart';
import '../services/markers/marker_service.dart';
import '../services/payments/payment_service.dart';
import '../services/payments/transfers_history_service.dart';
import '../services/qrcodes/qrcode_service.dart';
import '../services/quests/quest_service.dart';
import '../services/quests/stopwatch_service.dart';
import '../services/users/user_service.dart';

final locator = StackedLocator.instance;

void setupLocator({String? environment, EnvironmentFilter? environmentFilter}) {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => SnackbarService());
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => PlacesService());
  locator.registerLazySingleton(() => GeolocationService());
  locator.registerLazySingleton(() => EnvironmentService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => FirestoreApi());
  locator.registerLazySingleton(() => FirebaseAuthenticationService());
  locator.registerLazySingleton(() => FlavorConfigProvider());
  locator.registerLazySingleton(() => LayoutService());
  locator.registerLazySingleton(() => LocalStorageService());
  locator.registerLazySingleton(() => FlutterSecureStorage());
  locator.registerLazySingleton(() => TransfersHistoryService());
  locator.registerLazySingleton(() => QuestService());
  locator.registerLazySingleton(() => PaymentService());
  locator.registerLazySingleton(() => StopWatchService());
  locator.registerLazySingleton(() => QRCodeService());
  locator.registerLazySingleton(() => MarkerService());
  locator.registerLazySingleton(() => DirectionsAPI());
  locator.registerLazySingleton(() => GiftCardService());
}
