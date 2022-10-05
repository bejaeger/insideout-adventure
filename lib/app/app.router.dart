// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:afkcredits/datamodels/quests/quest.dart' as _i48;
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart'
    as _i41;
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart'
    as _i45;
import 'package:afkcredits/enums/authentication_method.dart' as _i43;
import 'package:afkcredits/enums/bottom_nav_bar_index.dart' as _i47;
import 'package:afkcredits/enums/quest_view_index.dart' as _i46;
import 'package:afkcredits/enums/transfer_type.dart' as _i44;
import 'package:afkcredits/enums/user_role.dart' as _i42;
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_distance_estimate_quest/active_distance_estimate_quest_view.dart'
    as _i25;
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_qrcode_search/active_qrcode_search_view.dart'
    as _i24;
import 'package:afkcredits/ui/views/active_screen_time/active_screen_time_view.dart'
    as _i32;
import 'package:afkcredits/ui/views/active_screen_time/start_screen_time_counter_view.dart'
    as _i39;
import 'package:afkcredits/ui/views/admin/admin_home_view.dart' as _i13;
import 'package:afkcredits/ui/views/admin/admin_user/home/home_view.dart'
    as _i12;
import 'package:afkcredits/ui/views/admin/admin_user/markers/add_markers/add_markers_view.dart'
    as _i21;
import 'package:afkcredits/ui/views/admin/admin_user/markers/single/single_marker_view.dart'
    as _i3;
import 'package:afkcredits/ui/views/ar_view/ar_object_android_view.dart'
    as _i30;
import 'package:afkcredits/ui/views/ar_view/ar_object_ios_view.dart' as _i31;
import 'package:afkcredits/ui/views/create_account/create_account_user_role_view.dart'
    as _i9;
import 'package:afkcredits/ui/views/create_account/create_account_view.dart'
    as _i8;
import 'package:afkcredits/ui/views/create_explorer/create_explorer_view.dart'
    as _i15;
import 'package:afkcredits/ui/views/explorer_home/explorer_home_view.dart'
    as _i5;
import 'package:afkcredits/ui/views/feedback_view/feedback_view.dart' as _i37;
import 'package:afkcredits/ui/views/history_and_achievements/history_and_achievements_view.dart'
    as _i29;
import 'package:afkcredits/ui/views/layout/bottom_bar_layout_view.dart' as _i23;
import 'package:afkcredits/ui/views/login/login_view.dart' as _i7;
import 'package:afkcredits/ui/views/login/select_role_after_login_view.dart'
    as _i14;
import 'package:afkcredits/ui/views/map/map_overview_view.dart' as _i6;
import 'package:afkcredits/ui/views/onboarding_screens/onboarding_screens_view.dart'
    as _i35;
import 'package:afkcredits/ui/views/parent_home/parent_home_view.dart' as _i2;
import 'package:afkcredits/ui/views/parent_map/parent_map_view.dart' as _i36;
import 'package:afkcredits/ui/views/permissions/permissions_view.dart' as _i38;
import 'package:afkcredits/ui/views/qrcode/qrcode_view.dart' as _i19;
import 'package:afkcredits/ui/views/qrcode/qrcode_view_example.dart' as _i20;
import 'package:afkcredits/ui/views/quests_overview/create_quest/create_quest_view.dart'
    as _i26;
import 'package:afkcredits/ui/views/quests_overview/edit_quest/edit_quest_view.dart'
    as _i4;
import 'package:afkcredits/ui/views/quests_overview/manage_quest/manage_quest_view.dart'
    as _i27;
import 'package:afkcredits/ui/views/quests_overview/quests_overview_view.dart'
    as _i28;
import 'package:afkcredits/ui/views/screen_time/select_screen_time_view.dart'
    as _i33;
import 'package:afkcredits/ui/views/search_explorer/search_explorer_view.dart'
    as _i16;
import 'package:afkcredits/ui/views/set_pin/set_pin_view.dart' as _i22;
import 'package:afkcredits/ui/views/single_child_stat/single_child_stat_view.dart'
    as _i17;
import 'package:afkcredits/ui/views/single_quest_type/single_quest_type_view.dart'
    as _i34;
import 'package:afkcredits/ui/views/startup/startup_screen_time_view.dart'
    as _i11;
import 'package:afkcredits/ui/views/startup/startup_view.dart' as _i10;
import 'package:afkcredits/ui/views/transfer_funds/transfer_funds_view.dart'
    as _i18;
