import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/image_urls.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/payments/money_transfer.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/views/parent_drawer_view/parent_drawer_view.dart';
import 'package:afkcredits/ui/views/parent_home/parent_home_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/child_stats_card.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/money_transfer_list_tile.dart';
import 'package:afkcredits/ui/widgets/outline_box.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:transparent_image/transparent_image.dart';

class ParentHomeView extends StatelessWidget {
  const ParentHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ParentHomeViewModel>.reactive(
      viewModelBuilder: () => ParentHomeViewModel(),
      onModelReady: (model) => model.listenToData(),
      fireOnModelReadyOnce: true,
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          appBar: CustomAppBar(title: "Home", drawer: true),
          endDrawer: SizedBox(
            width: screenWidth(context, percentage: 0.6),
            child: const ParentDrawerView(),
          ),
          floatingActionButton: Container(
            width: screenWidth(context),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                //verticalSpaceSmall,
                OutlineBox(
                  width: screenWidth(context, percentage: 0.4),
                  height: 60,
                  borderWidth: 0,
                  text: "Create Quest",
                  onPressed: model.navToCreateQuest,
                  color: kDarkTurquoise,
                  textColor: Colors.white,
                ),
                OutlineBox(
                  width: screenWidth(context, percentage: 0.4),
                  height: 60,
                  borderWidth: 0,
                  text: "Switch to Child",
                  onPressed: model.showNotImplementedSnackbar,
                  color: kDarkTurquoise,
                  textColor: Colors.white,
                ),
                //verticalSpaceSmall,
              ],
            ),
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          body: RefreshIndicator(
            onRefresh: () => model.listenToData(),
            child: ListView(
              physics: ScrollPhysics(),
              children: [
                verticalSpaceMedium,
                SectionHeader(
                  title: "History",
                  //onButtonTap: model.navigateToTransferHistoryView,
                ),
                RecentHistory(),
                verticalSpaceMedium,
                SectionHeader(
                  title: "Children",
                  onButtonTap: model.showAddExplorerBottomSheet,
                  buttonIcon: Icon(Icons.add_circle_outline_rounded,
                      size: 28, color: kDarkTurquoise),
                ),
                if (model.supportedExplorers.length == 0)
                  model.isBusy
                      ? AFKProgressIndicator()
                      : Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: ElevatedButton(
                            onPressed: model.showAddExplorerBottomSheet,
                            child: Text("Add Explorer"),
                            //imagePath: ImagePath.peopleHoldingHands,
                          ),
                        ),
                if (model.supportedExplorers.length > 0)
                  ChildrenStatsList(
                    explorersStats: model.supportedExplorerStats,
                    explorers: model.supportedExplorers,
                    onChildCardPressed: model.navigateToSingleExplorerView,
                    // onAddNewExplorerPressed:
                    //     model.showAddExplorerBottomSheet
                  ),
                verticalSpaceMassive,
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class RecentHistory extends StatelessWidget {
  const RecentHistory({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          HistoryItemScreenTime(),
          verticalSpaceTiny,
          HistoryItemActivity(),
        ],
      ),
    );
  }
}

class HistoryItem extends StatelessWidget {
  final List<Widget> children;
  final Color color;
  const HistoryItem({Key? key, required this.children, required this.color})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 70,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: color,
      ),
      child: Padding(
        padding: const EdgeInsets.all(10),
        child:
            Row(mainAxisAlignment: MainAxisAlignment.start, children: children),
      ),
    );
  }
}

class HistoryItemScreenTime extends StatelessWidget {
  const HistoryItemScreenTime({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HistoryItem(color: kNiceBlue.withOpacity(0.5), children: [
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AfkCreditsText.captionBold("Sven"),
          AfkCreditsText.caption("Aug 2"),
        ],
      ),
      horizontalSpaceMedium,
      AfkCreditsText.body("30 min screen time"),
      Spacer(),
      Container(
        width: 60,
        height: 60,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
        ),
        child: FadeInImage.memoryNetwork(
          fadeInDuration: Duration(milliseconds: 200),
          placeholder: kTransparentImage,
          image: kScreenTimeImageUrl,
        ),
      ),
    ]);
  }
}

class HistoryItemActivity extends StatelessWidget {
  const HistoryItemActivity({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return HistoryItem(
      color: kNiceOrange,
      children: [
        Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AfkCreditsText.captionBold("Kevin"),
            AfkCreditsText.caption("Aug 1"),
          ],
        ),
        horizontalSpaceMedium,
        AfkCreditsText.body("walked 1 hour"),
        Spacer(),
        Container(
          width: 60,
          height: 60,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
          ),
          child: FadeInImage.memoryNetwork(
            fadeInDuration: Duration(milliseconds: 200),
            placeholder: kTransparentImage,
            image: kRunningIconUrl,
          ),
        ),
      ],
    );
  }
}

class ChildrenStatsList extends StatelessWidget {
  final List<User> explorers;
  final Map<String, UserStatistics>? explorersStats;

  // final void Function() onAddNewExplorerPressed;
  final void Function({required String uid}) onChildCardPressed;

  const ChildrenStatsList({
    Key? key,
    required this.explorers,
    required this.explorersStats,
    // required this.onAddNewExplorerPressed,
    required this.onChildCardPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        physics: ScrollPhysics(),
        itemCount: explorers.length,
        itemBuilder: (context, index) {
          return Row(
            children: [
              if (index == 0) SizedBox(width: 20),
              GestureDetector(
                onTap: () => onChildCardPressed(uid: explorers[index].uid),
                child: ChildStatsCard(
                    user: explorers[index], childrenStats: explorersStats),
              ),
              if (index == explorers.length - 1) SizedBox(width: 20),
            ],
          );
        },
      ),
    );
  }
}

class LatestTransfersList extends StatelessWidget {
  final List<MoneyTransfer> transfers;
  final void Function(MoneyTransfer)? onTilePressed;
  const LatestTransfersList({
    Key? key,
    required this.transfers,
    this.onTilePressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: Colors.transparent,
        border: Border.all(color: Colors.grey[400]!),
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
        child: ListView.builder(
          shrinkWrap: true,
          physics: ScrollPhysics(),
          itemCount: transfers.length > 3 ? 3 : transfers.length,
          itemBuilder: (context, index) {
            var data = transfers[index];
            return TransferListTile(
              onTap: onTilePressed == null ? null : () => onTilePressed!(data),
              dense: true,
              showBottomDivider: index < 2 && transfers.length > 2,
              showTopDivider: false,
              transaction: data,
              amount: data.transferDetails.amount,
            );
          },
        ),
      ),
    );
  }
}
