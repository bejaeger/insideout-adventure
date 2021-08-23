// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

<<<<<<< HEAD
=======
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:logger/logger.dart';
>>>>>>> 805d26ec802ef2954c63690f21a66a28d471ea78
import 'package:places_service/places_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

import '../apis/firestore_api.dart';
import '../flavor_config.dart';
import '../services/environment_services.dart';
import '../services/geolocation_service.dart';
import '../services/layout/layout_service.dart';
import '../services/local_storage_service.dart';
import '../services/payments/payment_service.dart';
import '../services/payments/transfers_history_service.dart';
import '../services/user_service.dart';

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
<<<<<<< HEAD
  //locator.registerLazySingleton(() => Position());
=======
>>>>>>> 805d26ec802ef2954c63690f21a66a28d471ea78
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => FirestoreApi());
  locator.registerLazySingleton(() => FirebaseAuthenticationService());
  locator.registerLazySingleton(() => FlavorConfigProvider());
<<<<<<< HEAD
=======
  locator.registerLazySingleton(() => FlutterSecureStorage());
  locator.registerLazySingleton(() => LocalStorageService());
  locator.registerLazySingleton(() => PaymentService());
  locator.registerLazySingleton(() => TransfersHistoryService());
  locator.registerLazySingleton(() => LayoutService());
>>>>>>> 805d26ec802ef2954c63690f21a66a28d471ea78
}