import 'package:afkcredits_ui/afkcredits_ui.dart' as _i49;
import 'package:flutter/foundation.dart' as _i40;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i50;

class Routes {
  static const parentHomeView = '/parent-home-view';

  static const singleMarkerView = '/single-marker-view';

  static const updatingQuestView = '/updating-quest-view';

  static const explorerHomeView = '/explorer-home-view';

  static const mapOverviewView = '/map-overview-view';

  static const loginView = '/login-view';

  static const createAccountView = '/create-account-view';

  static const createAccountUserRoleView = '/create-account-user-role-view';

  static const startUpView = '/';

  static const startUpScreenTimeView = '/start-up-screen-time-view';

  static const homeView = '/home-view';

  static const adminHomeView = '/admin-home-view';

  static const selectRoleAfterLoginView = '/select-role-after-login-view';

  static const createExplorerView = '/create-explorer-view';

  static const searchExplorerView = '/search-explorer-view';

  static const singleChildStatView = '/single-child-stat-view';

  static const transferFundsView = '/transfer-funds-view';

  static const qRCodeView = '/q-rcode-view';

  static const qRCodeViewExample = '/q-rcode-view-example';

  static const addMarkersView = '/add-markers-view';

  static const setPinView = '/set-pin-view';

  static const bottomBarLayoutTemplateView = '/bottom-bar-layout-template-view';

  static const activeQrCodeSearchView = '/active-qr-code-search-view';

  static const activeDistanceEstimateQuestView =
      '/active-distance-estimate-quest-view';

  static const createQuestView = '/create-quest-view';

  static const manageQuestView = '/manage-quest-view';

  static const questsOverviewView = '/quests-overview-view';

  static const historyAndAchievementsView = '/history-and-achievements-view';

  static const aRObjectAndroidView = '/a-robject-android-view';

  static const aRObjectIosView = '/a-robject-ios-view';

  static const activeScreenTimeView = '/active-screen-time-view';

  static const selectScreenTimeView = '/select-screen-time-view';

  static const singleQuestTypeView = '/single-quest-type-view';

  static const onBoardingScreensView = '/on-boarding-screens-view';

  static const parentMapView = '/parent-map-view';

  static const feedbackView = '/feedback-view';

  static const permissionsView = '/permissions-view';

