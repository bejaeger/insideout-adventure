import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/ui/views/quests_overview/quests_overview_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_floating_action_buttons.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class QuestsOverviewView extends StatefulWidget {
  const QuestsOverviewView({Key? key}) : super(key: key);

  @override
  State<QuestsOverviewView> createState() => _QuestsOverviewViewState();
}

class _QuestsOverviewViewState extends State<QuestsOverviewView> {
  TabBar get _tabbar => TabBar(
          unselectedLabelColor: kBlackHeadlineColor,
          labelColor: kWhiteTextColor,
          indicatorSize: TabBarIndicatorSize.tab,
          indicator: BoxDecoration(
              gradient: LinearGradient(colors: [kPrimaryColor, kDarkTurquoise]),
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
                    Text(
                      "CATEGORIES",
                    ),
                  ],
                ),
              ),
            ),
          ]);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuestsOverviewViewModel>.reactive(
        viewModelBuilder: () => QuestsOverviewViewModel(),
        onModelReady: (model) => model.initialize(),
        builder: (context, model, child) => DefaultTabController(
            length: 3,
            child: Scaffold(
              appBar: AppBar(
                title: Text("Quests"),
                backgroundColor: kPrimaryColor,
                elevation: 0,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(12.0),
                    bottomRight: Radius.circular(12.0),
                  ),
                ),
                bottom: PreferredSize(
                  preferredSize: Size(_tabbar.preferredSize.width,
                      _tabbar.preferredSize.height + 20),
                  child: Container(
                      padding: const EdgeInsets.only(
                          left: 8.0, right: 8.0, top: 15.0, bottom: 5.0),
                      color: Colors.grey[50],
                      child: _tabbar),
                ),
              ),
              body: TabBarView(children: [
                Icon(Icons.apps),
                Icon(Icons.movie),
                Icon(Icons.games),
              ]),
            ))

        // Scaffold(
        //   appBar: CustomAppBar(
        //     title: "Quests Overview",
        //   ),
        //   floatingActionButton: AFKFloatingActionButtons(
        //     //title1: "SCAN",
        //     title2: "MAP",
        //     onPressed1: model.scanQrCode,
        //     iconData1: Icons.qr_code_scanner_rounded,
        //     onPressed2: model.navigateToMapView,
        //     iconData2: Icons.map,
        //   ),
        //   body: model.isBusy
        //       ? AFKProgressIndicator()
        //       : ListView(
        //           children: [
        //             verticalSpaceMedium,
        //             // Row(
        //             //   mainAxisAlignment: MainAxisAlignment.spaceAround,
        //             //   children: [
        //             //     ElevatedButton(
        //             //         onPressed: model.scanQrCode,
        //             //         child: Text("Scan Marker",
        //             //             style: textTheme(context)
        //             //                 .headline5!
        //             //                 .copyWith(color: kWhiteTextColor))),
        //             //     ElevatedButton(
        //             //         onPressed: model.navigateToMapView,
        //             //         child: Text("Show Map",
        //             //             style: textTheme(context)
        //             //                 .headline5!
        //             //                 .copyWith(color: kWhiteTextColor))),
        //             //   ],
        //             // ),
        //             // verticalSpaceLarge,
        //             // SectionHeader(title: "Quest Categories"),
        //             // verticalSpaceSmall,
        //             Padding(
        //               padding: const EdgeInsets.symmetric(
        //                   horizontal: kHorizontalPadding),
        //               child: GridView.count(
        //                 shrinkWrap: true,
        //                 crossAxisCount: 2,
        //                 crossAxisSpacing: 10,
        //                 mainAxisSpacing: 10,
        //                 physics:
        //                     NeverScrollableScrollPhysics(), // to disable GridView's scrolling
        //                 children: [
        //                   ...model.questTypes
        //                       .map(
        //                         (e) => QuestCategoryCard(
        //                           onPressed:
        //                               model.navigateToQuestsOfSpecificTypeView,
        //                           category: e,
        //                           backgroundColor: getColorOfType(e),
        //                         ),
        //                       )
        //                       .toList(),
        //                   // QuestCategoryCard(
        //                   //     onPressed: model.navigateToQuestsOfSpecificTypeView,
        //                   //     category: QuestType.DistanceEstimate)
        //                 ],
        //               ),
        //             ),
        //           ],
        //         ),
        // ),
        );
  }

  Color getColorOfType(QuestType type) {
    if (type == QuestType.TreasureLocationSearch)
      return Colors.orange;
    else if (type == QuestType.Hike) {
      return Colors.red;
    } else if (type == QuestType.DistanceEstimate) {
      return Colors.blue;
    } else {
      return Colors.cyan;
    }
  }
}

class QuestCategoryCard extends StatelessWidget {
  final void Function(QuestType) onPressed;
  final QuestType category;
  final Color? backgroundColor;
  const QuestCategoryCard({
    Key? key,
    required this.onPressed,
    required this.category,
    this.backgroundColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onPressed(category),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 1,
                      color: Colors.black26,
                      offset: Offset(3, 3),
                    )
                  ]),
              // width: 180,
              // height: 180,
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: FittedBox(
                fit: BoxFit.contain,
                child: Text(describeEnum(category.toString()),
                    style: textTheme(context)
                        .headline6!
                        .copyWith(color: Colors.grey[200])),
              ))),
        ));
  }
}
