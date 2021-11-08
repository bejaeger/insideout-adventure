import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/single_explorer/single_explorer_viewmodel.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/ui/widgets/stats_card.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SingleExplorerView extends StatelessWidget {
  final String uid;
  const SingleExplorerView({Key? key, required this.uid}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleExplorerViewModel>.reactive(
      viewModelBuilder: () => SingleExplorerViewModel(uid: uid),
      builder: (context, model, child) => Scaffold(
          appBar: AppBar(
            title: Text("Sponsored Explorer"),
          ),
          body: RefreshIndicator(
            onRefresh: model.refresh,
            child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                child: ListView(
                  children: [
                    verticalSpaceMedium,
                    Text(model.explorer.fullName,
                        style: textTheme(context).headline4),
                    verticalSpaceMedium,
                    Column(
                      children: [
                        StatsCard(
                          height: 80,
                          statistic: model.stats.lifetimeEarnings.toString(),
                          subtitle: "Earned AFK Credits",
                        ),
                        StatsCard(
                          height: 80,
                          subtitle: "Spent AFK Credits",
                          statistic: model.stats.afkCreditsSpent.toString(),
                        ),
                        StatsCard(
                          height: 80,
                          subtitle: "Available Sponsoring",
                          statistic:
                              formatAmount(model.stats.availableSponsoring),
                          statisticCredits: formatAfkCreditsFromCents(
                              model.stats.availableSponsoring),
                        ),
                        StatsCard(
                          height: 80,
                          subtitle: "Gift Cards Purchased",
                          statistic:
                              model.stats.numberGiftCardsPurchased.toString(),
                        ),
                      ],
                    ),
                    verticalSpaceMedium,
                    ElevatedButton(
                        onPressed: model.navigateToAddFundsView,
                        child: Text("Sponsor ${model.explorer.fullName}")),
                    verticalSpaceMedium,
                    ElevatedButton(
                        onPressed: model.showNotImplementedSnackbar,
                        child: Text("Switch to Explorer Version")),
                    verticalSpaceMedium,
                    SectionHeader(title: "Completed Quests"),
                    Text("    ... "),
                  ],
                )),
          )),
    );
  }
}
