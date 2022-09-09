// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, unused_import, non_constant_identifier_names

import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

import '../datamodels/quests/quest.dart';
import '../datamodels/screentime/screen_time_session.dart';
import '../datamodels/users/public_info/public_user_info.dart';
import '../enums/authentication_method.dart';
import '../enums/bottom_nav_bar_index.dart';
import '../enums/quest_view_index.dart';
import '../enums/transfer_type.dart';
import '../enums/user_role.dart';
import '../ui/views/active_quest_standalone_ui/active_distance_estimate_quest/active_distance_estimate_quest_view.dart';
import '../ui/views/active_quest_standalone_ui/active_qrcode_search/active_qrcode_search_view.dart';
import '../ui/views/active_quest_standalone_ui/active_treasure_location_search_quest/active_treasure_location_search_quest_view.dart';
import '../ui/views/active_screen_time/active_screen_time_view.dart';
import '../ui/views/add_explorer/add_explorer_view.dart';
import '../ui/views/admin/admin_home_view.dart';
import '../ui/views/admin/admin_user/home/home_view.dart';
import '../ui/views/admin/admin_user/markers/add_markers/add_markers_view.dart';
import '../ui/views/admin/admin_user/markers/single/single_marker_view.dart';
import '../ui/views/ar_view/ar_object_view.dart';
import '../ui/views/create_account/create_account_user_role_view.dart';
import '../ui/views/create_account/create_account_view.dart';
import '../ui/views/explorer_home/explorer_home_view.dart';
import '../ui/views/history_and_achievements/history_and_achievements_view.dart';
import '../ui/views/layout/bottom_bar_layout_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/login/select_role_after_login_view.dart';
import '../ui/views/map/map_overview_view.dart';
import '../ui/views/onboarding_screens/onboarding_screens_view.dart';
import '../ui/views/parent_home/parent_home_view.dart';
import '../ui/views/parent_map/parent_map_view.dart';
import '../ui/views/qrcode/qrcode_view.dart';
import '../ui/views/qrcode/qrcode_view_example.dart';
import '../ui/views/quests_overview/create_quest/create_quest_view.dart';
import '../ui/views/quests_overview/edit_quest/edit_quest_view.dart';
import '../ui/views/quests_overview/manage_quest/manage_quest_view.dart';
import '../ui/views/quests_overview/quests_overview_view.dart';
import '../ui/views/screen_time/select_screen_time_view.dart';
import '../ui/views/search_explorer/search_explorer_view.dart';
import '../ui/views/set_pin/set_pin_view.dart';
import '../ui/views/single_child_stat/single_child_stat_view.dart';
import '../ui/views/single_quest_type/single_quest_type_view.dart';
import '../ui/views/startup/startup_view.dart';
import '../ui/views/transfer_funds/transfer_funds_view.dart';

