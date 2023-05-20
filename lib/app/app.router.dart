// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart'
    as _i27;
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart'
    as _i30;
import 'package:afkcredits/enums/authentication_method.dart' as _i29;
import 'package:afkcredits/enums/user_role.dart' as _i28;
import 'package:afkcredits/ui/views/active_screen_time/active_screen_time_view.dart'
    as _i17;
import 'package:afkcredits/ui/views/active_screen_time/screen_time_requested_view.dart'
    as _i24;
import 'package:afkcredits/ui/views/active_screen_time/start_screen_time_counter_view.dart'
    as _i23;
import 'package:afkcredits/ui/views/ar_view/ar_object_android_view.dart'
    as _i15;
import 'package:afkcredits/ui/views/ar_view/ar_object_ios_view.dart' as _i16;
import 'package:afkcredits/ui/views/create_account/create_account_user_role_view.dart'
    as _i6;
import 'package:afkcredits/ui/views/create_account/create_account_view.dart'
    as _i5;
import 'package:afkcredits/ui/views/create_ward/create_ward_view.dart' as _i10;
import 'package:afkcredits/ui/views/feedback_view/feedback_view.dart' as _i21;
import 'package:afkcredits/ui/views/guardian_home/guardian_home_view.dart'
    as _i2;
import 'package:afkcredits/ui/views/guardian_map/guardian_map_view.dart'
    as _i20;
import 'package:afkcredits/ui/views/help_desk/hep_desk_view.dart' as _i25;
import 'package:afkcredits/ui/views/login/login_view.dart' as _i4;
import 'package:afkcredits/ui/views/login/select_role_after_login_view.dart'
    as _i9;
import 'package:afkcredits/ui/views/onboarding_screens/onboarding_screens_view.dart'
    as _i19;
import 'package:afkcredits/ui/views/permissions/permissions_view.dart' as _i22;
import 'package:afkcredits/ui/views/quests_overview/create_quest/create_quest_view.dart'
    as _i14;
import 'package:afkcredits/ui/views/screen_time/select_screen_time_view.dart'
    as _i18;
import 'package:afkcredits/ui/views/set_pin/set_pin_view.dart' as _i13;
import 'package:afkcredits/ui/views/single_ward_stat/single_ward_stat_view.dart'
    as _i11;
import 'package:afkcredits/ui/views/startup/startup_screen_time_view.dart'
    as _i8;
import 'package:afkcredits/ui/views/startup/startup_view.dart' as _i7;
import 'package:afkcredits/ui/views/transfer_funds/transfer_funds_view.dart'
    as _i12;
import 'package:afkcredits/ui/views/ward_home/ward_home_view.dart' as _i3;
import 'package:flutter/foundation.dart' as _i26;
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i31;

class Routes {
  static const guardianHomeView = '/guardian-home-view';

  static const explorerHomeView = '/explorer-home-view';

  static const loginView = '/login-view';

  static const createAccountView = '/create-account-view';

  static const createAccountUserRoleView = '/create-account-user-role-view';

  static const startUpView = '/';

  static const startUpScreenTimeView = '/start-up-screen-time-view';

  static const selectRoleAfterLoginView = '/select-role-after-login-view';

  static const createExplorerView = '/create-explorer-view';

  static const singleChildStatView = '/single-child-stat-view';

  static const transferFundsView = '/transfer-funds-view';

  static const setPinView = '/set-pin-view';

  static const createQuestView = '/create-quest-view';

  static const aRObjectAndroidView = '/a-robject-android-view';

  static const aRObjectIosView = '/a-robject-ios-view';

  static const activeScreenTimeView = '/active-screen-time-view';

  static const selectScreenTimeView = '/select-screen-time-view';

  static const onBoardingScreensView = '/on-boarding-screens-view';

  static const guardianMapView = '/guardian-map-view';

  static const feedbackView = '/feedback-view';

  static const permissionsView = '/permissions-view';

  static const startScreenTimeCounterView = '/start-screen-time-counter-view';

  static const screenTimeRequestedView = '/screen-time-requested-view';

  static const helpDeskView = '/help-desk-view';

