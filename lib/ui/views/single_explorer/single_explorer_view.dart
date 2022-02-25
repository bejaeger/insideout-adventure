import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/single_explorer/single_explorer_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/large_button.dart';
import 'package:afkcredits/ui/widgets/live_quest_statistic.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/ui/widgets/simple_statistics_display.dart';
import 'package:afkcredits/ui/widgets/stats_card.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SingleExplorerView extends StatefulWidget {
  final String uid;
  const SingleExplorerView({Key? key, required this.uid}) : super(key: key);

  @override
  State<SingleExplorerView> createState() => _SingleExplorerViewState();
}

class _SingleExplorerViewState extends State<SingleExplorerView> {
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SingleExplorerViewModel>.reactive(
      viewModelBuilder: () => SingleExplorerViewModel(explorerUid: widget.uid),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
            appBar: AppBar(
              title: Text("Sponsored Explorer"),
            ),
            body: RefreshIndicator(
              onRefresh: model.refresh,
              child: model.isBusy
                  ? AFKProgressIndicator()
                  : ListView(
                      children: [
                        verticalSpaceMedium,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kHorizontalPadding),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  CircleAvatar(
                                    radius: 35,
                                    backgroundColor: kDarkTurquoise,
                                    child: Text(
                                        getInitialsFromName(
                                            model.explorer.fullName),
                                        style: TextStyle(
                                            color: Colors.white, fontSize: 26)),
                                  ),
                                  horizontalSpaceMedium,
                                  Text(model.explorer.fullName,
                                      style: textTheme(context).headline4),
                                ],
                              ),
                              if (model.explorer.createdByUserWithId != null)
                                verticalSpaceSmall,
                              if (model.explorer.createdByUserWithId != null)
                                TextButton(
                                  style: TextButton.styleFrom(
                                    primary: kDarkTurquoise,
                                    padding: EdgeInsets.zero,
                                  ),
                                  onPressed: model.handleSwitchToExplorerEvent,
                                  child: Container(
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                      border: Border.all(color: kDarkTurquoise),
                                    ),
                                    child: Padding(
                                      padding: const EdgeInsets.all(12.0),
                                      child: Text(
                                          "Switch to Children Area \u2192"),
                                    ),
                                  ),
                                ),
                              verticalSpaceMedium,
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 5,
                                    child: Column(
                                      children: [
                                        SimpleStatisticsDisplay(
                                          title: "Total Earned",
                                          statistic: model
                                              .stats.lifetimeEarnings
                                              .toString(),
                                          showCreditsSymbol: true,
                                        ),
                                        verticalSpaceSmall,
                                        Text(
                                            "Equivalent to " +
                                                formatAFKCreditsToActivityHours(
                                                    model.stats
                                                        .lifetimeEarnings) +
                                                " hours of physical activity",
                                            style: textTheme(context)
                                                .headline6!
                                                .copyWith(
                                                    fontSize: 15,
                                                    color: kDarkTurquoise,
                                                    fontStyle:
                                                        FontStyle.italic))
                                      ],
                                    ),
                                  ),
                                  Spacer(),
                                  Flexible(
                                    flex: 5,
                                    child: Column(
                                      children: [
                                        SimpleStatisticsDisplay(
                                          title: "Current balance",
                                          statistic: model
                                              .stats.afkCreditsBalance
                                              .toString(),
                                          showCreditsSymbol: true,
                                        ),
                                        verticalSpaceSmall,
                                        Text("Last mission done on 02/02/2022",
                                            style: textTheme(context)
                                                .headline6!
                                                .copyWith(
                                                    fontSize: 15,
                                                    color: kDarkTurquoise,
                                                    fontStyle:
                                                        FontStyle.italic))
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              verticalSpaceMedium,
                              Divider(thickness: 2),
                            ],
                          ),
                        ),
                        SectionHeader(title: "Current Sponsoring"),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kHorizontalPadding),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Flexible(
                                    flex: 5,
                                    child: SimpleStatisticsDisplay(
                                      statistic: formatAfkCreditsFromCents(
                                          model.stats.availableSponsoring),
                                      showCreditsSymbol: true,
                                      dollarValue: formatDollarFromCents(
                                          model.stats.availableSponsoring),
                                    ),
                                  ),
                                  Spacer(),
                                  Flexible(
                                    flex: 5,
                                    child: LargeButton(
                                        backgroundColor: Colors.transparent,
                                        titleColor: kDarkTurquoise,
                                        onPressed: model.navigateToAddFundsView,
                                        fontSize: 16,
                                        withBorder: true,
                                        title: "Sponsor Activities"),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                        verticalSpaceMedium,
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kHorizontalPadding),
                          child: Divider(thickness: 2),
                        ),
                        SectionHeader(title: "Stats"),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: kHorizontalPadding),
                          child: Column(
                            children: [
                              ExpansionTile(
                                title: Text(model.stats.numberQuestsCompleted
                                    .toString()),
                                subtitle: Text("Quests completed"),
                                expandedAlignment: Alignment.centerLeft,
                                children: [
                                  verticalSpaceSmall,
                                  Text("Last quest"),
                                  Text("01/01/2022"),
                                  verticalSpaceSmall,
                                ],
                              ),
                              ExpansionTile(
                                title: Text(model.stats.numberGiftCardsPurchased
                                    .toString()),
                                subtitle: Text("Screen time rewards"),
                                expandedAlignment: Alignment.centerLeft,
                                children: [
                                  verticalSpaceSmall,
                                  verticalSpaceSmall,
                                ],
                              ),
                              ExpansionTile(
                                title: Text(model.stats.numberGiftCardsPurchased
                                    .toString()),
                                subtitle: Text("Gift cards purchased"),
                                expandedAlignment: Alignment.centerLeft,
                                children: [
                                  verticalSpaceSmall,
                                  verticalSpaceSmall,
                                ],
                              ),
                            ],
                          ),
                        ),
                        verticalSpaceMedium,
                        verticalSpaceMedium,
                      ],
                    ),
            )),
      ),
    );
  }
}