class Routes {
  static const String parentHomeView = '/parent-home-view';
  static const String singleMarkerView = '/single-marker-view';
  static const String updatingQuestView = '/updating-quest-view';
  static const String explorerHomeView = '/explorer-home-view';
  static const String mapOverviewView = '/map-overview-view';
  static const String loginView = '/login-view';
  static const String createAccountView = '/create-account-view';
  static const String createAccountUserRoleView =
      '/create-account-user-role-view';
  static const String startUpView = '/';
  static const String homeView = '/home-view';
  static const String adminHomeView = '/admin-home-view';
  static const String selectRoleAfterLoginView =
      '/select-role-after-login-view';
  static const String addExplorerView = '/add-explorer-view';
  static const String searchExplorerView = '/search-explorer-view';
  static const String singleChildStatView = '/single-child-stat-view';
  static const String transferFundsView = '/transfer-funds-view';
  static const String qRCodeView = '/q-rcode-view';
  static const String qRCodeViewExample = '/q-rcode-view-example';
  static const String addMarkersView = '/add-markers-view';
  static const String setPinView = '/set-pin-view';
  static const String bottomBarLayoutTemplateView =
      '/bottom-bar-layout-template-view';
  static const String activeQrCodeSearchView = '/active-qr-code-search-view';
  static const String activeDistanceEstimateQuestView =
      '/active-distance-estimate-quest-view';
  static const String activeTreasureLocationSearchQuestView =
      '/active-treasure-location-search-quest-view';
  static const String createQuestView = '/create-quest-view';
  static const String manageQuestView = '/manage-quest-view';
  static const String questsOverviewView = '/quests-overview-view';
  static const String historyAndAchievementsView =
      '/history-and-achievements-view';
  static const String aRObjectView = '/a-robject-view';
  static const String activeScreenTimeView = '/active-screen-time-view';
  static const String selectScreenTimeView = '/select-screen-time-view';
  static const String singleQuestTypeView = '/single-quest-type-view';
  static const String onBoardingScreensView = '/on-boarding-screens-view';
  static const String parentMapView = '/parent-map-view';
  static const all = <String>{
    parentHomeView,
    singleMarkerView,
    updatingQuestView,
    explorerHomeView,
    mapOverviewView,
    loginView,
    createAccountView,
    createAccountUserRoleView,
    startUpView,
    homeView,
    adminHomeView,
    selectRoleAfterLoginView,
    addExplorerView,
    searchExplorerView,
    singleChildStatView,
    transferFundsView,
    qRCodeView,
    qRCodeViewExample,
    addMarkersView,
    setPinView,
    bottomBarLayoutTemplateView,
    activeQrCodeSearchView,
    activeDistanceEstimateQuestView,
    activeTreasureLocationSearchQuestView,
    createQuestView,
    manageQuestView,
    questsOverviewView,
    historyAndAchievementsView,
    aRObjectView,
    activeScreenTimeView,
    selectScreenTimeView,
    singleQuestTypeView,
    onBoardingScreensView,
    parentMapView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.parentHomeView, page: ParentHomeView),
    RouteDef(Routes.singleMarkerView, page: SingleMarkerView),
    RouteDef(Routes.updatingQuestView, page: UpdatingQuestView),
    RouteDef(Routes.explorerHomeView, page: ExplorerHomeView),
    RouteDef(Routes.mapOverviewView, page: MapOverviewView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.createAccountView, page: CreateAccountView),
    RouteDef(Routes.createAccountUserRoleView, page: CreateAccountUserRoleView),
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.homeView, page: HomeView),
    RouteDef(Routes.adminHomeView, page: AdminHomeView),
    RouteDef(Routes.selectRoleAfterLoginView, page: SelectRoleAfterLoginView),
    RouteDef(Routes.addExplorerView, page: AddExplorerView),
    RouteDef(Routes.searchExplorerView, page: SearchExplorerView),
    RouteDef(Routes.singleChildStatView, page: SingleChildStatView),
    RouteDef(Routes.transferFundsView, page: TransferFundsView),
    RouteDef(Routes.qRCodeView, page: QRCodeView),
    RouteDef(Routes.qRCodeViewExample, page: QRCodeViewExample),
    RouteDef(Routes.addMarkersView, page: AddMarkersView),
    RouteDef(Routes.setPinView, page: SetPinView),
    RouteDef(Routes.bottomBarLayoutTemplateView,
        page: BottomBarLayoutTemplateView),
    RouteDef(Routes.activeQrCodeSearchView, page: ActiveQrCodeSearchView),
    RouteDef(Routes.activeDistanceEstimateQuestView,
        page: ActiveDistanceEstimateQuestView),
    RouteDef(Routes.activeTreasureLocationSearchQuestView,
        page: ActiveTreasureLocationSearchQuestView),
    RouteDef(Routes.createQuestView, page: CreateQuestView),
    RouteDef(Routes.manageQuestView, page: ManageQuestView),
    RouteDef(Routes.questsOverviewView, page: QuestsOverviewView),
    RouteDef(Routes.historyAndAchievementsView,
        page: HistoryAndAchievementsView),
    RouteDef(Routes.aRObjectView, page: ARObjectView),
    RouteDef(Routes.activeScreenTimeView, page: ActiveScreenTimeView),
    RouteDef(Routes.selectScreenTimeView, page: SelectScreenTimeView),
    RouteDef(Routes.singleQuestTypeView, page: SingleQuestTypeView),
    RouteDef(Routes.onBoardingScreensView, page: OnBoardingScreensView),
    RouteDef(Routes.parentMapView, page: ParentMapView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    ParentHomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ParentHomeView(),
        settings: data,
      );
    },
    SingleMarkerView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => SingleMarkerView(),
        settings: data,
      );
    },
    UpdatingQuestView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const UpdatingQuestView(),
        settings: data,
      );
    },
    ExplorerHomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ExplorerHomeView(),
        settings: data,
      );
    },
    MapOverviewView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const MapOverviewView(),
        settings: data,
      );
    },
    LoginView: (data) {
      var args = data.getArgs<LoginViewArguments>(
        orElse: () => LoginViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => LoginView(key: args.key),
        settings: data,
      );
    },
    CreateAccountView: (data) {
      var args = data.getArgs<CreateAccountViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => CreateAccountView(
          key: args.key,
          role: args.role,
        ),
        settings: data,
      );
    },
    CreateAccountUserRoleView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const CreateAccountUserRoleView(),
        settings: data,
      );
    },
    StartUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const StartUpView(),
        settings: data,
      );
    },
    HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const HomeView(),
        settings: data,
      );
    },
    AdminHomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AdminHomeView(),
        settings: data,
      );
    },
    SelectRoleAfterLoginView: (data) {
      var args = data.getArgs<SelectRoleAfterLoginViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => SelectRoleAfterLoginView(
          key: args.key,
          authMethod: args.authMethod,
        ),
        settings: data,
      );
    },
    AddExplorerView: (data) {
      var args = data.getArgs<AddExplorerViewArguments>(
        orElse: () => AddExplorerViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => AddExplorerView(key: args.key),
        settings: data,
      );
    },
    SearchExplorerView: (data) {
      var args = data.getArgs<SearchExplorerViewArguments>(
        orElse: () => SearchExplorerViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => SearchExplorerView(key: args.key),
        settings: data,
      );
    },
    SingleChildStatView: (data) {
      var args = data.getArgs<SingleChildStatViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => SingleChildStatView(
          key: args.key,
          uid: args.uid,
        ),
        settings: data,
      );
    },
    TransferFundsView: (data) {
      var args = data.getArgs<TransferFundsViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => TransferFundsView(
          key: args.key,
          type: args.type,
          senderInfo: args.senderInfo,
          recipientInfo: args.recipientInfo,
        ),
        settings: data,
      );
    },
    QRCodeView: (data) {
      var args = data.getArgs<QRCodeViewArguments>(
        orElse: () => QRCodeViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => QRCodeView(
          key: args.key,
          qrCodeString: args.qrCodeString,
        ),
        settings: data,
      );
    },
    QRCodeViewExample: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => QRCodeViewExample(),
        settings: data,
      );
    },
    AddMarkersView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => AddMarkersView(),
        settings: data,
      );
    },
    SetPinView: (data) {
      var args = data.getArgs<SetPinViewArguments>(
        orElse: () => SetPinViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => SetPinView(key: args.key),
        settings: data,
      );
    },
    BottomBarLayoutTemplateView: (data) {
      var args =
          data.getArgs<BottomBarLayoutTemplateViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => BottomBarLayoutTemplateView(
          key: args.key,
          userRole: args.userRole,
          initialBottomNavBarIndex: args.initialBottomNavBarIndex,
          showDialog: args.showDialog,
          questViewIndex: args.questViewIndex,
          quest: args.quest,
          questType: args.questType,
        ),
        settings: data,
      );
    },
    ActiveQrCodeSearchView: (data) {
      var args = data.getArgs<ActiveQrCodeSearchViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ActiveQrCodeSearchView(
          key: args.key,
          quest: args.quest,
        ),
        settings: data,
      );
    },
    ActiveDistanceEstimateQuestView: (data) {
      var args =
          data.getArgs<ActiveDistanceEstimateQuestViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ActiveDistanceEstimateQuestView(
          key: args.key,
          quest: args.quest,
        ),
        settings: data,
      );
    },
    ActiveTreasureLocationSearchQuestView: (data) {
      var args = data.getArgs<ActiveTreasureLocationSearchQuestViewArguments>(
          nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ActiveTreasureLocationSearchQuestView(
          key: args.key,
          quest: args.quest,
        ),
        settings: data,
      );
    },
    CreateQuestView: (data) {
      var args = data.getArgs<CreateQuestViewArguments>(
        orElse: () => CreateQuestViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => CreateQuestView(key: args.key),
        settings: data,
      );
    },
    ManageQuestView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ManageQuestView(),
        settings: data,
      );
    },
    QuestsOverviewView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const QuestsOverviewView(),
        settings: data,
      );
    },
    HistoryAndAchievementsView: (data) {
      var args = data.getArgs<HistoryAndAchievementsViewArguments>(
        orElse: () => HistoryAndAchievementsViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => HistoryAndAchievementsView(
          key: args.key,
          initialIndex: args.initialIndex,
        ),
        settings: data,
      );
    },
    ARObjectView: (data) {
      var args = data.getArgs<ARObjectViewArguments>(
        orElse: () => ARObjectViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => ARObjectView(
          key: args.key,
          isCoins: args.isCoins,
        ),
        settings: data,
      );
    },
    ActiveScreenTimeView: (data) {
      var args = data.getArgs<ActiveScreenTimeViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => ActiveScreenTimeView(
          key: args.key,
          session: args.session,
          screenTimeSessionId: args.screenTimeSessionId,
        ),
        settings: data,
      );
    },
    SelectScreenTimeView: (data) {
      var args = data.getArgs<SelectScreenTimeViewArguments>(
        orElse: () => SelectScreenTimeViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => SelectScreenTimeView(
          key: args.key,
          childId: args.childId,
        ),
        settings: data,
      );
    },
    SingleQuestTypeView: (data) {
      var args = data.getArgs<SingleQuestTypeViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => SingleQuestTypeView(
          key: args.key,
          quest: args.quest,
          questType: args.questType,
        ),
        settings: data,
      );
    },
    OnBoardingScreensView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const OnBoardingScreensView(),
        settings: data,
      );
    },
    ParentMapView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ParentMapView(),
        settings: data,
      );
    },
  };
}

