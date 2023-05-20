import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/widgets/summary_stats_display.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked_services/stacked_services.dart';

class WardTotalStatsCardDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const WardTotalStatsCardDialog(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 5,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Colors.white,
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.only(
              top: 20.0, left: 20.0, right: 20.0, bottom: 10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              InsideOutText.headingThree("Summary stats"),
              verticalSpaceMedium,
              verticalSpaceSmall,
              SummaryStatsDisplay(
                icon: Image.asset(kAFKCreditsLogoPath,
                    color: kcPrimaryColor, height: 25),
                stats: request.data.lifetimeEarnings.toString(),
                title: "Total collected",
              ),
              verticalSpaceMedium,
              horizontalSpaceSmall,
              SummaryStatsDisplay(
                icon: Image.asset(kActivityIcon,
                    color: kcActivityIconColor, height: 25),
                stats: request.data.numberQuestsCompleted.toString(),
                title: "Completed quests",
              ),
              verticalSpaceMedium,
              SummaryStatsDisplay(
                icon: Image.asset(kScreenTimeIcon,
                    color: kcScreenTimeBlue, height: 25),
                stats: request.data.totalScreenTime.toString(),
                title: "Total screen time",
                unit: "min",
              ),
              verticalSpaceSmall,
              Row(
                children: [
                  Spacer(),
                  TextButton(
                    child: InsideOutText.body("Ok", color: kcPrimaryColor),
                    onPressed: () => completer(DialogResponse(confirmed: true)),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
