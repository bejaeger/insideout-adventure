import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/datamodels/users/user_statistics.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/flavor_config.dart';
import 'package:afkcredits/services/environment_services.dart';
import 'package:afkcredits/services/local_storage_service.dart';
import 'package:afkcredits/services/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:places_service/places_service.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

import 'datamodel_helpers.dart';
import 'mock_firebase_user.dart';
import 'test_helpers.mocks.dart';

final mockFirebaseUser = MockFirebaseUser();

@GenerateMocks([], customMocks: [
  // our services registered with get_it
  MockSpec<UserService>(returnNullOnMissingStub: true),
  MockSpec<FirestoreApi>(returnNullOnMissingStub: true),
  MockSpec<EnvironmentService>(returnNullOnMissingStub: true),
  MockSpec<PlacesService>(returnNullOnMissingStub: true),
  MockSpec<FlavorConfigProvider>(returnNullOnMissingStub: true),
  MockSpec<LocalStorageService>(returnNullOnMissingStub: true),
  MockSpec<FlutterSecureStorage>(returnNullOnMissingStub: true),

  // stacked services registered with get_it
  MockSpec<NavigationService>(returnNullOnMissingStub: true),
  MockSpec<DialogService>(returnNullOnMissingStub: true),
  MockSpec<FirebaseAuthenticationService>(returnNullOnMissingStub: true),
])
MockUserService getAndRegisterUserService({
  bool hasLoggedInUser = false,
  String? localUserId,
  User? currentUser,
  bool newUser = false,
}) {
  _removeRegistrationIfExists<UserService>();
  final service = MockUserService();
  when(service.hasLoggedInUser).thenReturn(hasLoggedInUser);
  when(service.currentUser).thenReturn(currentUser ?? getTestUserExplorer());
  when(service.getLocallyLoggedInUserId()).thenAnswer((_) async => localUserId);
  when(service.currentUserNullable)
      .thenReturn(newUser ? null : getTestUserExplorer());
  when(service.runLoginLogic(
          method: anyNamed("method"),
          emailOrName: anyNamed("emailOrName"),
          password: anyNamed("password")))
      .thenAnswer((_) async =>
          AFKCreditsAuthenticationResult.fromLocalStorage(uid: kTestUid));
  when(service.runCreateAccountLogic(
          method: anyNamed("method"),
          role: anyNamed("role"),
          fullName: anyNamed("fullName"),
          email: anyNamed("email"),
          password: anyNamed("password")))
      .thenAnswer((_) async =>
          AFKCreditsAuthenticationResult.fromLocalStorage(uid: kTestUid));
  locator.registerSingleton<UserService>(service);
  return service;
}

MockEnvironmentService getAndRegisterEnvironmentService({
  String value = NoKey,
}) {
  _removeRegistrationIfExists<EnvironmentService>();
  final service = MockEnvironmentService();

  when(service.initialise()).thenAnswer((realInvocation) => Future.value());
  when(service.getValue(any)).thenReturn(value);

  locator.registerSingleton<EnvironmentService>(service);
  return service;
}

MockPlacesService getAndRegisterPlacesService({PlacesDetails? placesDetails}) {
  _removeRegistrationIfExists<PlacesService>();
  final service = MockPlacesService();

  when(service.getPlaceDetails(any))
      .thenAnswer((realInvocation) => Future<PlacesDetails>.value(
            placesDetails ??
                PlacesDetails(
                  placeId: 'TestId',
                  city: 'Test City',
                ),
          ));

  locator.registerSingleton<PlacesService>(service);
  return service;
}

MockNavigationService getAndRegisterNavigationService() {
  _removeRegistrationIfExists<NavigationService>();
  final service = MockNavigationService();
  locator.registerSingleton<NavigationService>(service);
  return service;
}

MockFirebaseAuthenticationService getAndRegisterFirebaseAuthenticationService({
  firebase.User? currentUser,
}) {
  _removeRegistrationIfExists<FirebaseAuthenticationService>();
  final service = MockFirebaseAuthenticationService();
  when(service.authStateChanges).thenAnswer((_) => Stream.value(currentUser));
  when(service.logout()).thenAnswer((_) async => null);
  locator.registerSingleton<FirebaseAuthenticationService>(service);
  return service;
}

MockFirestoreApi getAndRegisterFirestoreApi({User? user}) {
  _removeRegistrationIfExists<FirestoreApi>();
  final service = MockFirestoreApi();
  when(service.getUser(uid: anyNamed("uid")))
      .thenAnswer((realInvocation) async => user);
  final userStats = getEmptyUserStatistics(uid: kTestUid);
  locator.registerSingleton<FirestoreApi>(service);
  return service;
}

MockFlavorConfigProvider getAndRegisterFlavorConfigProvider() {
  _removeRegistrationIfExists<FlavorConfigProvider>();
  final service = MockFlavorConfigProvider();
  locator.registerSingleton<FlavorConfigProvider>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockLocalStorageService getAndRegisterLocalStorageService() {
  _removeRegistrationIfExists<LocalStorageService>();
  final service = MockLocalStorageService();
  when(service.saveToDisk(key: anyNamed("key"), value: anyNamed("value")))
      .thenAnswer((_) async => Future.value());
  locator.registerSingleton<LocalStorageService>(service);
  return service;
}

FlutterSecureStorage getAndRegisterFlutterSecureStorage() {
  _removeRegistrationIfExists<FlutterSecureStorage>();
  final service = MockFlutterSecureStorage();
  locator.registerSingleton<FlutterSecureStorage>(service);
  return service;
}

void registerServices() {
  getAndRegisterUserService();
  getAndRegisterEnvironmentService();
  getAndRegisterNavigationService();
  getAndRegisterFirestoreApi();
  getAndRegisterFirebaseAuthenticationService();
  getAndRegisterPlacesService();
  getAndRegisterFlavorConfigProvider();
  getAndRegisterDialogService();
  getAndRegisterLocalStorageService();
  getAndRegisterFlutterSecureStorage();
}

void unregisterServices() {
  locator.unregister<UserService>();
  locator.unregister<NavigationService>();
  locator.unregister<FirestoreApi>();
  locator.unregister<EnvironmentService>();
  locator.unregister<PlacesService>();
  locator.unregister<FlavorConfigProvider>();
  locator.unregister<FirebaseAuthenticationService>();
  locator.unregister<DialogService>();
  locator.unregister<LocalStorageService>();
  locator.unregister<FlutterSecureStorage>();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
