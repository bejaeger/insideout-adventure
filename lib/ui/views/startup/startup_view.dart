import 'package:afkcredits/ui/views/startup/startup_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/stats_card.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      onModelReady: (model) => model.runStartupLogic(),
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) => model.showLoadingScreen()
          ? Scaffold(
              body: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // AFKCreditsIcon(height: 170),
                    // verticalSpaceSmall,
                    Text("HERCULES",
                        style: textTheme(context)
                            .headline6!
                            .copyWith(fontSize: 36, color: kcOrange)),
                    Text("WORLD",
                        style: textTheme(context)
                            .headline6!
                            .copyWith(fontSize: 60, color: kcOrangeYellow)),
                    verticalSpaceMedium,
                    AFKProgressIndicator(
                      linear: false,
                      color: kcOrange,
                    ),
                  ],
                ),
              ),
            )
          : Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Failure to log in",
                          style: textTheme(context).headline2),
                      verticalSpaceMedium,
                      Text(
                          "Unfortunately, there was an error when logging. Please contact our support"),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
