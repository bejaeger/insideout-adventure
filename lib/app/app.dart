import 'package:afkcredits/apis/cloud_functions_api.dart';
import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/notifications/notifications_service.dart';
import 'package:afkcredits/services/cloud_storage_service.dart/cloud_storage_service.dart';
import 'package:afkcredits/services/connectivity/connectivity_service.dart';
import 'package:afkcredits/services/email_service/email_service.dart';
import 'package:afkcredits/services/environment_services.dart';
import 'package:afkcredits/services/feedback_service/feedback_service.dart';
import 'package:afkcredits/services/gamification/gamification_service.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/layout/layout_service.dart';
import 'package:afkcredits/services/local_secure_storage_service.dart';
import 'package:afkcredits/services/local_storage_service/local_storage_service.dart';
import 'package:afkcredits/services/maps/google_map_service.dart';
import 'package:afkcredits/services/maps/map_state_service.dart';
import 'package:afkcredits/services/markers/marker_service.dart';
import 'package:afkcredits/apis/notion_api.dart';
import 'package:afkcredits/services/permission_service.dart';
import 'package:afkcredits/services/quest_testing_service/quest_testing_service.dart';
import 'package:afkcredits/services/quests/active_quest_service.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/quests/stopwatch_service.dart';
import 'package:afkcredits/services/screentime/screen_time_service.dart';
import 'package:afkcredits/services/users/user_service.dart';
import 'package:afkcredits/ui/views/active_screen_time/active_screen_time_view.dart';
import 'package:afkcredits/ui/views/active_screen_time/screen_time_requested_view.dart';
import 'package:afkcredits/ui/views/active_screen_time/start_screen_time_counter_view.dart';
import 'package:afkcredits/ui/views/create_explorer/create_explorer_view.dart';
import 'package:afkcredits/ui/views/ar_view/ar_object_ios_view.dart';
import 'package:afkcredits/ui/views/create_account/create_account_view.dart';
import 'package:afkcredits/ui/views/create_account/create_account_user_role_view.dart';
import 'package:afkcredits/ui/views/explorer_home/explorer_home_view.dart';
import 'package:afkcredits/ui/views/explorer_home/explorer_home_viewmodel.dart';
import 'package:afkcredits/ui/views/feedback_view/feedback_view.dart';
import 'package:afkcredits/ui/views/help_desk/hep_desk_view.dart';
import 'package:afkcredits/ui/views/login/login_view.dart';
import 'package:afkcredits/ui/views/login/select_role_after_login_view.dart';
import 'package:afkcredits/ui/views/map/map_viewmodel.dart';
import 'package:afkcredits/ui/views/onboarding_screens/onboarding_screens_view.dart';
import 'package:afkcredits/ui/views/parent_home/parent_home_view.dart';
import 'package:afkcredits/ui/views/parent_home/parent_home_viewmodel.dart';
import 'package:afkcredits/ui/views/parent_map/parent_map_view.dart';
import 'package:afkcredits/ui/views/permissions/permissions_view.dart';
import 'package:afkcredits/ui/views/quests_overview/create_quest/create_quest_view.dart';
import 'package:afkcredits/ui/views/screen_time/select_screen_time_view.dart';
import 'package:afkcredits/ui/views/set_pin/set_pin_view.dart';
import 'package:afkcredits/ui/views/single_child_stat/single_child_stat_view.dart';
import 'package:afkcredits/ui/views/startup/startup_screen_time_view.dart';
import 'package:afkcredits/ui/views/startup/startup_view.dart';
import 'package:afkcredits/ui/views/transfer_funds/transfer_funds_view.dart';
import 'package:afkcredits/utils/image_selector.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';
import '../ui/views/ar_view/ar_object_android_view.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: ParentHomeView),
    MaterialRoute(page: ExplorerHomeView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: CreateAccountView),
    MaterialRoute(page: CreateAccountUserRoleView),
    MaterialRoute(page: StartUpView, initial: true),
    MaterialRoute(page: StartUpScreenTimeView),
    MaterialRoute(page: SelectRoleAfterLoginView),
    MaterialRoute(page: CreateExplorerView),
    MaterialRoute(page: SingleChildStatView),
    MaterialRoute(page: TransferFundsView),
    MaterialRoute(page: SetPinView),
    MaterialRoute(page: CreateQuestView),
    MaterialRoute(page: ARObjectAndroidView),
    MaterialRoute(page: ARObjectIosView),
    MaterialRoute(page: ActiveScreenTimeView),
    MaterialRoute(page: SelectScreenTimeView),
    MaterialRoute(page: OnBoardingScreensView),
    MaterialRoute(page: ParentMapView),
    MaterialRoute(page: FeedbackView),
    MaterialRoute(page: PermissionsView),
    MaterialRoute(page: StartScreenTimeCounterView),
    MaterialRoute(page: ScreenTimeRequestedView),
    MaterialRoute(page: HelpDeskView),
  ],
  dependencies: [
    LazySingleton(classType: CloudFunctionsApi),
    LazySingleton(classType: EmailService),
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: ConnectivityService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: GeolocationService),
    LazySingleton(classType: EnvironmentService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: FirestoreApi),
    LazySingleton(classType: FirebaseAuthenticationService),
    LazySingleton(classType: AppConfigProvider),
    LazySingleton(classType: LayoutService),
    LazySingleton(classType: LocalSecureStorageService),
    LazySingleton(classType: FlutterSecureStorage),
    LazySingleton(classType: QuestService),
    LazySingleton(classType: ActiveQuestService),
    LazySingleton(classType: StopWatchService),
    LazySingleton(classType: MarkerService),
    LazySingleton(classType: QuestTestingService),
    LazySingleton(classType: GamificationService),
    LazySingleton(classType: MapStateService),
    LazySingleton(classType: CloudStorageService),
    LazySingleton(classType: ImageSelector),
    LazySingleton(classType: NotionApi),
    LazySingleton(classType: FeedbackService),
    LazySingleton(classType: ScreenTimeService),
    LazySingleton(classType: PermissionService),
    LazySingleton(classType: NotificationsService),
    LazySingleton(classType: ParentHomeViewModel),
    LazySingleton(classType: ExplorerHomeViewModel),
    LazySingleton(classType: LocalStorageService),
    Presolve(classType: MapViewModel, presolveUsing: presolveMapViewModel),
    LazySingleton(classType: GoogleMapService),
  ],
  logger: StackedLogger(),
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}
