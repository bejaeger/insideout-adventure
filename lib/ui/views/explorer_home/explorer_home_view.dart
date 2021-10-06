import 'package:afkcredits/constants/app_strings.dart';
import 'package:afkcredits/datamodels/users/statistics/user_statistics.dart';
import 'package:afkcredits/ui/views/explorer_home/explorer_home_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ExplorerHomeView extends StatelessWidget {
  const ExplorerHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExplorerHomeViewModel>.reactive(
      viewModelBuilder: () => ExplorerHomeViewModel(),
      onModelReady: (model) => model.listenToData(),
      fireOnModelReadyOnce: true,
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(
          title: "Hi Explorer!",
        ),
        body: model.isBusy
            ? CircularProgressIndicator()
            : ListView(
                children: [
                  verticalSpaceMassive,
                  ExplorerCreditStats(
                    userStats: model.currentUserStats,
                  ),
                  verticalSpaceLarge,
                  ElevatedButton(
                      // onPressed: model.navigateToExplorerHomeView,
                      onPressed: model.logout,
                      //child: Text("Go to explorer home/map")),
                      child: Text("Logout  ")),
                ],
              ),
      ),
    );
  }
}

class ExplorerCreditStats extends StatelessWidget {
  final UserStatistics userStats;
  const ExplorerCreditStats({Key? key, required this.userStats})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Column(
                children: [
                  Text(userStats.availableSponsoring.toString(),
                      style: textTheme(context).headline4),
                  Icon(Icons.lock),
                  Text(
                    kCreditsToEarnDescription,
                  ),
                ],
              ),
            ),
            Spacer(),
            Flexible(
              child: Column(
                children: [
                  Text(userStats.afkCredits.toString(),
                      style: textTheme(context).headline4),
                  Icon(Icons.lock_open),
                  Text(
                    kCurrentAFKCreditsDescription,
                  ),
                ],
              ),
            ),
          ],
        ),
        verticalSpaceMedium,
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Flexible(
              child: Column(
                children: [
                  Text(userStats.lifetimeEarnings.toString(),
                      style: textTheme(context).headline4),
                  Icon(Icons.lock_open),
                  Text(
                    kLifetimeEarningsDescription,
                  ),
                ],
              ),
            ),
            Spacer(),
            Flexible(
              child: Column(
                children: [
                  Text(userStats.completedQuests.length.toString(),
                      style: textTheme(context).headline4),
                  Icon(Icons.map),
                  Text(
                    kNumberCompletedQuestsDescription,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
