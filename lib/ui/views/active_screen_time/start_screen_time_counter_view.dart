import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/active_screen_time/start_screen_time_counter_viewmodel.dart';
import 'package:afkcredits/ui/widgets/screen_time_notifications_note.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
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
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: Container(
            height: screenHeight(context),
            width: screenWidth(context),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 100),
                AfkCreditsText.subheading(
                    "${session.minutes.toString()} min screen time starts in"),
                verticalSpaceTiny,
                Text(model.counter.toString() + " s",
                    style: heading2Style.copyWith(fontSize: 60)),
                Spacer(),
                model.isParentAccount
                    ? ScreenTimeNotificationsNote()
                    : Container(
                        height: 220,
                        //color: Colors.red,
                        child: Column(
                          mainAxisSize: MainAxisSize.max,
                          children: [
                            Lottie.asset(kLottieBigTv, height: 150),
                            Flexible(
                              child: AfkCreditsText.headingThreeLight(
                                "Enjoy your well deserved screen time!",
                                align: TextAlign.center,
                              ),
                            ),
                          ],
                        ),
                      ),
                Spacer(),
                AfkCreditsButton.text(
                  title: "Start immediately",
                  color: kcGreyTextColor,
                  onTap: () => model.startNow(session: session),
                ),
                verticalSpaceRegular,
                AfkCreditsButton(
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