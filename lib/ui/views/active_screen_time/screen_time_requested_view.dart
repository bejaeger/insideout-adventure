import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_session.dart';
import 'package:afkcredits/ui/views/active_screen_time/screen_time_requested_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
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
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          model.cancel(session: session);
          return true;
        },
        child: SafeArea(
          child: Scaffold(
            body: Container(
              height: screenHeight(context),
              width: screenWidth(context),
              padding: const EdgeInsets.all(20.0),
              child: Column(
                children: [
                  SizedBox(height: 50),
                  InsideOutText.headingTwo(
                      "Requested ${session.minutes.toString()} min"),
                  Spacer(),
                  Container(
                    height: 220,
                    child: Column(
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        Lottie.asset(kLottieBigTv, height: 150),
                      ],
                    ),
                  ),
                  InsideOutText.headingThreeLight(
                    "Waiting for parents to accept...",
                    align: TextAlign.center,
                  ),
                  verticalSpaceMedium,
                  AFKProgressIndicator(linear: true, color: kcScreenTimeBlue),
                  Spacer(),
                  verticalSpaceRegular,
                  InsideOutButton(
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
      ),
    );
  }
}
