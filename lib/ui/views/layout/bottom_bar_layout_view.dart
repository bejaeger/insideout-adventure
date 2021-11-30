import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/ui/views/explorer_home/explorer_home_view.dart';
import 'package:afkcredits/ui/views/gift_cards/gift_card_view.dart';
import 'package:afkcredits/ui/views/map/map_view.dart';
import 'package:afkcredits/ui/views/sponsor_home/sponsor_home_view.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';

class BottomBarLayoutTemplateView extends StatefulWidget {
  final int? initialBottomNavBarIndex;
  final int? initialTabBarIndex;
  final bool showDialog;
  final UserRole userRole;

  const BottomBarLayoutTemplateView({
    Key? key,
    required this.userRole,
    this.initialBottomNavBarIndex,
    this.initialTabBarIndex = 0,
    this.showDialog = false,
  }) : super(key: key);

  @override
  _BottomBarLayoutTemplateViewState createState() =>
      _BottomBarLayoutTemplateViewState();
}

class _BottomBarLayoutTemplateViewState
    extends State<BottomBarLayoutTemplateView> {
  late PersistentTabController _controller;

  @override
  void initState() {
    _controller = PersistentTabController(
        initialIndex: widget.initialBottomNavBarIndex ?? 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: PersistentTabView(
        context,
        controller: _controller,
        screens: _buildScreens(userRole: widget.userRole),
        items: _navBarsItems(userRole: widget.userRole),
        confineInSafeArea: true,

        handleAndroidBackButtonPress: true, // Default is true.
        resizeToAvoidBottomInset:
            true, // This needs to be true if you want to move up the screen when keyboard appears. Default is true.
        stateManagement: true, // Default is true.
        hideNavigationBarWhenKeyboardShows:
            true, // Recommended to set 'resizeToAvoidBottomInset' as true while using this argument. Default is true.
        backgroundColor: kPrimaryColor, // Default is Colors.white.
        decoration: NavBarDecoration(
          boxShadow: [
            BoxShadow(
              color: kGreyTextColor,
              blurRadius: 12.0, // soften the shadow
              spreadRadius: 3, //extend the shadow
              offset: Offset(
                0, // Move to right 10  horizontally
                15.0, // Move to bottom 10 Vertically
              ),
            )
          ],
          borderRadius: BorderRadius.only(
              topRight: Radius.circular(16.0), topLeft: Radius.circular(16.0)),
          colorBehindNavBar: Colors.white,
        ),
        popAllScreensOnTapOfSelectedTab: true,
        popActionScreens: PopActionScreensType.all,
        itemAnimationProperties: ItemAnimationProperties(
          // Navigation Bar's items animation properties.
          duration: Duration(milliseconds: 300),
          curve: Curves.ease,
        ),
        screenTransitionAnimation: ScreenTransitionAnimation(
          // Screen transition animation on change of selected tab.
          animateTabTransition: true,
          curve: Curves.ease,
          duration: Duration(milliseconds: 300),
        ),
        navBarHeight: kBottomNavigationBarHeightCustom,
        navBarStyle:
            NavBarStyle.style8, // Choose the nav bar style with this property.
      ),
    );
  }

  List<Widget> _buildScreens({required UserRole userRole}) {
    return [
      if (userRole == UserRole.sponsor) SponsorHomeView(),
      if (userRole == UserRole.explorer) ExplorerHomeView(),
      MapView(),
      if (userRole == UserRole.explorer) GiftCardView(),
      //MoneyPoolsView(),
    ];
  }

  List<PersistentBottomNavBarItem> _navBarsItems({required UserRole userRole}) {
    return [
      PersistentBottomNavBarItem(
        icon: Icon(Icons.home),
        inactiveIcon: Icon(Icons.home_outlined),

        //title: ("Home"),
        iconSize: kBottomNavigationBarIconSize,
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
      ),
      PersistentBottomNavBarItem(
        icon: Icon(
          Icons.explore,
        ),
        inactiveIcon: Icon(Icons.explore_outlined),
        iconSize: kBottomNavigationBarIconSize,
        //title: ("Projects"),
        activeColorPrimary: Colors.white,
        inactiveColorPrimary: Colors.white70,
      ),
      if (userRole == UserRole.explorer)
        PersistentBottomNavBarItem(
          iconSize: kBottomNavigationBarIconSize,
          icon: Icon(Icons.shop),
          inactiveIcon: Icon(Icons.shop_outlined),

          //title: ("Profile"),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.white70,
        ),
    ];
  }
}
