// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../datamodels/users/public_info/public_user_info.dart';
import '../enums/transfer_type.dart';
import '../enums/user_role.dart';
import '../ui/views/add_explorer/add_explorer_view.dart';
import '../ui/views/admin/admin_home_view.dart';
import '../ui/views/create_account/create_account_user_role_view.dart';
import '../ui/views/create_account/create_account_view.dart';
import '../ui/views/explorer_home/explorer_home_view.dart';
import '../ui/views/giftcards/giftcard_view.dart';
import '../ui/views/layout/layout_template_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/login/select_role_after_login_view.dart';
import '../ui/views/map/map_view.dart';
import '../ui/views/qrcode/qrcode_view.dart';
import '../ui/views/qrcode/qrcode_view_example.dart';
import '../ui/views/quest/active_quest_view.dart';
import '../ui/views/search_explorer/search_explorer_view.dart';
import '../ui/views/single_explorer/single_explorer_view.dart';
import '../ui/views/sponsor_home/sponsor_home_view.dart';
import '../ui/views/startup/startup_view.dart';
import '../ui/views/transaction_history/transfers_history_view.dart';
import '../ui/views/transfer_funds/transfer_funds_view.dart';

class Routes {
  static const String sponsorHomeView = '/sponsor-home-view';
  static const String explorerHomeView = '/explorer-home-view';
  static const String mapView = '/map-view';
  static const String loginView = '/login-view';
  static const String createAccountView = '/create-account-view';
  static const String createAccountUserRoleView =
      '/create-account-user-role-view';
  static const String startUpView = '/';
  static const String adminHomeView = '/admin-home-view';
  static const String selectRoleAfterLoginView =
      '/select-role-after-login-view';
  static const String addExplorerView = '/add-explorer-view';
  static const String searchExplorerView = '/search-explorer-view';
  static const String singleExplorerView = '/single-explorer-view';
  static const String transferFundsView = '/transfer-funds-view';
  static const String transfersHistoryView = '/transfers-history-view';
  static const String layoutTemplateView = '/layout-template-view';
  static const String activeQuestView = '/active-quest-view';
  static const String qRCodeView = '/q-rcode-view';
  static const String qRCodeViewExample = '/q-rcode-view-example';
  static const String giftCardView = '/gift-card-view';
  static const all = <String>{
    sponsorHomeView,
    explorerHomeView,
    mapView,
    loginView,
    createAccountView,
    createAccountUserRoleView,
    startUpView,
    adminHomeView,
    selectRoleAfterLoginView,
    addExplorerView,
    searchExplorerView,
    singleExplorerView,
    transferFundsView,
    transfersHistoryView,
    layoutTemplateView,
    activeQuestView,
    qRCodeView,
    qRCodeViewExample,
    giftCardView,
  };
}

class StackedRouter extends RouterBase {
  @override
  List<RouteDef> get routes => _routes;
  final _routes = <RouteDef>[
    RouteDef(Routes.sponsorHomeView, page: SponsorHomeView),
    RouteDef(Routes.explorerHomeView, page: ExplorerHomeView),
    RouteDef(Routes.mapView, page: MapView),
    RouteDef(Routes.loginView, page: LoginView),
    RouteDef(Routes.createAccountView, page: CreateAccountView),
    RouteDef(Routes.createAccountUserRoleView, page: CreateAccountUserRoleView),
    RouteDef(Routes.startUpView, page: StartUpView),
    RouteDef(Routes.adminHomeView, page: AdminHomeView),
    RouteDef(Routes.selectRoleAfterLoginView, page: SelectRoleAfterLoginView),
    RouteDef(Routes.addExplorerView, page: AddExplorerView),
    RouteDef(Routes.searchExplorerView, page: SearchExplorerView),
    RouteDef(Routes.singleExplorerView, page: SingleExplorerView),
    RouteDef(Routes.transferFundsView, page: TransferFundsView),
    RouteDef(Routes.transfersHistoryView, page: TransfersHistoryView),
    RouteDef(Routes.layoutTemplateView, page: LayoutTemplateView),
    RouteDef(Routes.activeQuestView, page: ActiveQuestView),
    RouteDef(Routes.qRCodeView, page: QRCodeView),
    RouteDef(Routes.qRCodeViewExample, page: QRCodeViewExample),
    RouteDef(Routes.giftCardView, page: GiftCardView),
  ];
  @override
  Map<Type, StackedRouteFactory> get pagesMap => _pagesMap;
  final _pagesMap = <Type, StackedRouteFactory>{
    SponsorHomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const SponsorHomeView(),
        settings: data,
      );
    },
    ExplorerHomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ExplorerHomeView(),
        settings: data,
      );
    },
    MapView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const MapView(),
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
    AdminHomeView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const AdminHomeView(),
        settings: data,
      );
    },
    SelectRoleAfterLoginView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const SelectRoleAfterLoginView(),
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
    SingleExplorerView: (data) {
      var args = data.getArgs<SingleExplorerViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => SingleExplorerView(
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
    TransfersHistoryView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const TransfersHistoryView(),
        settings: data,
      );
    },
    LayoutTemplateView: (data) {
      var args = data.getArgs<LayoutTemplateViewArguments>(nullOk: false);
      return MaterialPageRoute<dynamic>(
        builder: (context) => LayoutTemplateView(
          key: args.key,
          childView: args.childView,
        ),
        settings: data,
      );
    },
    ActiveQuestView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const ActiveQuestView(),
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
    GiftCardView: (data) {
      return MaterialPageRoute<dynamic>(
        builder: (context) => const GiftCardView(),
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

/// SingleExplorerView arguments holder class
class SingleExplorerViewArguments {
  final Key? key;
  final String uid;
  SingleExplorerViewArguments({this.key, required this.uid});
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

/// LayoutTemplateView arguments holder class
class LayoutTemplateViewArguments {
  final Key? key;
  final Widget childView;
  LayoutTemplateViewArguments({this.key, required this.childView});
}

/// QRCodeView arguments holder class
class QRCodeViewArguments {
  final Key? key;
  final String? qrCodeString;
  QRCodeViewArguments({this.key, this.qrCodeString});
}
