import 'package:afkcredits/apis/cloud_functions_api.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/datamodels/dummy_data.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/datamodels/quests/markers/afk_marker.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/services/environment_services.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/giftcard/gift_card_service.dart';
import 'package:afkcredits/services/layout/layout_service.dart';
import 'package:afkcredits/services/local_storage_service.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/payments/transfers_history_service.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/users/afkcredits_authentication_result_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:firebase_auth/firebase_auth.dart' as firebase;
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app/app.locator.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:geolocator/geolocator.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:places_service/places_service.dart';
import 'package:rxdart/rxdart.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import '../test_data/test_constants.dart';
import '../test_data/test_datamodels.dart';
import 'mock_firebase_user.dart';
import 'test_helpers.mocks.dart';

final mockFirebaseUser = MockFirebaseUser();

@GenerateMocks([], customMocks: [
  // our services registered with get_it
  MockSpec<UserService>(returnNullOnMissingStub: true),
  MockSpec<FirestoreApi>(returnNullOnMissingStub: true),
  MockSpec<CloudFunctionsApi>(returnNullOnMissingStub: true),
  MockSpec<EnvironmentService>(returnNullOnMissingStub: true),
  MockSpec<PlacesService>(returnNullOnMissingStub: true),
  MockSpec<AppConfigProvider>(returnNullOnMissingStub: true),
  MockSpec<LocalStorageService>(returnNullOnMissingStub: true),
  MockSpec<FlutterSecureStorage>(returnNullOnMissingStub: true),
  MockSpec<LayoutService>(returnNullOnMissingStub: true),
  MockSpec<TransfersHistoryService>(returnNullOnMissingStub: true),
  MockSpec<GeolocationService>(returnNullOnMissingStub: true),
  MockSpec<QuestService>(returnNullOnMissingStub: true),
  MockSpec<StopWatchService>(returnNullOnMissingStub: true),
  MockSpec<MarkerService>(returnNullOnMissingStub: true),
  MockSpec<QRCodeService>(returnNullOnMissingStub: true),
  MockSpec<GiftCardService>(returnNullOnMissingStub: true),

  // stacked services registered with get_it
  MockSpec<NavigationService>(returnNullOnMissingStub: true),
  MockSpec<SnackbarService>(returnNullOnMissingStub: true),
  MockSpec<DialogService>(returnNullOnMissingStub: true),
  MockSpec<BottomSheetService>(returnNullOnMissingStub: true),

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
          stringPw: anyNamed("password")))
      .thenAnswer((_) async =>
          AFKCreditsAuthenticationResultService.fromLocalStorage(
              uid: kTestUid));

  when(service.runCreateAccountLogic(
          method: anyNamed("method"),
          role: anyNamed("role"),
          fullName: anyNamed("fullName"),
          email: anyNamed("email"),
          password: anyNamed("password")))
      .thenAnswer((_) async =>
          AFKCreditsAuthenticationResultService.fromLocalStorage(
              uid: kTestUid));
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
  when(service.pushFinishedQuest(quest: anyNamed("quest")))
      .thenAnswer((_) async => null);
  when(service.getUser(uid: anyNamed("uid")))
      .thenAnswer((realInvocation) async => user);
  when(service.getMarkerFromQrCodeId(qrCodeId: anyNamed("qrCodeId")))
      .thenAnswer((_) async => getTestMarker1());
  when(service.downloadQuestsWithStartMarkerId(
          startMarkerId: anyNamed("startMarkerId")))
      .thenAnswer((_) async => [getDummyQuest1()]);
  final userStats = getEmptyUserStatistics(uid: kTestUid);
  locator.registerSingleton<FirestoreApi>(service);
  return service;
}

MockCloudFunctionsApi getAndRegisterCloudFunctionsApi() {
  _removeRegistrationIfExists<CloudFunctionsApi>();
  final service = MockCloudFunctionsApi();
  when(service.bookkeepFinishedQuest(quest: anyNamed("quest")))
      .thenAnswer((_) async => Future.value());
  locator.registerSingleton<CloudFunctionsApi>(service);
  return service;
}

MockFlavorConfigProvider getAndRegisterFlavorConfigProvider() {
  _removeRegistrationIfExists<AppConfigProvider>();
  final service = MockFlavorConfigProvider();
  locator.registerSingleton<AppConfigProvider>(service);
  return service;
}

MockDialogService getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(service);
  return service;
}

