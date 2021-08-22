// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedRouterGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import '../enums/user_role.dart';
import '../ui/views/add_explorer/add_explorer_view.dart';
import '../ui/views/admin/admin_home_view.dart';
import '../ui/views/create_account/create_account_user_role_view.dart';
import '../ui/views/create_account/create_account_view.dart';
import '../ui/views/explorer_home/explorer_home_view.dart';
import '../ui/views/login/login_view.dart';
import '../ui/views/login/select_role_after_login_view.dart';
import '../ui/views/map/map_view.dart';
import '../ui/views/search_explorer/search_explorer_view.dart';
import '../ui/views/single_explorer/single_explorer_view.dart';
import '../ui/views/sponsor_home/sponsor_home_view.dart';
import '../ui/views/startup/startup_view.dart';

class Routes {
  static const String sponsorHomeView = '/sponsor-home-view';
  static const String explorerHomeView = '/explorer-home-view';
  static const String mapView = '/map-view';
  static const String loginView = '/login-view';
  static const String createAccountView = '/create-account-view';
  static const String createAccountUserRoleView =
      '/create-account-user-role-view';
  static const String startUpView = '/start-up-view';
  static const String adminHomeView = '/admin-home-view';
  static const String selectRoleAfterLoginView =
      '/select-role-after-login-view';
  static const String addExplorerView = '/add-explorer-view';
  static const String searchExplorerView = '/search-explorer-view';
  static const String singleExplorerView = '/single-explorer-view';
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