  static const all = <String>{
    guardianHomeView,
    explorerHomeView,
    loginView,
    createAccountView,
    createAccountUserRoleView,
    startUpView,
    startUpScreenTimeView,
    selectRoleAfterLoginView,
    createExplorerView,
    singleChildStatView,
    transferFundsView,
    setPinView,
    createQuestView,
    aRObjectAndroidView,
    aRObjectIosView,
    activeScreenTimeView,
    selectScreenTimeView,
    onBoardingScreensView,
    guardianMapView,
    feedbackView,
    permissionsView,
    startScreenTimeCounterView,
    screenTimeRequestedView,
    helpDeskView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(
      Routes.guardianHomeView,
      page: _i2.GuardianHomeView,
    ),
    _i1.RouteDef(
      Routes.explorerHomeView,
      page: _i3.ExplorerHomeView,
    ),
    _i1.RouteDef(
      Routes.loginView,
      page: _i4.LoginView,
    ),
    _i1.RouteDef(
      Routes.createAccountView,
      page: _i5.CreateAccountView,
    ),
    _i1.RouteDef(
      Routes.createAccountUserRoleView,
      page: _i6.CreateAccountUserRoleView,
    ),
    _i1.RouteDef(
      Routes.startUpView,
      page: _i7.StartUpView,
    ),
    _i1.RouteDef(
      Routes.startUpScreenTimeView,
      page: _i8.StartUpScreenTimeView,
    ),
    _i1.RouteDef(
      Routes.selectRoleAfterLoginView,
      page: _i9.SelectRoleAfterLoginView,
    ),
    _i1.RouteDef(
      Routes.createExplorerView,
      page: _i10.CreateWardView,
    ),
    _i1.RouteDef(
      Routes.singleChildStatView,
      page: _i11.SingleChildStatView,
    ),
    _i1.RouteDef(
      Routes.transferFundsView,
      page: _i12.TransferFundsView,
    ),
    _i1.RouteDef(
      Routes.setPinView,
      page: _i13.SetPinView,
    ),
    _i1.RouteDef(
      Routes.createQuestView,
      page: _i14.CreateQuestView,
    ),
    _i1.RouteDef(
      Routes.aRObjectAndroidView,
      page: _i15.ARObjectAndroidView,
    ),
    _i1.RouteDef(
      Routes.aRObjectIosView,
      page: _i16.ARObjectIosView,
    ),
    _i1.RouteDef(
      Routes.activeScreenTimeView,
      page: _i17.ActiveScreenTimeView,
    ),
    _i1.RouteDef(
      Routes.selectScreenTimeView,
      page: _i18.SelectScreenTimeView,
    ),
    _i1.RouteDef(
      Routes.onBoardingScreensView,
      page: _i19.OnBoardingScreensView,
    ),
    _i1.RouteDef(
      Routes.guardianMapView,
      page: _i20.GuardianMapView,
    ),
    _i1.RouteDef(
      Routes.feedbackView,
      page: _i21.FeedbackView,
    ),
    _i1.RouteDef(
      Routes.permissionsView,
      page: _i22.PermissionsView,
    ),
    _i1.RouteDef(
      Routes.startScreenTimeCounterView,
      page: _i23.StartScreenTimeCounterView,
    ),
    _i1.RouteDef(
      Routes.screenTimeRequestedView,
      page: _i24.ScreenTimeRequestedView,
    ),
    _i1.RouteDef(
      Routes.helpDeskView,
      page: _i25.HelpDeskView,
    ),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.GuardianHomeView: (data) {
      final args = data.getArgs<GuardianHomeViewArguments>(
        orElse: () => const GuardianHomeViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i2.GuardianHomeView(
            key: args.key, screenTimeSession: args.screenTimeSession),
        settings: data,
      );
    },
    _i3.ExplorerHomeView: (data) {
      final args = data.getArgs<ExplorerHomeViewArguments>(
        orElse: () => const ExplorerHomeViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i3.ExplorerHomeView(
            key: args.key,
            showBewareDialog: args.showBewareDialog,
            screenTimeSession: args.screenTimeSession,
            showNumberQuestsDialog: args.showNumberQuestsDialog),
        settings: data,
      );
    },
    _i4.LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(
        orElse: () => const LoginViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i4.LoginView(key: args.key),
        settings: data,
      );
    },
    _i5.CreateAccountView: (data) {
      final args = data.getArgs<CreateAccountViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i5.CreateAccountView(key: args.key, role: args.role),
        settings: data,
      );
    },
    _i6.CreateAccountUserRoleView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i6.CreateAccountUserRoleView(),
        settings: data,
      );
    },
    _i7.StartUpView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i7.StartUpView(),
        settings: data,
      );
    },
    _i8.StartUpScreenTimeView: (data) {
      final args = data.getArgs<StartUpScreenTimeViewArguments>(
        orElse: () => const StartUpScreenTimeViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i8.StartUpScreenTimeView(
            key: args.key, screenTimeSession: args.screenTimeSession),
        settings: data,
      );
    },
    _i9.SelectRoleAfterLoginView: (data) {
      final args =
          data.getArgs<SelectRoleAfterLoginViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i9.SelectRoleAfterLoginView(
            key: args.key, authMethod: args.authMethod),
        settings: data,
      );
    },
    _i10.CreateWardView: (data) {
      final args = data.getArgs<CreateWardViewArguments>(
        orElse: () => const CreateWardViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i10.CreateWardView(key: args.key),
        settings: data,
      );
    },
    _i11.SingleChildStatView: (data) {
      final args = data.getArgs<SingleChildStatViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i11.SingleChildStatView(key: args.key, uid: args.uid),
        settings: data,
      );
    },
    _i12.TransferFundsView: (data) {
      final args = data.getArgs<TransferFundsViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i12.TransferFundsView(
            key: args.key,
            senderInfo: args.senderInfo,
            recipientInfo: args.recipientInfo),
        settings: data,
      );
    },
    _i13.SetPinView: (data) {
      final args = data.getArgs<SetPinViewArguments>(
        orElse: () => const SetPinViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i13.SetPinView(key: args.key),
        settings: data,
      );
    },
    _i14.CreateQuestView: (data) {
      final args = data.getArgs<CreateQuestViewArguments>(
        orElse: () => const CreateQuestViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i14.CreateQuestView(
            key: args.key, fromMap: args.fromMap, latLng: args.latLng),
        settings: data,
      );
    },
    _i15.ARObjectAndroidView: (data) {
      final args = data.getArgs<ARObjectAndroidViewArguments>(
        orElse: () => const ARObjectAndroidViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i15.ARObjectAndroidView(key: args.key, isCoins: args.isCoins),
        settings: data,
      );
    },
    _i16.ARObjectIosView: (data) {
      final args = data.getArgs<ARObjectIosViewArguments>(
        orElse: () => const ARObjectIosViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i16.ARObjectIosView(key: args.key, isCoins: args.isCoins),
        settings: data,
      );
    },
    _i17.ActiveScreenTimeView: (data) {
      final args = data.getArgs<ActiveScreenTimeViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i17.ActiveScreenTimeView(key: args.key, session: args.session),
        settings: data,
      );
    },
    _i18.SelectScreenTimeView: (data) {
      final args = data.getArgs<SelectScreenTimeViewArguments>(
        orElse: () => const SelectScreenTimeViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i18.SelectScreenTimeView(key: args.key, childId: args.childId),
        settings: data,
      );
    },
    _i19.OnBoardingScreensView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i19.OnBoardingScreensView(),
        settings: data,
      );
    },
    _i20.GuardianMapView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i20.GuardianMapView(),
        settings: data,
      );
    },
    _i21.FeedbackView: (data) {
      final args = data.getArgs<FeedbackViewArguments>(
        orElse: () => const FeedbackViewArguments(),
      );
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i21.FeedbackView(key: args.key),
        settings: data,
      );
    },
    _i22.PermissionsView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i22.PermissionsView(),
        settings: data,
      );
    },
    _i23.StartScreenTimeCounterView: (data) {
      final args =
          data.getArgs<StartScreenTimeCounterViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => _i23.StartScreenTimeCounterView(
            key: args.key, session: args.session),
        settings: data,
      );
    },
    _i24.ScreenTimeRequestedView: (data) {
      final args =
          data.getArgs<ScreenTimeRequestedViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i24.ScreenTimeRequestedView(key: args.key, session: args.session),
        settings: data,
      );
    },
    _i25.HelpDeskView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const _i25.HelpDeskView(),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;
  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class GuardianHomeViewArguments {
  const GuardianHomeViewArguments({
    this.key,
    this.screenTimeSession,
  });

  final _i26.Key? key;

  final _i27.ScreenTimeSession? screenTimeSession;
}

