import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/ui/views/active_screen_time/screen_time_requested_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:stacked/stacked.dart';

class ScreenTimeRequestedView extends StatelessWidget {
  final ScreenTimeSession session;
  const ScreenTimeRequestedView({Key? key, required this.session})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ScreenTimeRequestedViewModel>.reactive(
      viewModelBuilder: () => ScreenTimeRequestedViewModel(),
      onModelReady: (model) => model.listenToData(session: session),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: Container(
            height: screenHeight(context),
            width: screenWidth(context),
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                SizedBox(height: 50),
                AfkCreditsText.headingTwo(
                    "Requested ${session.minutes.toString()} min"),
                //verticalSpaceTiny,
                // Text("Ask your parents to accept screen time",
                //     style: heading2Style.copyWith(fontSize: 60)),
                Spacer(),
                Container(
                  height: 220,
                  //color: Colors.red,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Lottie.asset(kLottieBigTv, height: 150),
                      // Flexible(
                      //   child: AfkCreditsText.headingThreeLight(
                      //     "Ask your parents to accept your well deserved screen time!",
                      //     align: TextAlign.center,
                      //   ),
                      // ),
                    ],
                  ),
                ),
                AfkCreditsText.headingThreeLight(
                          "Waiting for parents to accept...",
                          align: TextAlign.center,
                        ),
                        verticalSpaceMedium,
                AFKProgressIndicator(linear: true, color: kcScreenTimeBlue),
                Spacer(),
                // AfkCreditsButton.text(
                //   title: "Start immediately",
                //   color: kcGreyTextColor,
                //   onTap: () => model.startNow(session: session),
                // ),
                verticalSpaceRegular,
                AfkCreditsButton(
                  height: 50,
                  title: "Cancel",
                  onTap: () => model.cancel(session: session),
                  color: kcScreenTimeBlue,
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
