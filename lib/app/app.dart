import 'package:afkcredits/apis/cloud_functions_api.dart';
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/services/cloud_firestore_storage/cloud_storage_services.dart';
import 'package:afkcredits/services/connectivity/connectivity_service.dart';
import 'package:afkcredits/services/environment_services.dart';
import 'package:afkcredits/services/gamification/gamification_service.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/giftcard/gift_card_service.dart';
import 'package:afkcredits/services/layout/layout_service.dart';
import 'package:afkcredits/services/local_storage_service.dart';
import 'package:afkcredits/services/maps/google_map_service.dart';
import 'package:afkcredits/services/maps/map_state_service.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/services/payments/payment_service.dart';
import 'package:afkcredits/services/payments/transfers_history_service.dart';
import 'package:afkcredits/services/pedometer/pedometer_service.dart';
import 'package:afkcredits/services/qrcodes/qrcode_service.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/services/quests/active_quest_service.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/ui/views/active_map_quest/active_map_quest_view.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_distance_estimate_quest/active_distance_estimate_quest_view.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_qrcode_search/active_qrcode_search_view.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_treasure_location_search_quest/active_treasure_location_search_quest_view.dart';
import 'package:afkcredits/ui/views/active_screen_time/active_screen_time_view.dart';
import 'package:afkcredits/ui/views/add_explorer/add_explorer_view.dart';
import 'package:afkcredits/ui/views/admin/admin_home_view.dart';
import 'package:afkcredits/ui/views/admin/admin_user/home/home_view.dart';
import 'package:afkcredits/ui/views/admin/admin_user/markers/add_markers/add_markers_view.dart';
import 'package:afkcredits/ui/views/ar_view/ar_object_view.dart';
import 'package:afkcredits/ui/views/create_account/create_account_view.dart';
import 'package:afkcredits/ui/views/create_account/create_account_user_role_view.dart';
import 'package:afkcredits/ui/views/explorer_home/explorer_home_view.dart';
import 'package:afkcredits/ui/views/gift_cards/gift_card_view.dart';
import 'package:afkcredits/ui/views/history_and_achievements/history_and_achievements_view.dart';
import 'package:afkcredits/ui/views/layout/bottom_bar_layout_view.dart';
import 'package:afkcredits/ui/views/layout/custom_bottom_bar_layout_template_view.dart';
import 'package:afkcredits/ui/views/login/login_view.dart';
import 'package:afkcredits/ui/views/login/select_role_after_login_view.dart';
import 'package:afkcredits/ui/views/map/map_overview_view.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:afkcredits/ui/views/parent_home/parent_home_view.dart';
import 'package:afkcredits/ui/views/purchased_gift_cards/insert/insert_pre_purchased_gift_card_view.dart';
import 'package:afkcredits/ui/views/purchased_gift_cards/manage_gift_cards/add_gift_cards/add_gift_cards_view.dart';
import 'package:afkcredits/ui/views/purchased_gift_cards/manage_gift_cards/manage_gift_cards_view.dart';
import 'package:afkcredits/ui/views/purchased_gift_cards/purchased_gift_cards_view.dart';
import 'package:afkcredits/ui/views/purchased_gift_cards/purchased_gift_cards_viewmodel.dart';
import 'package:afkcredits/ui/views/purchased_screen_time/purchased_screen_time_view.dart';
import 'package:afkcredits/ui/views/qrcode/qrcode_view_example.dart';
import 'package:afkcredits/ui/views/qrcode/qrcode_view.dart';
import 'package:afkcredits/ui/views/quests_overview/create_quest/create_quest_view.dart';
import 'package:afkcredits/ui/views/quests_overview/edit_quest/edit_quest_view.dart';
import 'package:afkcredits/ui/views/quests_overview/manage_quest/manage_quest_view.dart';
import 'package:afkcredits/ui/views/quests_overview/quests_overview_view.dart';
import 'package:afkcredits/ui/views/screen_time/screen_time_view.dart';
import 'package:afkcredits/ui/views/search_explorer/search_explorer_view.dart';
import 'package:afkcredits/ui/views/select_screen_time_view/select_screen_time_view.dart';
import 'package:afkcredits/ui/views/set_pin/set_pin_view.dart';
import 'package:afkcredits/ui/views/single_child_stat/single_child_stat_view.dart';
import 'package:afkcredits/ui/views/single_quest_type/single_quest_type_view.dart';
import 'package:afkcredits/ui/views/startup/startup_view.dart';
import 'package:afkcredits/ui/views/transaction_history/transfers_history_view.dart';
import 'package:afkcredits/ui/views/transfer_funds/transfer_funds_view.dart';
import 'package:afkcredits/utils/cloud_storage_result/cloud_storage_result.dart';
import 'package:afkcredits/utils/image_selector/image_selector.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:google_maps_flutter_web/google_maps_flutter_web.dart';
import 'package:pedometer/pedometer.dart';
import 'package:places_service/places_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

