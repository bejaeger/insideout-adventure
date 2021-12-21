import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/ui/views/map/map_view.dart';
import 'package:afkcredits/ui/views/quests_overview/nearby_quests_list.dart/nearby_quests_list.dart';
import 'package:afkcredits/ui/views/quests_overview/quest_categories_list.dart/quest_categories_list.dart';
import 'package:afkcredits/ui/views/quests_overview/quests_overview_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_floating_action_buttons.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/quest_info_card.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class QuestsOverviewView extends StatefulWidget {
  const QuestsOverviewView({Key? key}) : super(key: key);

  @override
  State<QuestsOverviewView> createState() => _QuestsOverviewViewState();
}

class _QuestsOverviewViewState extends State<QuestsOverviewView>
    with TickerProviderStateMixin {
  late final TabController _tabController;

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuestsOverviewViewModel>.reactive(
      viewModelBuilder: () => QuestsOverviewViewModel(),
      onModelReady: (model) {
        model.initialize();
        _tabController = TabController(
          length: 3,
          vsync: this,
        );
      },
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
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
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
        floatingActionButton: AFKFloatingActionButtons(
          // title1: "SCAN",
          onPressed1: model.scanQrCode,
          iconData1: Icons.qr_code_scanner_rounded,
          // title2: "LIST",
          // onPressed2: model.navigateBack,
          // iconData2: Icons.list_rounded,
        ),
        body: TabBarView(
          physics: NeverScrollableScrollPhysics(),
          controller: _tabController,
          children: [
            model.isBusy
                ? AFKProgressIndicator()
                : NearbyQuestsList(model: model),
            // Icon(Icons.apps),
            model.isBusy ? AFKProgressIndicator() : MapView(),
            model.isBusy
                ? AFKProgressIndicator()
                : QuestsCategoryList(model: model),
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
                    Icon(Icons.near_me, size: 30),
                    Text(
                      "NEARBY",
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
                    Text(
                      "MAPS",
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
                    Icon(Icons.category_rounded, size: 30),
                    FittedBox(
                      fit: BoxFit.contain,
                      child: Text(
                        "CATEGORY",
                        //  maxLines: 1,
                      ),
                    ),
                  ],
                ),
              ),
            )
          ]);
}
