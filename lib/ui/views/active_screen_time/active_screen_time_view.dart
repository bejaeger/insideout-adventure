import 'package:afkcredits/ui/views/active_screen_time/active_screen_time_viewmodel.dart';
import 'package:afkcredits/ui/widgets/main_long_button.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

class ActiveScreenTimeView extends StatelessWidget {
  final int minutes;
  const ActiveScreenTimeView({Key? key, required this.minutes})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveScreenTimeViewModel>.reactive(
      viewModelBuilder: () => ActiveScreenTimeViewModel(minutes: minutes),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 40, bottom: 40),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.center,
                      child: AfkCreditsText.headingOne("Active Screen Time")),
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
                          model.screenTimeLeft.toString() + " seconds",
                        )
                      else
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
                        )
                    ],
                  ),
                  Spacer(),
                  Lottie.network(
                      'https://assets8.lottiefiles.com/packages/lf20_l3jzffol.json',
                      height: 200),
                  Spacer(),
                  MainLongButton(
                      onTap: model.stopScreenTime,
                      title: "Stop screen time",
                      color: Colors.red),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
