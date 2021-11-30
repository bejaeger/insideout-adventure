import 'dart:math';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/payments/money_transfer.dart';
import 'package:afkcredits/datamodels/users/public_info/public_user_info.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/views/sponsor_home/sponsor_home_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/money_transfer_list_tile.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/ui/widgets/user_list_tile.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SponsorHomeView extends StatelessWidget {
  const SponsorHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SponsorHomeViewModel>.reactive(
      viewModelBuilder: () => SponsorHomeViewModel(),
      onModelReady: (model) => model.listenToData(),
      fireOnModelReadyOnce: true,
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(title: "Hi Sponsor"),
        body: ListView(
          physics: ScrollPhysics(),
          children: [
            verticalSpaceMedium,
            SectionHeader(
              title: "Sponsored Explorers",
            ),
            verticalSpaceSmall,
            verticalSpaceTiny,
            if (model.supportedExplorers.length == 0)
              model.isBusy
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: model.showAddExplorerBottomSheet,
                      child: Text("Support First Explorer -> "),
                      //imagePath: ImagePath.peopleHoldingHands,
                    ),
            if (model.supportedExplorers.length > 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                child: ExplorersList(
                    explorersStats: model.supportedExplorerStats,
                    explorers: model.supportedExplorers,
                    onExplorerPressed: model.navigateToSingleExplorerView,
                    onAddNewExplorerPressed: model.showAddExplorerBottomSheet),
              ),
            verticalSpaceMedium,
            if (model.latestTransfers.length > 0)
              SectionHeader(
                title: "Recent Payments",
                onTextButtonTap: model.navigateToTransferHistoryView,
              ),
            if (model.latestTransfers.length > 0) verticalSpaceSmall,

            if (model.latestTransfers.length > 0)
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: kHorizontalPadding + 5.0),
                child: LatestTransfersList(
                  transfers: model.latestTransfers,
                  onTilePressed: model.showMoneyTransferInfoDialog,
                ),
              ),
            // _sendMoneyButton(context, model),
            verticalSpaceLarge,
            Divider(),
            verticalSpaceLarge,
            verticalSpaceLarge,
            ElevatedButton(
                // onPressed: model.navigateToExplorerHomeView,
                onPressed: model.logout,
                //child: Text("Go to explorer home/map")),
                child: Text("Logout  ")),
            verticalSpaceLarge,
          ],
        ),
      ),
    );
  }
}

class ExplorersList extends StatelessWidget {
  final List<User> explorers;
  final Map<String, UserStatistics>? explorersStats;

  final void Function() onAddNewExplorerPressed;
  final void Function({required String uid})? onExplorerPressed;

  const ExplorersList({
    Key? key,
    required this.explorers,
    this.explorersStats,
    required this.onAddNewExplorerPressed,
    this.onExplorerPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //scrollDirection: Axis.horizontal,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: min(explorers.length + 1, 10),
      itemBuilder: (context, index) {
        if (index == min(explorers.length, 9)) {
          return Column(
            children: [
              horizontalSpaceMedium,
              ElevatedButton(
                  // onPressed: model.navigateToExplorerHomeView,
                  onPressed: onAddNewExplorerPressed,
                  //child: Text("Go to explorer home/map")),
                  child: Text("Sponsor Another Explorer ->")),
            ],
          );
        } else {
          return Column(
            children: [
              horizontalSpaceSmall,
              UserListTile(
                onTilePressed: onExplorerPressed == null
                    ? null
                    : (
                        [PublicUserInfo? userInfo,
                        UserStatistics? userStats]) async {
                        onExplorerPressed!(uid: userInfo!.uid);
                      },
                // userStats: explorersStats == null || explorersStats?.length == 0
                //     ? null
                //     : explorersStats![explorers[index].uid],
                userInfo: PublicUserInfo(
                  name: explorers[index].fullName,
                  email: explorers[index].email,
                  uid: explorers[index].uid,
                ),
              ),
            ],
          );
        }
      },
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