/// ************************************************************************
/// Arguments holder classes
/// *************************************************************************

/// LoginView arguments holder class
class LoginViewArguments {
  final Key? key;
  LoginViewArguments({this.key});
}

/// CreateAccountView arguments holder class
class CreateAccountViewArguments {
  final Key? key;
  final UserRole role;
  CreateAccountViewArguments({this.key, required this.role});
}

/// SelectRoleAfterLoginView arguments holder class
class SelectRoleAfterLoginViewArguments {
  final Key? key;
  final AuthenticationMethod authMethod;
  SelectRoleAfterLoginViewArguments({this.key, required this.authMethod});
}

/// AddExplorerView arguments holder class
class AddExplorerViewArguments {
  final Key? key;
  AddExplorerViewArguments({this.key});
}

/// SearchExplorerView arguments holder class
class SearchExplorerViewArguments {
  final Key? key;
  SearchExplorerViewArguments({this.key});
}

/// SingleChildStatView arguments holder class
class SingleChildStatViewArguments {
  final Key? key;
  final String uid;
  SingleChildStatViewArguments({this.key, required this.uid});
}

/// TransferFundsView arguments holder class
class TransferFundsViewArguments {
  final Key? key;
  final TransferType type;
  final PublicUserInfo senderInfo;
  final PublicUserInfo recipientInfo;
  TransferFundsViewArguments(
      {this.key,
      required this.type,
      required this.senderInfo,
      required this.recipientInfo});
}

