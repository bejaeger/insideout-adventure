import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/quest_view_index.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/ui/views/admin/admin_user/home/home_view.dart';
import 'package:afkcredits/ui/views/admin/admin_user/markers/add_markers_view.dart';
import 'package:afkcredits/ui/views/explorer_home/explorer_home_view.dart';
import 'package:afkcredits/ui/views/gift_cards/gift_card_view.dart';
import 'package:afkcredits/ui/views/layout/bottom_bar_layout_viewmodel.dart';
import 'package:afkcredits/ui/views/map/map_view.dart';
import 'package:afkcredits/ui/views/quests_overview/quests_overview_view.dart';
import 'package:afkcredits/ui/views/single_quest_type/single_quest_type_view.dart';
import 'package:afkcredits/ui/views/sponsor_home/sponsor_home_view.dart';
import 'package:flutter/material.dart';
import 'package:persistent_bottom_nav_bar/persistent-tab-view.dart';
import 'package:stacked/stacked.dart';

class BottomBarLayoutTemplateView extends StatefulWidget {
  final BottomNavBarIndex? initialBottomNavBarIndex;
  final bool showDialog;
  final UserRole userRole;
  final QuestViewType questViewIndex;
  final Quest? quest;
  final QuestType? questType;

  const BottomBarLayoutTemplateView(
      {Key? key,
      required this.userRole,
      this.initialBottomNavBarIndex,
      this.showDialog = false,
      this.questViewIndex = QuestViewType.questlist,
      this.quest,
      this.questType})
      : super(key: key);

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
        initialIndex: widget.initialBottomNavBarIndex?.index ?? 0);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<BottomBarLayoutTemplateViewModel>.reactive(
      viewModelBuilder: () => BottomBarLayoutTemplateViewModel(),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          if (widget.questViewIndex != QuestViewType.questlist) {
            model.navigateBack();
            return false;
          } else {
            return true;
          }
        },
        child: SafeArea(
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
                  topRight: Radius.circular(16.0),
                  topLeft: Radius.circular(16.0)),
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
            navBarStyle: NavBarStyle
                .style8, // Choose the nav bar style with this property.
          ),
        ),
      ),
    );
  }

  List<Widget> _buildScreens({required UserRole userRole}) {
    switch (userRole) {
      case UserRole.sponsor:
        return [
          SponsorHomeView(),
          GiftCardView(),
        ];
      case UserRole.explorer:
        return [
          ExplorerHomeView(),
          MapView(),
          GiftCardView(),
        ];
      default:
        return [
          HomeView(),
          AddMarkersView(),
        ];
    }

/*     return [
      if (userRole == UserRole.sponsor) SponsorHomeView(),
      //if (userRole == UserRole.admin) AdminHomeView(),
      if (userRole == UserRole.adminMaster) HomeView(), //AddMarkersView(),
      if (userRole == UserRole.explorer) ExplorerHomeView(),

      if (widget.questViewIndex == QuestViewType.questlist)
        QuestsOverviewView(),
      if (widget.questViewIndex == QuestViewType.singlequest)
        SingleQuestTypeView(
          quest: widget.quest,
          questType: widget.questType,
        ),
      if (widget.questViewIndex == QuestViewType.map) MapView(),

      if (userRole == UserRole.explorer) GiftCardView(),
      if (userRole == UserRole.adminMaster) AddMarkersView(),
      //MoneyPoolsView(),
    ]; */
  }

  List<PersistentBottomNavBarItem> _navBarsItems({required UserRole userRole}) {
    switch (userRole) {
      case UserRole.sponsor:
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
            iconSize: kBottomNavigationBarIconSize,
            icon: Icon(Icons.card_giftcard),
            inactiveIcon: Icon(Icons.shop_outlined),

            //title: ("Profile"),
            activeColorPrimary: Colors.white,
            inactiveColorPrimary: Colors.white70,
          ),
        ];
      case UserRole.explorer:
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
          PersistentBottomNavBarItem(
            iconSize: kBottomNavigationBarIconSize,
            icon: Icon(Icons.shop),
            inactiveIcon: Icon(Icons.shop_outlined),

            //title: ("Profile"),
            activeColorPrimary: Colors.white,
            inactiveColorPrimary: Colors.white70,
          ),
        ];
      default:
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
            icon: Icon(Icons.mark_email_read_outlined),
            inactiveIcon: Icon(Icons.mark_chat_read),

            //title: ("Home"),
            iconSize: kBottomNavigationBarIconSize,
            activeColorPrimary: Colors.white,
            inactiveColorPrimary: Colors.white70,
          ),
        ];
    }
/* 
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
      if (userRole == UserRole.adminMaster)
        PersistentBottomNavBarItem(
          iconSize: kBottomNavigationBarIconSize,
          icon: Icon(Icons.mark_as_unread),
          inactiveIcon: Icon(Icons.shop_outlined),

          //title: ("Profile"),
          activeColorPrimary: Colors.white,
          inactiveColorPrimary: Colors.white70,
        ),
    ]; */
  }
}