import '../ui/views/admin/admin_user/markers/single/single_marker_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: ParentHomeView),
    MaterialRoute(page: SingleMarkerView),
    MaterialRoute(page: InsertPrePurchasedGiftCardView),
    MaterialRoute(page: UpdatingQuestView),
    MaterialRoute(page: ExplorerHomeView),
    MaterialRoute(page: MapOverviewView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: CreateAccountView),
    MaterialRoute(page: CreateAccountUserRoleView),
    MaterialRoute(page: StartUpView, initial: true),
    MaterialRoute(page: HomeView),
    MaterialRoute(page: AdminHomeView),
    MaterialRoute(page: SelectRoleAfterLoginView),
    MaterialRoute(page: AddExplorerView),
    MaterialRoute(page: SearchExplorerView),
    MaterialRoute(page: SingleChildStatView),
    MaterialRoute(page: TransferFundsView),
    MaterialRoute(page: TransfersHistoryView),
    MaterialRoute(page: CustomBottomBarLayoutTemplateView),
    MaterialRoute(page: QRCodeView),
    MaterialRoute(page: QRCodeViewExample),
    MaterialRoute(page: GiftCardView),
    MaterialRoute(page: PurchasedGiftCardsView),
    MaterialRoute(page: AddMarkersView),
    MaterialRoute(page: SetPinView),
    MaterialRoute(page: BottomBarLayoutTemplateView),
    MaterialRoute(page: ActiveQrCodeSearchView),
    MaterialRoute(page: ActiveDistanceEstimateQuestView),
    MaterialRoute(page: ActiveTreasureLocationSearchQuestView),
    MaterialRoute(page: ActiveMapQuestView),
    MaterialRoute(page: CreateQuestView),
    MaterialRoute(page: ManageQuestView),
    MaterialRoute(page: ManageGiftCardstView),
    MaterialRoute(page: QuestsOverviewView),
    MaterialRoute(page: AddGiftCardsView),
    MaterialRoute(page: HistoryAndAchievementsView),
    MaterialRoute(page: PurchasedScreenTimeView),
    MaterialRoute(page: ScreenTimeView),
    MaterialRoute(page: ARObjectView),
    MaterialRoute(page: SelectScreenTimeView),
    MaterialRoute(page: ActiveScreenTimeView),
    MaterialRoute(page: SingleQuestTypeView),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: CloudStorageService),
    LazySingleton(classType: CloudStorageResult),
    LazySingleton(classType: ImageSelector),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: ConnectivityService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: PlacesService),
    LazySingleton(classType: GeolocationService),
    LazySingleton(classType: EnvironmentService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: FirestoreApi),
    LazySingleton(classType: CloudFunctionsApi),
    LazySingleton(classType: FirebaseAuthenticationService),
    LazySingleton(classType: AppConfigProvider),
    LazySingleton(classType: LayoutService),
    LazySingleton(classType: LocalStorageService),
    LazySingleton(classType: FlutterSecureStorage),
    LazySingleton(classType: TransfersHistoryService),
    LazySingleton(classType: QuestService),
    LazySingleton(classType: ActiveQuestService),
    // LazySingleton(classType: AFKCreditsAuthenticationResultService),
    LazySingleton(classType: PaymentService),
    LazySingleton(classType: StopWatchService),
    LazySingleton(classType: QRCodeService),
    LazySingleton(classType: MarkerService),
    LazySingleton(classType: GiftCardService),
    LazySingleton(classType: ScreenTimeService),
    LazySingleton(classType: QuestTestingService),
    LazySingleton(classType: GamificationService),
    LazySingleton(classType: MapStateService),
    LazySingleton(classType: PedometerService),

    //LazySingleton(classType: MarkersInMap),
    // LazySingleton(classType: MapViewModel),
    Presolve(classType: MapViewModel, presolveUsing: presolveMapViewModel),

    // Just a test if this helps reducing/removing the
    // map failures
    LazySingleton(classType: GoogleMapService),

    // Services
  ],
  logger: StackedLogger(),
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}
