import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/ui/views/map/map_overview_view.dart';
import 'package:afkcredits/ui/views/quests_overview/quest_lists.dart';
import 'package:afkcredits/ui/views/quests_overview/quests_overview_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class QuestsOverviewView extends StatefulWidget {
  const QuestsOverviewView({Key? key}) : super(key: key);

  @override
  State<QuestsOverviewView> createState() => _QuestsOverviewViewState();
}

class _QuestsOverviewViewState extends State<QuestsOverviewView>
// In my opnion, This view should be called quest_categories
    with
        TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuestsOverviewViewModel>.reactive(
      viewModelBuilder: () => QuestsOverviewViewModel(),
      onModelReady: (model) {
        model.initializeQuests();
        _tabController = TabController(
          length: 2,
          vsync: this,
        );
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          leading: model.isAdminMaster
              ? GestureDetector(onTap: model.logout, child: Text("Logout"))
              : model.isSuperUser
                  ? GestureDetector(
                      onTap: model.openSuperUserSettingsDialog,
                      child: Text("Super User"))
                  : null,
          title: Text(
            "Quests",
            style:
                textTheme(context).headline5!.copyWith(color: kWhiteTextColor),
          ),
          // backgroundColor: kPrimaryColor,
          // elevation: 0,
          // shape: RoundedRectangleBorder(
          //   borderRadius: BorderRadius.only(
          //     bottomLeft: Radius.circular(12.0),
          //     bottomRight: Radius.circular(12.0),
          //   ),
          // ),
          bottom: PreferredSize(
            preferredSize:
                Size(_tabbar.preferredSize.width, _tabbar.preferredSize.height),
            child: Container(
                padding: const EdgeInsets.only(
                    left: 8.0, right: 8.0, top: 5.0, bottom: 10.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16.0),
                    bottomRight: Radius.circular(16.0),
                  ),
                  color: kPrimaryColor,
                ),
                child: _tabbar),
          ),
        ),
        // floatingActionButton: AFKFloatingActionButtons(
        //   // title1: "SCAN",
        //   onPressed1: model.scanQrCode,
        //   iconData1: Icons.qr_code_scanner_rounded,
        //   // title2: "LIST",
        //   // onPressed2: model.navigateBack,
        //   // iconData2: Icons.list_rounded,
        // ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            model.isBusy ? AFKProgressIndicator() : QuestLists(model: model),
            // Icon(Icons.apps),
            model.isBusy ? AFKProgressIndicator() : MapOverviewView(),
            // model.isBusy
            //     ? AFKProgressIndicator()
            //     : QuestsCategoryList(model: model),
          ],
        ),
      ),
    );
  }

  TabBar get _tabbar => TabBar(
          // isScrollable: true,
          controller: _tabController,
          unselectedLabelColor: Colors.white70,
          labelColor: kWhiteTextColor,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
              gradient:
                  LinearGradient(colors: [kDarkTurquoise, kDarkTurquoise]),
              borderRadius: BorderRadius.circular(50),
              color: kPrimaryColor),
          tabs: [
            Tab(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 1,
                      child: Icon(Icons.list_rounded, size: 30),
                    ),
                    Text(
                      "List",
                    ),
                  ],
                ),
              ),
            ),
            Tab(
              child: Align(
                alignment: Alignment.center,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.map_rounded, size: 30),
                    Expanded(
                      flex: 1,
                      child: Text(
                        "Map",
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Tab(
            //   child: Align(
            //     alignment: Alignment.center,
            //     child: Column(
            //       mainAxisAlignment: MainAxisAlignment.center,
            //       children: [
            //         Icon(Icons.category_rounded, size: 30),
            //         FittedBox(
            //           fit: BoxFit.contain,
            //           child: Text(
            //             "CATEGORY",
            //             //  maxLines: 1,
            //           ),
            //         ),
            //       ],
            //     ),
            //   ),
            // )
          ]);
}