class ExplorerHomeViewArguments {
  const ExplorerHomeViewArguments({
    this.key,
    this.showBewareDialog = false,
    this.screenTimeSession,
    this.showNumberQuestsDialog = false,
  });

  final _i26.Key? key;

  final bool showBewareDialog;

  final _i27.ScreenTimeSession? screenTimeSession;

  final bool showNumberQuestsDialog;
}

class LoginViewArguments {
  const LoginViewArguments({this.key});

  final _i26.Key? key;
}

class CreateAccountViewArguments {
  const CreateAccountViewArguments({
    this.key,
    required this.role,
  });

  final _i26.Key? key;

  final _i28.UserRole role;
}

class StartUpScreenTimeViewArguments {
  const StartUpScreenTimeViewArguments({
    this.key,
    this.screenTimeSession,
  });

  final _i26.Key? key;

  final _i27.ScreenTimeSession? screenTimeSession;
}

class SelectRoleAfterLoginViewArguments {
  const SelectRoleAfterLoginViewArguments({
    this.key,
    required this.authMethod,
  });

  final _i26.Key? key;

  final _i29.AuthenticationMethod authMethod;
}

class CreateWardViewArguments {
  const CreateWardViewArguments({this.key});

  final _i26.Key? key;
}

class SingleChildStatViewArguments {
  const SingleChildStatViewArguments({
    this.key,
    required this.uid,
  });