  static const startScreenTimeCounterView = '/start-screen-time-counter-view';

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
    startUpScreenTimeView,
    homeView,
    adminHomeView,
    selectRoleAfterLoginView,
    createExplorerView,
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
    createQuestView,
    manageQuestView,
    questsOverviewView,
    historyAndAchievementsView,
    aRObjectAndroidView,
    aRObjectIosView,
    activeScreenTimeView,
    selectScreenTimeView,
    singleQuestTypeView,
    onBoardingScreensView,
    parentMapView,
    feedbackView,
    permissionsView,
    startScreenTimeCounterView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.parentHomeView,
      page: _i2.ParentHomeView,
    ),
    _i1.RouteDef(
      Routes.singleMarkerView,
      page: _i3.SingleMarkerView,
    ),
    _i1.RouteDef(
      Routes.updatingQuestView,
      page: _i4.UpdatingQuestView,
    ),
    _i1.RouteDef(
      Routes.explorerHomeView,
      page: _i5.ExplorerHomeView,
    ),
    _i1.RouteDef(
      Routes.mapOverviewView,
      page: _i6.MapOverviewView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i7.LoginView,
    ),
    _i1.RouteDef(
      Routes.createAccountView,
      page: _i8.CreateAccountView,
    ),
    _i1.RouteDef(
      Routes.createAccountUserRoleView,
      page: _i9.CreateAccountUserRoleView,
    ),
    _i1.RouteDef(
      Routes.startUpView,
      page: _i10.StartUpView,
    ),
    _i1.RouteDef(
      Routes.startUpScreenTimeView,
      page: _i11.StartUpScreenTimeView,
    ),
    _i1.RouteDef(
      Routes.homeView,
      page: _i12.HomeView,
    ),
    _i1.RouteDef(
      Routes.adminHomeView,
      page: _i13.AdminHomeView,
    ),
    _i1.RouteDef(
      Routes.selectRoleAfterLoginView,
      page: _i14.SelectRoleAfterLoginView,
    ),
    _i1.RouteDef(
      Routes.createExplorerView,
      page: _i15.CreateExplorerView,
    ),
    _i1.RouteDef(
      Routes.searchExplorerView,
      page: _i16.SearchExplorerView,
    ),
    _i1.RouteDef(
      Routes.singleChildStatView,
      page: _i17.SingleChildStatView,
    ),
    _i1.RouteDef(
      Routes.transferFundsView,
      page: _i18.TransferFundsView,
    ),
    _i1.RouteDef(
      Routes.qRCodeView,
      page: _i19.QRCodeView,
    ),
    _i1.RouteDef(
      Routes.qRCodeViewExample,
      page: _i20.QRCodeViewExample,
    ),
    _i1.RouteDef(
      Routes.addMarkersView,
      page: _i21.AddMarkersView,
    ),
    _i1.RouteDef(
      Routes.setPinView,
      page: _i22.SetPinView,
    ),
    _i1.RouteDef(
      Routes.bottomBarLayoutTemplateView,
      page: _i23.BottomBarLayoutTemplateView,
    ),
    _i1.RouteDef(
      Routes.activeQrCodeSearchView,
      page: _i24.ActiveQrCodeSearchView,
    ),
    _i1.RouteDef(
      Routes.activeDistanceEstimateQuestView,
      page: _i25.ActiveDistanceEstimateQuestView,
    ),
    _i1.RouteDef(
      Routes.createQuestView,
      page: _i26.CreateQuestView,
    ),
    _i1.RouteDef(
      Routes.manageQuestView,
      page: _i27.ManageQuestView,
    ),
    _i1.RouteDef(
      Routes.questsOverviewView,
      page: _i28.QuestsOverviewView,
    ),
    _i1.RouteDef(
      Routes.historyAndAchievementsView,
      page: _i29.HistoryAndAchievementsView,
    ),
    _i1.RouteDef(
      Routes.aRObjectAndroidView,
      page: _i30.ARObjectAndroidView,
    ),
    _i1.RouteDef(
      Routes.aRObjectIosView,
      page: _i31.ARObjectIosView,
    ),
    _i1.RouteDef(
      Routes.activeScreenTimeView,
      page: _i32.ActiveScreenTimeView,
    ),
    _i1.RouteDef(
      Routes.selectScreenTimeView,
      page: _i33.SelectScreenTimeView,
    ),
    _i1.RouteDef(
      Routes.singleQuestTypeView,
      page: _i34.SingleQuestTypeView,
    ),
    _i1.RouteDef(
      Routes.onBoardingScreensView,
      page: _i35.OnBoardingScreensView,
    ),
    _i1.RouteDef(
      Routes.parentMapView,
      page: _i36.ParentMapView,
    ),
    _i1.RouteDef(
      Routes.feedbackView,
      page: _i37.FeedbackView,
    ),
    _i1.RouteDef(
      Routes.permissionsView,
      page: _i38.PermissionsView,
    ),
    _i1.RouteDef(
      Routes.startScreenTimeCounterView,
      page: _i39.StartScreenTimeCounterView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.ParentHomeView: (data) {
      final args = data.getArgs<ParentHomeViewArguments>(
        orElse: () => const ParentHomeViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i2.ParentHomeView(
            key: args.key, screenTimeSession: args.screenTimeSession),
        settings: data,
      );
    },
    _i3.SingleMarkerView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i3.SingleMarkerView(),
        settings: data,
      );
    },
    _i4.UpdatingQuestView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i4.UpdatingQuestView(),
        settings: data,
      );
    },
    _i5.ExplorerHomeView: (data) {
      final args = data.getArgs<ExplorerHomeViewArguments>(
        orElse: () => const ExplorerHomeViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i5.ExplorerHomeView(
            key: args.key,
            showBewareDialog: args.showBewareDialog,
            screenTimeSession: args.screenTimeSession,
            showNumberQuestsDialog: args.showNumberQuestsDialog),
        settings: data,
      );
    },
    _i6.MapOverviewView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.MapOverviewView(),
        settings: data,
      );
    },
    _i7.LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(
        orElse: () => const LoginViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i7.LoginView(key: args.key),
        settings: data,
      );
    },
    _i8.CreateAccountView: (data) {
      final args = data.getArgs<CreateAccountViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i8.CreateAccountView(key: args.key, role: args.role),
        settings: data,
      );
    },
    _i9.CreateAccountUserRoleView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i9.CreateAccountUserRoleView(),
        settings: data,
      );
    },
    _i10.StartUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i10.StartUpView(),
        settings: data,
      );
    },
    _i11.StartUpScreenTimeView: (data) {
      final args = data.getArgs<StartUpScreenTimeViewArguments>(
        orElse: () => const StartUpScreenTimeViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i11.StartUpScreenTimeView(
            key: args.key, screenTimeSession: args.screenTimeSession),
        settings: data,
      );
    },
    _i12.HomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i12.HomeView(),
        settings: data,
      );
    },
    _i13.AdminHomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i13.AdminHomeView(),
        settings: data,
      );
    },
    _i14.SelectRoleAfterLoginView: (data) {
      final args =
          data.getArgs<SelectRoleAfterLoginViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i14.SelectRoleAfterLoginView(
            key: args.key, authMethod: args.authMethod),
        settings: data,
      );
    },
    _i15.CreateExplorerView: (data) {
      final args = data.getArgs<CreateExplorerViewArguments>(
        orElse: () => const CreateExplorerViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i15.CreateExplorerView(key: args.key),
        settings: data,
      );
    },
    _i16.SearchExplorerView: (data) {
      final args = data.getArgs<SearchExplorerViewArguments>(
        orElse: () => const SearchExplorerViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i16.SearchExplorerView(key: args.key),
        settings: data,
      );
    },
    _i17.SingleChildStatView: (data) {
      final args = data.getArgs<SingleChildStatViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i17.SingleChildStatView(key: args.key, uid: args.uid),
        settings: data,
      );
    },
    _i18.TransferFundsView: (data) {
      final args = data.getArgs<TransferFundsViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i18.TransferFundsView(
            key: args.key,
            type: args.type,
            senderInfo: args.senderInfo,
            recipientInfo: args.recipientInfo),
        settings: data,
      );
    },
    _i19.QRCodeView: (data) {
      final args = data.getArgs<QRCodeViewArguments>(
        orElse: () => const QRCodeViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i19.QRCodeView(key: args.key, qrCodeString: args.qrCodeString),
        settings: data,
      );
    },
    _i20.QRCodeViewExample: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i20.QRCodeViewExample(),
        settings: data,
      );
    },
    _i21.AddMarkersView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i21.AddMarkersView(),
        settings: data,
      );
    },
    _i22.SetPinView: (data) {
      final args = data.getArgs<SetPinViewArguments>(
        orElse: () => const SetPinViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i22.SetPinView(key: args.key),
        settings: data,
      );
    },
    _i23.BottomBarLayoutTemplateView: (data) {
      final args =
          data.getArgs<BottomBarLayoutTemplateViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i23.BottomBarLayoutTemplateView(
            key: args.key,
            userRole: args.userRole,
            initialBottomNavBarIndex: args.initialBottomNavBarIndex,
            showDialog: args.showDialog,
            questViewIndex: args.questViewIndex,
            quest: args.quest,
            questType: args.questType),
        settings: data,
      );
    },
    _i24.ActiveQrCodeSearchView: (data) {
      final args = data.getArgs<ActiveQrCodeSearchViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i24.ActiveQrCodeSearchView(key: args.key, quest: args.quest),
        settings: data,
      );
    },
    _i25.ActiveDistanceEstimateQuestView: (data) {
      final args =
          data.getArgs<ActiveDistanceEstimateQuestViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i25.ActiveDistanceEstimateQuestView(
            key: args.key, quest: args.quest),
        settings: data,
      );
    },
    _i26.CreateQuestView: (data) {
      final args = data.getArgs<CreateQuestViewArguments>(
        orElse: () => const CreateQuestViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i26.CreateQuestView(key: args.key, fromMap: args.fromMap),
        settings: data,
      );
    },
    _i27.ManageQuestView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i27.ManageQuestView(),
        settings: data,
      );
    },
    _i28.QuestsOverviewView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i28.QuestsOverviewView(),
        settings: data,
      );
    },
    _i29.HistoryAndAchievementsView: (data) {
      final args = data.getArgs<HistoryAndAchievementsViewArguments>(
        orElse: () => const HistoryAndAchievementsViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i29.HistoryAndAchievementsView(
            key: args.key, initialIndex: args.initialIndex),
        settings: data,
      );
    },
    _i30.ARObjectAndroidView: (data) {
      final args = data.getArgs<ARObjectAndroidViewArguments>(
        orElse: () => const ARObjectAndroidViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i30.ARObjectAndroidView(key: args.key, isCoins: args.isCoins),
        settings: data,
      );
    },
    _i31.ARObjectIosView: (data) {
      final args = data.getArgs<ARObjectIosViewArguments>(
        orElse: () => const ARObjectIosViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i31.ARObjectIosView(key: args.key, isCoins: args.isCoins),
        settings: data,
      );
    },
    _i32.ActiveScreenTimeView: (data) {
      final args = data.getArgs<ActiveScreenTimeViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i32.ActiveScreenTimeView(key: args.key, session: args.session),
        settings: data,
      );
    },
    _i33.SelectScreenTimeView: (data) {
      final args = data.getArgs<SelectScreenTimeViewArguments>(
        orElse: () => const SelectScreenTimeViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i33.SelectScreenTimeView(key: args.key, childId: args.childId),
        settings: data,
      );
    },
    _i34.SingleQuestTypeView: (data) {
      final args = data.getArgs<SingleQuestTypeViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i34.SingleQuestTypeView(
            key: args.key, quest: args.quest, questType: args.questType),
        settings: data,
      );
    },
    _i35.OnBoardingScreensView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i35.OnBoardingScreensView(),
        settings: data,
      );
    },
    _i36.ParentMapView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i36.ParentMapView(),
        settings: data,
      );
    },
    _i37.FeedbackView: (data) {
      final args = data.getArgs<FeedbackViewArguments>(
        orElse: () => const FeedbackViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i37.FeedbackView(key: args.key),
        settings: data,
      );
    },
    _i38.PermissionsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i38.PermissionsView(),
        settings: data,
      );
    },
    _i39.StartScreenTimeCounterView: (data) {
      final args =
          data.getArgs<StartScreenTimeCounterViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i39.StartScreenTimeCounterView(
            key: args.key, session: args.session),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;
  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class ParentHomeViewArguments {
  const ParentHomeViewArguments({
    this.key,
    this.screenTimeSession,
  });

  final _i40.Key? key;

  final _i41.ScreenTimeSession? screenTimeSession;
}

class ExplorerHomeViewArguments {
  const ExplorerHomeViewArguments({
    this.key,
    this.showBewareDialog = false,
    this.screenTimeSession,
    this.showNumberQuestsDialog = false,
  });

  final _i40.Key? key;

  final bool showBewareDialog;

  final _i41.ScreenTimeSession? screenTimeSession;

  final bool showNumberQuestsDialog;
}

class LoginViewArguments {
  const LoginViewArguments({this.key});

  final _i40.Key? key;
}

class CreateAccountViewArguments {
  const CreateAccountViewArguments({
    this.key,
    required this.role,
  });

  final _i40.Key? key;

  final _i42.UserRole role;
}

class StartUpScreenTimeViewArguments {
  const StartUpScreenTimeViewArguments({
    this.key,
    this.screenTimeSession,
  });

  final _i40.Key? key;

  final _i41.ScreenTimeSession? screenTimeSession;
}

class SelectRoleAfterLoginViewArguments {
  const SelectRoleAfterLoginViewArguments({
    this.key,
    required this.authMethod,
  });

  final _i40.Key? key;

  final _i43.AuthenticationMethod authMethod;
}

class CreateExplorerViewArguments {
  const CreateExplorerViewArguments({this.key});

  final _i40.Key? key;
}

class SearchExplorerViewArguments {
  const SearchExplorerViewArguments({this.key});

  final _i40.Key? key;
}

class SingleChildStatViewArguments {
  const SingleChildStatViewArguments({
    this.key,
    required this.uid,
  });

  final _i40.Key? key;

  final String uid;
}

class TransferFundsViewArguments {
  const TransferFundsViewArguments({
    this.key,
    required this.type,
    required this.senderInfo,
    required this.recipientInfo,
  });

  final _i40.Key? key;

  final _i44.TransferType type;

  final _i45.PublicUserInfo senderInfo;

  final _i45.PublicUserInfo recipientInfo;
}

class QRCodeViewArguments {
  const QRCodeViewArguments({
    this.key,
    this.qrCodeString,
  });

  final _i40.Key? key;

  final String? qrCodeString;
}

class SetPinViewArguments {
  const SetPinViewArguments({this.key});

  final _i40.Key? key;
}

class BottomBarLayoutTemplateViewArguments {
  const BottomBarLayoutTemplateViewArguments({
    this.key,
    required this.userRole,
    this.initialBottomNavBarIndex,
    this.showDialog = false,
    this.questViewIndex = _i46.QuestViewType.questlist,
    this.quest,
    this.questType,
  });

  final _i40.Key? key;

  final _i42.UserRole userRole;

  final _i47.BottomNavBarIndex? initialBottomNavBarIndex;

  final bool showDialog;

  final _i46.QuestViewType questViewIndex;

  final _i48.Quest? quest;

  final _i49.QuestType? questType;
}

class ActiveQrCodeSearchViewArguments {
  const ActiveQrCodeSearchViewArguments({
    this.key,
    required this.quest,
  });

  final _i40.Key? key;

  final _i48.Quest quest;
}

class ActiveDistanceEstimateQuestViewArguments {
  const ActiveDistanceEstimateQuestViewArguments({
    this.key,
    required this.quest,
  });

  final _i40.Key? key;

  final _i48.Quest quest;
}

class CreateQuestViewArguments {
  const CreateQuestViewArguments({
    this.key,
    this.fromMap = false,
  });

  final _i40.Key? key;

  final bool fromMap;
}

class HistoryAndAchievementsViewArguments {
  const HistoryAndAchievementsViewArguments({
    this.key,
    this.initialIndex = 0,
  });

  final _i40.Key? key;

  final int initialIndex;
}

class ARObjectAndroidViewArguments {
  const ARObjectAndroidViewArguments({
    this.key,
    this.isCoins = false,
  });

  final _i40.Key? key;

  final bool isCoins;
}

class ARObjectIosViewArguments {
  const ARObjectIosViewArguments({
    this.key,
    this.isCoins = false,
  });

  final _i40.Key? key;

  final bool isCoins;
}

class ActiveScreenTimeViewArguments {
  const ActiveScreenTimeViewArguments({
    this.key,
    required this.session,
  });

  final _i40.Key? key;

  final _i41.ScreenTimeSession session;
}

class SelectScreenTimeViewArguments {
  const SelectScreenTimeViewArguments({
    this.key,
    this.childId,
  });

  final _i40.Key? key;

  final String? childId;
}

class SingleQuestTypeViewArguments {
  const SingleQuestTypeViewArguments({
    this.key,
    required this.quest,
    this.questType,
  });

  final _i40.Key? key;

  final _i48.Quest? quest;

  final _i49.QuestType? questType;
}

class FeedbackViewArguments {
  const FeedbackViewArguments({this.key});

  final _i40.Key? key;
}

class StartScreenTimeCounterViewArguments {
  const StartScreenTimeCounterViewArguments({
    this.key,
    required this.session,
  });

  final _i40.Key? key;

  final _i41.ScreenTimeSession session;
}

extension NavigatorStateExtension on _i50.NavigationService {
  Future<dynamic> navigateToParentHomeView({
    _i40.Key? key,
    _i41.ScreenTimeSession? screenTimeSession,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.parentHomeView,
        arguments: ParentHomeViewArguments(
            key: key, screenTimeSession: screenTimeSession),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSingleMarkerView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.singleMarkerView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToUpdatingQuestView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.updatingQuestView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToExplorerHomeView({
    _i40.Key? key,
    bool showBewareDialog = false,
    _i41.ScreenTimeSession? screenTimeSession,
    bool showNumberQuestsDialog = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.explorerHomeView,
        arguments: ExplorerHomeViewArguments(
            key: key,
            showBewareDialog: showBewareDialog,
            screenTimeSession: screenTimeSession,
            showNumberQuestsDialog: showNumberQuestsDialog),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToMapOverviewView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.mapOverviewView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToLoginView({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.loginView,
        arguments: LoginViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCreateAccountView({
    _i40.Key? key,
    required _i42.UserRole role,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.createAccountView,
        arguments: CreateAccountViewArguments(key: key, role: role),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCreateAccountUserRoleView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.createAccountUserRoleView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStartUpView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.startUpView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStartUpScreenTimeView({
    _i40.Key? key,
    _i41.ScreenTimeSession? screenTimeSession,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.startUpScreenTimeView,
        arguments: StartUpScreenTimeViewArguments(
            key: key, screenTimeSession: screenTimeSession),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.homeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAdminHomeView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.adminHomeView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSelectRoleAfterLoginView({
    _i40.Key? key,
    required _i43.AuthenticationMethod authMethod,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.selectRoleAfterLoginView,
        arguments:
            SelectRoleAfterLoginViewArguments(key: key, authMethod: authMethod),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCreateExplorerView({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.createExplorerView,
        arguments: CreateExplorerViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSearchExplorerView({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.searchExplorerView,
        arguments: SearchExplorerViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSingleChildStatView({
    _i40.Key? key,
    required String uid,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.singleChildStatView,
        arguments: SingleChildStatViewArguments(key: key, uid: uid),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToTransferFundsView({
    _i40.Key? key,
    required _i44.TransferType type,
    required _i45.PublicUserInfo senderInfo,
    required _i45.PublicUserInfo recipientInfo,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.transferFundsView,
        arguments: TransferFundsViewArguments(
            key: key,
            type: type,
            senderInfo: senderInfo,
            recipientInfo: recipientInfo),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToQRCodeView({
    _i40.Key? key,
    String? qrCodeString,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.qRCodeView,
        arguments: QRCodeViewArguments(key: key, qrCodeString: qrCodeString),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToQRCodeViewExample([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.qRCodeViewExample,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToAddMarkersView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.addMarkersView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSetPinView({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.setPinView,
        arguments: SetPinViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToBottomBarLayoutTemplateView({
    _i40.Key? key,
    required _i42.UserRole userRole,
    _i47.BottomNavBarIndex? initialBottomNavBarIndex,
    bool showDialog = false,
    _i46.QuestViewType questViewIndex = _i46.QuestViewType.questlist,
    _i48.Quest? quest,
    _i49.QuestType? questType,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.bottomBarLayoutTemplateView,
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
        transition: transition);
  }

  Future<dynamic> navigateToActiveQrCodeSearchView({
    _i40.Key? key,
    required _i48.Quest quest,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.activeQrCodeSearchView,
        arguments: ActiveQrCodeSearchViewArguments(key: key, quest: quest),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToActiveDistanceEstimateQuestView({
    _i40.Key? key,
    required _i48.Quest quest,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.activeDistanceEstimateQuestView,
        arguments:
            ActiveDistanceEstimateQuestViewArguments(key: key, quest: quest),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToCreateQuestView({
    _i40.Key? key,
    bool fromMap = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.createQuestView,
        arguments: CreateQuestViewArguments(key: key, fromMap: fromMap),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToManageQuestView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.manageQuestView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToQuestsOverviewView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.questsOverviewView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHistoryAndAchievementsView({
    _i40.Key? key,
    int initialIndex = 0,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.historyAndAchievementsView,
        arguments: HistoryAndAchievementsViewArguments(
            key: key, initialIndex: initialIndex),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToARObjectAndroidView({
    _i40.Key? key,
    bool isCoins = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.aRObjectAndroidView,
        arguments: ARObjectAndroidViewArguments(key: key, isCoins: isCoins),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToARObjectIosView({
    _i40.Key? key,
    bool isCoins = false,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.aRObjectIosView,
        arguments: ARObjectIosViewArguments(key: key, isCoins: isCoins),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToActiveScreenTimeView({
    _i40.Key? key,
    required _i41.ScreenTimeSession session,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.activeScreenTimeView,
        arguments: ActiveScreenTimeViewArguments(key: key, session: session),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSelectScreenTimeView({
    _i40.Key? key,
    String? childId,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.selectScreenTimeView,
        arguments: SelectScreenTimeViewArguments(key: key, childId: childId),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSingleQuestTypeView({
    _i40.Key? key,
    required _i48.Quest? quest,
    _i49.QuestType? questType,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.singleQuestTypeView,
        arguments: SingleQuestTypeViewArguments(
            key: key, quest: quest, questType: questType),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToOnBoardingScreensView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.onBoardingScreensView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToParentMapView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.parentMapView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToFeedbackView({
    _i40.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.feedbackView,
        arguments: FeedbackViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToPermissionsView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.permissionsView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToStartScreenTimeCounterView({
    _i40.Key? key,
    required _i41.ScreenTimeSession session,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.startScreenTimeCounterView,
        arguments:
            StartScreenTimeCounterViewArguments(key: key, session: session),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
