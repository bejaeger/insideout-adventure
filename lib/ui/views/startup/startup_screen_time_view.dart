import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/ui/views/startup/startup_viewmodel.dart';
import 'package:afkcredits/ui/widgets/insideout_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:stacked/stacked.dart';

class StartUpScreenTimeView extends StatelessWidget {
  final ScreenTimeSession? screenTimeSession;
  const StartUpScreenTimeView({Key? key, this.screenTimeSession})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      onModelReady: (model) {
        SchedulerBinding.instance.addPostFrameCallback(
          (timeStamp) async {
            await model.runStartupScreenTimeLogic(
                screenTimeSession: screenTimeSession);
          },
        );
      },
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) => Scaffold(
        body: Center(
          child: InsideOutLogo(isBusy: true),
        ),
      ),
    );
  }
}