MockBottomSheetService getAndRegisterBottomSheetService(
    {bool confirmed = false}) {
  _removeRegistrationIfExists<BottomSheetService>();
  final service = MockBottomSheetService();
  when(service.showBottomSheet(
          title: anyNamed("title"),
          confirmButtonTitle: anyNamed("confirmButtonTitle"),
          cancelButtonTitle: anyNamed("cancelButtonTitle")))
      .thenAnswer(
          (_) async => await Future.value(SheetResponse(confirmed: confirmed)));
  locator.registerSingleton<BottomSheetService>(service);
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

LayoutService getAndRegisterLayoutService() {
  _removeRegistrationIfExists<LayoutService>();
  final service = MockLayoutService();
  locator.registerSingleton<LayoutService>(service);
  return service;
}

SnackbarService getAndRegisterSnackBarService() {
  _removeRegistrationIfExists<SnackbarService>();
  final service = MockSnackbarService();
  locator.registerSingleton<SnackbarService>(service);
  return service;
}

TransfersHistoryService getAndRegisterTransfersHistoryService() {
  _removeRegistrationIfExists<TransfersHistoryService>();
  final service = MockTransfersHistoryService();
  locator.registerSingleton<TransfersHistoryService>(service);
  return service;
}

QuestService getAndRegisterQuestService() {
  _removeRegistrationIfExists<QuestService>();
  final service = MockQuestService();
  locator.registerSingleton<QuestService>(service);
  return service;
}

GeolocationService getAndRegisterGeolocationService(
    {Position? position, bool isCloseBy = true}) {
  _removeRegistrationIfExists<GeolocationService>();
  final service = MockGeolocationService();
  //when(service.getAndSetCurrentLocation()).thenAnswer((_) async => position);
  when(service.isUserCloseby(lat: anyNamed("lat"), lon: anyNamed("lon")))
      .thenAnswer((_) async => isCloseBy);
  locator.registerSingleton<GeolocationService>(service);
  return service;
}

MockStopWatchService getAndRegisterStopWatchService() {
  _removeRegistrationIfExists<StopWatchService>();
  final service = MockStopWatchService();
  locator.registerSingleton<StopWatchService>(service);
  return service;
}

MockMarkerService getAndRegisterMarkerService({bool isUserCloseby = true}) {
  _removeRegistrationIfExists<MarkerService>();
  final service = MockMarkerService();
  when(service.getQuestMarkers()).thenAnswer((_) async => [getDummyMarker1()]);
  when(service.isUserCloseby(marker: anyNamed("marker")))
      .thenAnswer((_) async => isUserCloseby);
  locator.registerSingleton<MarkerService>(service);
  return service;
}

MockQRCodeService getAndRegisterQRCodeService({AFKMarker? marker}) {
  _removeRegistrationIfExists<QRCodeService>();
  final service = MockQRCodeService();
  when(service.getMarkerFromQrCodeString(
          qrCodeString: anyNamed("qrCodeString")))
      .thenReturn(marker ?? getTestMarker1());
  locator.registerSingleton<QRCodeService>(service);
  return service;
}

MockGiftCardService getAndRegisterGiftCardService() {
  _removeRegistrationIfExists<GiftCardService>();
  final service = MockGiftCardService();
  locator.registerSingleton<GiftCardService>(service);
  return service;
}

void unregisterServices() {
  locator.unregister<UserService>();
  locator.unregister<NavigationService>();
  locator.unregister<FirestoreApi>();
  locator.unregister<CloudFunctionsApi>();
  locator.unregister<EnvironmentService>();
  locator.unregister<PlacesService>();
  locator.unregister<AppConfigProvider>();
  locator.unregister<FirebaseAuthenticationService>();
  locator.unregister<DialogService>();
  locator.unregister<BottomSheetService>();
  locator.unregister<LocalStorageService>();
  locator.unregister<FlutterSecureStorage>();
  locator.unregister<LayoutService>();
  locator.unregister<SnackbarService>();
  locator.unregister<TransfersHistoryService>();
  locator.unregister<QuestService>();
  locator.unregister<GeolocationService>();
  locator.unregister<StopWatchService>();
  locator.unregister<MarkerService>();
  locator.unregister<QRCodeService>();
  locator.unregister<GiftCardService>();
}

void registerServices() {
  getAndRegisterUserService();
  getAndRegisterEnvironmentService();
  getAndRegisterNavigationService();
  getAndRegisterFirestoreApi();
  getAndRegisterCloudFunctionsApi();
  getAndRegisterFirebaseAuthenticationService();
  getAndRegisterPlacesService();
  getAndRegisterFlavorConfigProvider();
  getAndRegisterDialogService();
  getAndRegisterBottomSheetService();
  getAndRegisterLocalStorageService();
  getAndRegisterFlutterSecureStorage();
  getAndRegisterLayoutService();
  getAndRegisterSnackBarService();
  getAndRegisterTransfersHistoryService();
  getAndRegisterQuestService();
  getAndRegisterGeolocationService();
  getAndRegisterStopWatchService();
  getAndRegisterMarkerService();
  getAndRegisterQRCodeService();
  getAndRegisterGiftCardService();
}

void _removeRegistrationIfExists<T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}