  final _i26.Key? key;

  final String uid;
}

class TransferFundsViewArguments {
  const TransferFundsViewArguments({
    this.key,
    required this.senderInfo,
    required this.recipientInfo,
  });

  final _i26.Key? key;

  final _i30.PublicUserInfo senderInfo;

  final _i30.PublicUserInfo recipientInfo;
}

class SetPinViewArguments {
  const SetPinViewArguments({this.key});

  final _i26.Key? key;
}

class CreateQuestViewArguments {
  const CreateQuestViewArguments({
    this.key,
    this.fromMap = false,
    this.latLng,
  });

  final _i26.Key? key;

  final bool fromMap;

  final List<double>? latLng;
}

class ARObjectAndroidViewArguments {
  const ARObjectAndroidViewArguments({
    this.key,
    this.isCoins = false,
  });

  final _i26.Key? key;

  final bool isCoins;
}

class ARObjectIosViewArguments {
  const ARObjectIosViewArguments({
    this.key,
    this.isCoins = false,
  });

  final _i26.Key? key;

  final bool isCoins;
}

class ActiveScreenTimeViewArguments {
  const ActiveScreenTimeViewArguments({
    this.key,
    required this.session,
  });

  final _i26.Key? key;

  final _i27.ScreenTimeSession session;
}

class SelectScreenTimeViewArguments {
  const SelectScreenTimeViewArguments({
    this.key,
    this.childId,
  });

  final _i26.Key? key;

  final String? childId;
}

class FeedbackViewArguments {
  const FeedbackViewArguments({this.key});

  final _i26.Key? key;
}

class StartScreenTimeCounterViewArguments {
  const StartScreenTimeCounterViewArguments({
    this.key,
    required this.session,
  });

  final _i26.Key? key;

  final _i27.ScreenTimeSession session;
}

class ScreenTimeRequestedViewArguments {
  const ScreenTimeRequestedViewArguments({
    this.key,
    required this.session,
  });

  final _i26.Key? key;

  final _i27.ScreenTimeSession session;
}

extension NavigatorStateExtension on _i31.NavigationService {
  Future<dynamic> navigateToGuardianHomeView({
    _i26.Key? key,
    _i27.ScreenTimeSession? screenTimeSession,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.guardianHomeView,
        arguments: GuardianHomeViewArguments(
            key: key, screenTimeSession: screenTimeSession),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToExplorerHomeView({
    _i26.Key? key,
    bool showBewareDialog = false,
    _i27.ScreenTimeSession? screenTimeSession,
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

  Future<dynamic> navigateToLoginView({
    _i26.Key? key,
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
    _i26.Key? key,
    required _i28.UserRole role,
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
    _i26.Key? key,
    _i27.ScreenTimeSession? screenTimeSession,
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

  Future<dynamic> navigateToSelectRoleAfterLoginView({
    _i26.Key? key,
    required _i29.AuthenticationMethod authMethod,
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

  Future<dynamic> navigateToCreateWardView({
    _i26.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.createExplorerView,
        arguments: CreateWardViewArguments(key: key),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSingleChildStatView({
    _i26.Key? key,
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
    _i26.Key? key,
    required _i30.PublicUserInfo senderInfo,
    required _i30.PublicUserInfo recipientInfo,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.transferFundsView,
        arguments: TransferFundsViewArguments(
            key: key, senderInfo: senderInfo, recipientInfo: recipientInfo),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToSetPinView({
    _i26.Key? key,
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

  Future<dynamic> navigateToCreateQuestView({
    _i26.Key? key,
    bool fromMap = false,
    List<double>? latLng,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.createQuestView,
        arguments: CreateQuestViewArguments(
            key: key, fromMap: fromMap, latLng: latLng),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToARObjectAndroidView({
    _i26.Key? key,
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
    _i26.Key? key,
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
    _i26.Key? key,
    required _i27.ScreenTimeSession session,
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
    _i26.Key? key,
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

  Future<dynamic> navigateToGuardianMapView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.guardianMapView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToFeedbackView({
    _i26.Key? key,
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
    _i26.Key? key,
    required _i27.ScreenTimeSession session,
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

  Future<dynamic> navigateToScreenTimeRequestedView({
    _i26.Key? key,
    required _i27.ScreenTimeSession session,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(Routes.screenTimeRequestedView,
        arguments: ScreenTimeRequestedViewArguments(key: key, session: session),
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }

  Future<dynamic> navigateToHelpDeskView([
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  ]) async {
    return navigateTo<dynamic>(Routes.helpDeskView,
        id: routerId,
        preventDuplicates: preventDuplicates,
        parameters: parameters,
        transition: transition);
  }
}