/// QRCodeView arguments holder class
class QRCodeViewArguments {
  final Key? key;
  final String? qrCodeString;
  QRCodeViewArguments({this.key, this.qrCodeString});
}

/// SetPinView arguments holder class
class SetPinViewArguments {
  final Key? key;
  SetPinViewArguments({this.key});
}

/// BottomBarLayoutTemplateView arguments holder class
class BottomBarLayoutTemplateViewArguments {
  final Key? key;
  final UserRole userRole;
  final BottomNavBarIndex? initialBottomNavBarIndex;
  final bool showDialog;
  final QuestViewType questViewIndex;
  final Quest? quest;
  final QuestType? questType;
  BottomBarLayoutTemplateViewArguments(
      {this.key,
      required this.userRole,
      this.initialBottomNavBarIndex,
      this.showDialog = false,
      this.questViewIndex = QuestViewType.questlist,
      this.quest,
      this.questType});
}

/// ActiveQrCodeSearchView arguments holder class
class ActiveQrCodeSearchViewArguments {
  final Key? key;
  final Quest quest;
  ActiveQrCodeSearchViewArguments({this.key, required this.quest});
}

/// ActiveDistanceEstimateQuestView arguments holder class
class ActiveDistanceEstimateQuestViewArguments {
  final Key? key;
  final Quest quest;
  ActiveDistanceEstimateQuestViewArguments({this.key, required this.quest});
}

