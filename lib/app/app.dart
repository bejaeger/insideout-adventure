import 'package:afkcredits/apis/firestore_api.dart';
import 'package:afkcredits/flavor_config.dart';
import 'package:afkcredits/services/environment_services.dart';
import 'package:afkcredits/services/geolocation/geolocation_service.dart';
import 'package:afkcredits/services/layout/layout_service.dart';
import 'package:afkcredits/services/local_storage_service.dart';
import 'package:afkcredits/services/payments/payment_service.dart';
import 'package:afkcredits/services/payments/transfers_history_service.dart';
import 'package:afkcredits/services/quests/quest_service.dart';
import 'package:afkcredits/services/user_service.dart';
import 'package:afkcredits/ui/views/add_explorer/add_explorer_view.dart';
import 'package:afkcredits/ui/views/admin/admin_home_view.dart';
import 'package:afkcredits/ui/views/create_account/create_account_view.dart';
import 'package:afkcredits/ui/views/create_account/create_account_user_role_view.dart';
import 'package:afkcredits/ui/views/explorer_home/explorer_home_view.dart';
import 'package:afkcredits/ui/views/layout/layout_template_view.dart';
import 'package:afkcredits/ui/views/login/login_view.dart';
import 'package:afkcredits/ui/views/login/select_role_after_login_view.dart';
import 'package:afkcredits/ui/views/map/map_view.dart';
import 'package:afkcredits/ui/views/search_explorer/search_explorer_view.dart';
import 'package:afkcredits/ui/views/single_explorer/single_explorer_view.dart';
import 'package:afkcredits/ui/views/sponsor_home/sponsor_home_view.dart';
import 'package:afkcredits/ui/views/startup/startup_view.dart';
import 'package:afkcredits/ui/views/transaction_history/transfers_history_view.dart';
import 'package:afkcredits/ui/views/transfer_funds/transfer_funds_view.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:places_service/places_service.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_firebase_auth/stacked_firebase_auth.dart';
import 'package:stacked_services/stacked_services.dart';

@StackedApp(
  routes: [
    MaterialRoute(page: SponsorHomeView),
    MaterialRoute(page: ExplorerHomeView),
    MaterialRoute(page: MapView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: CreateAccountView),
    MaterialRoute(page: CreateAccountUserRoleView),
    MaterialRoute(page: StartUpView, initial: true),
    MaterialRoute(page: AdminHomeView),
    MaterialRoute(page: SelectRoleAfterLoginView),
    MaterialRoute(page: AddExplorerView),
    MaterialRoute(page: SearchExplorerView),
    MaterialRoute(page: SingleExplorerView),
    MaterialRoute(page: TransferFundsView),
    MaterialRoute(page: TransfersHistoryView),
    MaterialRoute(page: LayoutTemplateView),
  ],
  dependencies: [
    LazySingleton(classType: NavigationService),
    LazySingleton(classType: DialogService),
    LazySingleton(classType: SnackbarService),
    LazySingleton(classType: BottomSheetService),
    LazySingleton(classType: PlacesService),
    LazySingleton(classType: GeolocationService),
    LazySingleton(classType: EnvironmentService),
    LazySingleton(classType: UserService),
    LazySingleton(classType: FirestoreApi),
    LazySingleton(classType: FirebaseAuthenticationService),
    LazySingleton(classType: FlavorConfigProvider),
    LazySingleton(classType: LayoutService),
    LazySingleton(classType: LocalStorageService),
    LazySingleton(classType: FlutterSecureStorage),
    LazySingleton(classType: TransfersHistoryService),
    LazySingleton(classType: QuestService),
    LazySingleton(classType: PaymentService),

    // Services
  ],
  logger: StackedLogger(),
)
class AppSetup {
  /** Serves no purpose besides having an annotation attached to it */
}
