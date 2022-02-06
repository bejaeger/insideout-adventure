import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
import 'package:afkcredits/enums/bottom_nav_bar_index.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/enums/quest_view_index.dart';
import 'package:afkcredits/enums/user_role.dart';
import 'package:afkcredits/ui/views/admin/admin_user/markers/add_markers_view.dart';
import 'package:afkcredits/ui/views/explorer_home/explorer_home_view.dart';
import 'package:afkcredits/ui/views/gift_cards/gift_card_view.dart';
import 'package:afkcredits/ui/views/layout/bottom_bar_layout_viewmodel.dart';
import 'package:afkcredits/ui/views/map/map_view.dart';
import 'package:afkcredits/ui/views/purchased_gift_cards/manage_gift_cards/manage_gift_cards_view.dart';
import 'package:afkcredits/ui/views/quests_overview/create_quest/create_quest_view.dart';
import 'package:afkcredits/ui/views/quests_overview/quests_overview_view.dart';
import 'package:afkcredits/ui/views/single_quest_type/single_quest_type_view.dart';
import 'package:afkcredits/ui/views/sponsor_home/sponsor_home_view.dart';
import 'package:afkcredits/ui/widgets/afk_floating_action_buttons.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
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
                  color: kShadowColor,
                  blurRadius: 5.0, // soften the shadow
                  spreadRadius: 1, //extend the shadow
                  offset: Offset(
                    1, // Move to right 10  horizontally
                    2, // Move to bottom 10 Vertically
                  ),
                )
              ],
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(16.0),
                topLeft: Radius.circular(16.0),
              ),
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
              duration: Duration(milliseconds: 200),
            ),
            navBarHeight: kBottomNavigationBarHeightCustom,
            padding: const NavBarPadding.only(top: 4.0, bottom: 4),
            floatingActionButton: model.currentUser.role != UserRole.sponsor &&
                    model.currentUser.role != UserRole.adminMaster
                ? AFKFloatingActionButtons(
                    // title1: "SCAN",
                    onPressed1: model.scanQrCode,
                    iconData1: Icons.qr_code_scanner_rounded,
                    // title2: "LIST",
                    // onPressed2: model.navigateBack,
                    // iconData2: Icons.list_rounded,
                  )
                : null,

            navBarStyle: NavBarStyle
                .simple, // Choose the nav bar style with this property.
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
          if (widget.questViewIndex == QuestViewType.questlist)
            QuestsOverviewView(),
          if (widget.questViewIndex == QuestViewType.singlequest)
            SingleQuestTypeView(
              quest: widget.quest,
              questType: widget.questType,
            ),
          if (widget.questViewIndex == QuestViewType.map) MapView(),
        ];
      case UserRole.explorer:
        return [
          ExplorerHomeView(),
          if (widget.questViewIndex == QuestViewType.questlist)
            QuestsOverviewView(),
          if (widget.questViewIndex == QuestViewType.singlequest)
            SingleQuestTypeView(
              quest: widget.quest,
              questType: widget.questType,
            ),
          if (widget.questViewIndex == QuestViewType.map) MapView(),
          GiftCardView(),
        ];
      case UserRole.superUser:
        return [
          ExplorerHomeView(),
          if (widget.questViewIndex == QuestViewType.questlist)
            QuestsOverviewView(),
          if (widget.questViewIndex == QuestViewType.singlequest)
            SingleQuestTypeView(
              quest: widget.quest,
              questType: widget.questType,
            ),
          if (widget.questViewIndex == QuestViewType.map) MapView(),
          GiftCardView(),
        ];
      default:
        return [
          if (widget.questViewIndex == QuestViewType.questlist)
            QuestsOverviewView(),
          if (widget.questViewIndex == QuestViewType.singlequest)
            SingleQuestTypeView(
              quest: widget.quest,
              questType: widget.questType,
            ),
          if (widget.questViewIndex == QuestViewType.map) MapView(),
          // ManageQuestView(),
/*
          if (widget.questViewIndex == QuestViewType.questlist)
            QuestsOverviewView(),

          if (widget.questViewIndex == QuestViewType.singlequest)
            SingleQuestTypeView(
              quest: widget.quest,
              questType: widget.questType,
            ), */

          ManageGiftCardstView(),
          //AddGiftCardsView(),
          AddMarkersView(),
        ];
    }
  }

  List<PersistentBottomNavBarItem> _navBarsItems({required UserRole userRole}) {
    switch (userRole) {
      case UserRole.sponsor:
        return [
          AFKNavBarItem(
            icon: Icon(Icons.home),
            inactiveIcon: Icon(Icons.home_outlined),
            title: "Home",
          ),
          AFKNavBarItem(
            icon: Icon(Icons.explore),
            inactiveIcon: Icon(Icons.explore_outlined),
            title: "Quests",
          ),
        ];
      case UserRole.explorer:
        return [
          AFKNavBarItem(
            icon: Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Icon(Icons.home),
            ),
            inactiveIcon: Icon(Icons.home_outlined),
            title: "Home",
          ),
          AFKNavBarItem(
            icon: Icon(
              Icons.explore,
            ),
            inactiveIcon: Icon(Icons.explore_outlined),
            title: "Quests",
          ),
          AFKNavBarItem(
            icon: Icon(Icons.shop),
            inactiveIcon: Icon(Icons.shop_outlined),
            title: "Rewards",
          ),
        ];
      case UserRole.superUser:
        return [
          AFKNavBarItem(
            icon: Icon(Icons.home),
            inactiveIcon: Icon(Icons.home_outlined),
            title: "Home",
          ),
          AFKNavBarItem(
            icon: Icon(Icons.explore), //, color: kPrimaryColor),
            inactiveIcon: Icon(Icons
                .explore_outlined), //, color: kPrimaryColor.withOpacity(0.7)),
            //inactiveColorPrimary: Colors.grey[200],
            // activeColorPrimary: Colors.grey[100],
            // activeColorSecondary: Colors.white,
            // iconSize: 40,
            title: "Quests",
          ),
          AFKNavBarItem(
            //iconSize: kBottomNavigationBarIconSize,
            icon: Icon(Icons.shop),
            inactiveIcon: Icon(Icons.shop_outlined),
            title: "Rewards",
          ),
        ];
      default:
        return [
          AFKNavBarItem(
            icon: Icon(Icons.explore),
            inactiveIcon: Icon(Icons.explore_outlined),
            title: "Quest",
            displayView: CreateQuestView(),
          ),
/*           AFKNavBarItem(
            icon: Icon(
              Icons.explore,
            ),
            inactiveIcon: Icon(Icons.explore_outlined),
            title: ("Quests"),
          ), */
          /*        AFKNavBarItem(
            icon: Icon(Icons.mark_email_read_outlined),
            inactiveIcon: Icon(Icons.mark_chat_read),
            title: ("Add Markers"),
          ), */
          AFKNavBarItem(
            icon: Icon(Icons.shop),
            inactiveIcon: Icon(Icons.shop_outlined),
            title: "Rewards",
          ),
          AFKNavBarItem(
            icon: Icon(Icons.mark_as_unread_sharp),
            inactiveIcon: Icon(Icons.markunread_sharp),
            title: "Markers",
          ),

          /*      AFKNavBarItem(
            icon: Icon(Icons.note_add),
            inactiveIcon: Icon(Icons.note_add_outlined),
            title: ("Create Quest"),
          ), */
        ];
    }
  }

  PersistentBottomNavBarItem AFKNavBarItem(
      {required Widget icon,
      Widget? displayView,
      required Widget inactiveIcon,
      required String title,
      double? iconSize,
      Color? activeColorPrimary,
      Color? activeColorSecondary,
      Color? inactiveColorPrimary}) {
    return PersistentBottomNavBarItem(
      icon: icon,
      inactiveIcon: inactiveIcon,
      title: title,
      // textStyle:
      //     textTheme(context).headline6!.copyWith(height: 0.1, fontSize: 15),
      textStyle: textTheme(context).headline6!.copyWith(fontSize: 15),
      iconSize: iconSize ?? kBottomNavigationBarIconSize,
      activeColorPrimary: activeColorPrimary ?? Colors.white,
      activeColorSecondary: activeColorSecondary ?? Colors.white,
      inactiveColorPrimary: inactiveColorPrimary ?? Colors.white70,
      routeAndNavigatorSettings: RouteAndNavigatorSettings(
        initialRoute: '/',
        routes: {
          '/displayView': (context) => displayView ?? CreateQuestView(),
          // '/second': (context) => MainScreen3(),
        },
      ),
    );
  }
}