/// ActiveTreasureLocationSearchQuestView arguments holder class
class ActiveTreasureLocationSearchQuestViewArguments {
  final Key? key;
  final Quest quest;
  ActiveTreasureLocationSearchQuestViewArguments(
      {this.key, required this.quest});
}

/// CreateQuestView arguments holder class
class CreateQuestViewArguments {
  final Key? key;
  CreateQuestViewArguments({this.key});
}

/// HistoryAndAchievementsView arguments holder class
class HistoryAndAchievementsViewArguments {
  final Key? key;
  final int initialIndex;
  HistoryAndAchievementsViewArguments({this.key, this.initialIndex = 0});
}

/// ARObjectView arguments holder class
class ARObjectViewArguments {
  final Key? key;
  final bool isCoins;
  ARObjectViewArguments({this.key, this.isCoins = false});
}

/// ActiveScreenTimeView arguments holder class
class ActiveScreenTimeViewArguments {
  final Key? key;
  final ScreenTimeSession? session;
  final String? screenTimeSessionId;
  ActiveScreenTimeViewArguments(
      {this.key, required this.session, this.screenTimeSessionId});
}

/// SelectScreenTimeView arguments holder class
class SelectScreenTimeViewArguments {
  final Key? key;
  final String? childId;
  SelectScreenTimeViewArguments({this.key, this.childId});
}

/// SingleQuestTypeView arguments holder class
class SingleQuestTypeViewArguments {
  final Key? key;
  final Quest? quest;
  final QuestType? questType;
  SingleQuestTypeViewArguments({this.key, required this.quest, this.questType});
}

/// ************************************************************************
/// Extension for strongly typed navigation
/// *************************************************************************

