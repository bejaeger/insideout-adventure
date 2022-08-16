import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/enums/screen_time_session_status.dart';
import 'package:afkcredits/ui/views/active_screen_time/active_screen_time_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/ui/widgets/main_long_button.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

class ActiveScreenTimeView extends StatelessWidget {
  final ScreenTimeSession? session;
  final String? screenTimeSessionId;
  const ActiveScreenTimeView(
      {Key? key, required this.session, this.screenTimeSessionId})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveScreenTimeViewModel>.reactive(
      onModelReady: (model) {
        model.initialize();
      },
      viewModelBuilder: () => ActiveScreenTimeViewModel(
          session: session, screenTimeSessionId: screenTimeSessionId),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 40, bottom: 40),
              child: model.isBusy
                  ? AFKProgressIndicator()
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        // Display the following when screen time is still active!
                        if (model.currentScreenTimeSession?.status ==
                            ScreenTimeSessionStatus.active)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              AfkCreditsText.headingOne("Screen Time Active"),
                              verticalSpaceMassive,
                              AfkCreditsText.subheading("Time left"),
                              verticalSpaceTiny,
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Lottie.network(
                                      'https://assets8.lottiefiles.com/packages/lf20_wTfKKa.json',
                                      height: 45),
                                  if (model.screenTimeLeft! > 0)
                                    AfkCreditsText.headingTwo(
                                      secondsToMinuteSecondTime(
                                          model.screenTimeLeft),
                                    )
                                  /*                     else
                        Expanded(
                          child: AlertDialog(
                            title: const Text("Time is up"),
                            content: const Text(
                                "You Managed to Finish Your screen time"),
                            actions: <Widget>[
                              // CupertinoDialogAction(child: child)
                              ElevatedButton(
                                onPressed: () {
                                  model.stopScreenTimeAfterZero();
                                  //model.stopScreenTime();
                                  //Navigator.of(context).pop();
                                },
                                child: const Text("ok"),
                              ),
                            ],
                          ),
                        ) */
                                ],
                              ),
                            ],
                          ),
                        // Display the following when screen time is over!
                        if (model.currentScreenTimeSession?.status ==
                            ScreenTimeSessionStatus.completed)
                          Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Align(
                                  alignment: Alignment.center,
                                  child: AfkCreditsText.headingOne(
                                      "Screen Time Over")),
                              verticalSpaceMassive,
                              AfkCreditsText.subheading("Time used"),
                              AfkCreditsText.body(secondsToMinuteSecondTime(
                                  model.currentScreenTimeSession!.minutesUsed! *
                                      60)),
                              verticalSpaceSmall,
                              AfkCreditsText.subheading("Credits used"),
                              AfkCreditsText.body(model
                                  .currentScreenTimeSession!.afkCreditsUsed
                                  .toString())
                            ],
                          ),
                        Spacer(),
                        Lottie.network(
                            'https://assets8.lottiefiles.com/packages/lf20_l3jzffol.json',
                            height: 200),
                        Spacer(),
                        MainLongButton(
                            onTap: model.currentScreenTimeSession?.status ==
                                    ScreenTimeSessionStatus.completed
                                ? model.replaceWithHomeView
                                : model.stopScreenTime,
                            title: model.currentScreenTimeSession?.status ==
                                    ScreenTimeSessionStatus.completed
                                ? "Go Back"
                                : "Stop screen time",
                            color: model.currentScreenTimeSession?.status ==
                                    ScreenTimeSessionStatus.completed
                                ? kcPrimaryColor
                                : kcRed),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
