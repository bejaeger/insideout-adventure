import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/layout_widgets/card_overlay_layout.dart';
import 'package:afkcredits/ui/views/credits_overlay/credits_overlay_viewmodel.dart';
import 'package:afkcredits/ui/widgets/large_button.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
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
              AfkCreditsText.headingThree("Available Screen Time",
                  align: TextAlign.center),
              verticalSpaceMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hero(
                  //   tag: "CREDITS",
                  //   child: Image.asset(kAFKCreditsLogoPath,
                  //       height: 30, color: kcPrimaryColor),
                  // ),
                  Image.asset(kAFKCreditsLogoPath,
                      height: 30, color: kcPrimaryColor),
                  horizontalSpaceSmall,
                  AfkCreditsText.headingThree(
                      model.afkCreditsBalance.toStringAsFixed(0)),
                  horizontalSpaceSmall,
                  Icon(Icons.arrow_forward, size: 25),
                  horizontalSpaceTiny,
                  Icon(Icons.schedule, color: kcScreenTimeBlue, size: 35),
                  horizontalSpaceTiny,
                  // Lottie.network(
                  //     'https://assets8.lottiefiles.com/packages/lf20_wTfKKa.json',
                  //     height: 40),
                  AfkCreditsText.headingThree(
                      model.totalAvailableScreenTime.toString() + " min"),
                ],
              ),
              verticalSpaceLarge,
              AfkCreditsText.subheading("Claim your screen time now!"),
              verticalSpaceMedium,
              AfkCreditsButton(
                  height: 50,
                  color: kcScreenTimeBlue,
                  //backgroundColor: kcScreenTimeBlue,
                  leading: Image.asset(kScreenTimeIcon,
                      height: 25, color: Colors.white),
                  onTap: () {
                    model.navToSelectScreenTimeView();
                    model.removeCreditsOverlay();
                  },
                  title: "Get Screen Time"),
            ],
          ),
        ),
      ),
    );
  }
}