extension NavigatorStateExtension on NavigationService {
  Future<dynamic> navigateToParentHomeView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.parentHomeView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToSingleMarkerView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.singleMarkerView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToUpdatingQuestView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.updatingQuestView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToExplorerHomeView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.explorerHomeView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToMapOverviewView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.mapOverviewView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToLoginView({
    Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.loginView,
      arguments: LoginViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToCreateAccountView({
    Key? key,
    required UserRole role,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.createAccountView,
      arguments: CreateAccountViewArguments(key: key, role: role),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToCreateAccountUserRoleView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.createAccountUserRoleView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToStartUpView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.startUpView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToHomeView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.homeView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAdminHomeView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.adminHomeView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToSelectRoleAfterLoginView({
    Key? key,
    required AuthenticationMethod authMethod,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.selectRoleAfterLoginView,
      arguments:
          SelectRoleAfterLoginViewArguments(key: key, authMethod: authMethod),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddExplorerView({
    Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.addExplorerView,
      arguments: AddExplorerViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToSearchExplorerView({
    Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.searchExplorerView,
      arguments: SearchExplorerViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToSingleChildStatView({
    Key? key,
    required String uid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.singleChildStatView,
      arguments: SingleChildStatViewArguments(key: key, uid: uid),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToTransferFundsView({
    Key? key,
    required TransferType type,
    required PublicUserInfo senderInfo,
    required PublicUserInfo recipientInfo,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.transferFundsView,
      arguments: TransferFundsViewArguments(
          key: key,
          type: type,
          senderInfo: senderInfo,
          recipientInfo: recipientInfo),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToQRCodeView({
    Key? key,
    String? qrCodeString,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.qRCodeView,
      arguments: QRCodeViewArguments(key: key, qrCodeString: qrCodeString),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToQRCodeViewExample({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.qRCodeViewExample,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAddMarkersView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.addMarkersView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToSetPinView({
    Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.setPinView,
      arguments: SetPinViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToBottomBarLayoutTemplateView({
    Key? key,
    required UserRole userRole,
    BottomNavBarIndex? initialBottomNavBarIndex,
    bool showDialog = false,
    QuestViewType questViewIndex = QuestViewType.questlist,
    Quest? quest,
    QuestType? questType,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.bottomBarLayoutTemplateView,
      arguments: BottomBarLayoutTemplateViewArguments(
          key: key,
          userRole: userRole,
          initialBottomNavBarIndex: initialBottomNavBarIndex,
          showDialog: showDialog,
          questViewIndex: questViewIndex,
          quest: quest,
          questType: questType),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToActiveQrCodeSearchView({
    Key? key,
    required Quest quest,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.activeQrCodeSearchView,
      arguments: ActiveQrCodeSearchViewArguments(key: key, quest: quest),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToActiveDistanceEstimateQuestView({
    Key? key,
    required Quest quest,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.activeDistanceEstimateQuestView,
      arguments:
          ActiveDistanceEstimateQuestViewArguments(key: key, quest: quest),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToActiveTreasureLocationSearchQuestView({
    Key? key,
    required Quest quest,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.activeTreasureLocationSearchQuestView,
      arguments: ActiveTreasureLocationSearchQuestViewArguments(
          key: key, quest: quest),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToCreateQuestView({
    Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.createQuestView,
      arguments: CreateQuestViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToManageQuestView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.manageQuestView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToQuestsOverviewView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.questsOverviewView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToHistoryAndAchievementsView({
    Key? key,
    int initialIndex = 0,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.historyAndAchievementsView,
      arguments: HistoryAndAchievementsViewArguments(
          key: key, initialIndex: initialIndex),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToARObjectView({
    Key? key,
    bool isCoins = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.aRObjectView,
      arguments: ARObjectViewArguments(key: key, isCoins: isCoins),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToActiveScreenTimeView({
    Key? key,
    required ScreenTimeSession? session,
    String? screenTimeSessionId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.activeScreenTimeView,
      arguments: ActiveScreenTimeViewArguments(
          key: key, session: session, screenTimeSessionId: screenTimeSessionId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToSelectScreenTimeView({
    Key? key,
    String? childId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.selectScreenTimeView,
      arguments: SelectScreenTimeViewArguments(key: key, childId: childId),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToSingleQuestTypeView({
    Key? key,
    required Quest? quest,
    QuestType? questType,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.singleQuestTypeView,
      arguments: SingleQuestTypeViewArguments(
          key: key, quest: quest, questType: questType),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToOnBoardingScreensView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.onBoardingScreensView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToParentMapView({
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo(
      Routes.parentMapView,
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }
}
