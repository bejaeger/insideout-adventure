import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/ui/views/active_screen_time/start_screen_time_counter_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_safe_area.dart';
import 'package:afkcredits/ui/widgets/screen_time_notifications_note.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';

class StartScreenTimeCounterView extends StatelessWidget {
  final ScreenTimeSession session;
  const StartScreenTimeCounterView({Key? key, required this.session})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartScreenTimeCounterViewModel>.reactive(
      viewModelBuilder: () => StartScreenTimeCounterViewModel(),
      onModelReady: (model) => model.startCounter(session: session),
      builder: (context, model, child) => CustomSafeArea(
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Container(
            height: screenHeight(context),
            width: screenWidth(context),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 100),
                InsideOutText.subheading(
                    "${session.minutes.toString()} min screen time starts in"),
                verticalSpaceTiny,
                Text(model.counter.toString() + " s",
                    style: heading2Style.copyWith(fontSize: 60)),
                Spacer(),
                model.isGuardianAccount
                    ? ScreenTimeNotificationsNote()
                    : Container(
                        height: 220,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [ScreenTimeNotificationsNote()],
                        ),
                      ),
                Spacer(),
                InsideOutButton.text(
                  title: "Start immediately",
                  color: kcBlackHeadlineColor,
                  onTap: () => model.startNow(session: session),
                ),
                verticalSpaceRegular,
                InsideOutButton(
                  height: 50,
                  title: "Cancel",
                  onTap: model.cancel,
                  color: kcRed,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
