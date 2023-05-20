import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/layout_widgets/card_overlay_layout.dart';
import 'package:afkcredits/ui/views/credits_overlay/credits_overlay_viewmodel.dart';
import 'package:afkcredits/ui/widgets/credits_to_screentime_widget.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';

class CreditsOverlayView extends StatelessWidget {
  const CreditsOverlayView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CreditsOverlayViewModel>.reactive(
      viewModelBuilder: () => CreditsOverlayViewModel(),
      onModelReady: (model) => model.listenToLayout(),
      builder: (context, model, child) => AnimatedPositioned(
        duration: const Duration(milliseconds: 500),
        top: model.isShowingCreditsOverlay ? 0 : -screenHeight(context),
        curve: Curves.easeOutCubic,
        left: 0,
        right: 0,
        child: CardOverlayLayout(
          onBack: model.removeCreditsOverlay,
          color1: Colors.white,
          color2: kcScreenTimeBlue,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InsideOutText.headingThree("Available Screen Time",
                  align: TextAlign.center),
              verticalSpaceMedium,
              model.currentUserNullable == null
                  ? SizedBox(height: 0, width: 0)
                  : CreditsToScreenTimeWidget(
                      credits: model.afkCreditsBalance,
                      availableScreenTime: model.totalAvailableScreenTime),
              verticalSpaceLarge,
              InsideOutText.subheadingItalic("Claim your screen time now!"),
              verticalSpaceMedium,
              InsideOutButton(
                  height: 50,
                  color: kcScreenTimeBlue,
                  //backgroundColor: kcScreenTimeBlue,
                  leading: Image.asset(kScreenTimeIcon,
                      height: 25, color: Colors.white),
                  onTap: () {
                    model.navToSelectScreenTimeView(
                        childId: model.currentUser.uid,
                        isGuardianAccount: false);
                    model.removeCreditsOverlay();
                  },
                  title: "Get screen time"),
            ],
          ),
        ),
      ),
    );
  }
}
