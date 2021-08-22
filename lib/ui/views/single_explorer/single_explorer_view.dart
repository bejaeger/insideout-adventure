import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/single_explorer/single_explorer_viewmodel.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/ui/widgets/stats_card.dart';
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
                    Text(model.user!.fullName,
                        style: textTheme(context).headline4),
                    verticalSpaceMedium,
                    Row(
                      children: [
                        Expanded(
                            child: StatsCard(
                          height: 80,
                          statistic: model.stats!.afkCredits,
                          subtitle: "Earned AFK Credits",
                        )),
                        horizontalSpaceMedium,
                        Expanded(
                            child: StatsCard(
                          height: 80,
                          subtitle: "Available Sponsoring",
                          statistic: model.stats!.availableSponsoring,
                        ))
                      ],
                    ),
                    verticalSpaceMedium,
                    ElevatedButton(
                        onPressed: model.navigateToAddFundsView,
                        child: Text("Add Sponsored Funds")),
                    verticalSpaceMedium,
                    ElevatedButton(
                        onPressed: model.showNotImplementedSnackbar,
                        child: Text("Switch to Explorer View")),
                    verticalSpaceMedium,
                    SectionHeader(title: "Completed Quests"),
                    Text("    ... "),
                  ],
                )),
          )),
    );
  }
}
