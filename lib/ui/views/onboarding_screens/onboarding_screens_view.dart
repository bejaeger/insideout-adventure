import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/views/onboarding_screens/onboarding_screens_viewmodel.dart';
import 'package:afkcredits/ui/widgets/hercules_world_logo.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:introduction_screen/introduction_screen.dart';

class OnBoardingScreensView extends StatelessWidget {
  const OnBoardingScreensView({Key? key}) : super(key: key);

  Widget _buildFullscreenImage() {
    return Image.asset(
      kIllustrationActivity,
      fit: BoxFit.cover,
      height: double.infinity,
      width: double.infinity,
      alignment: Alignment.center,
    );
  }

  Widget _buildImage(String assetName, [double width = 350]) {
    return Image.asset('$assetName', width: width);
  }

  @override
  Widget build(BuildContext context) {
    const bodyStyle = TextStyle(fontSize: 19.0);

    const pageDecoration = const PageDecoration(
      titleTextStyle: TextStyle(fontSize: 28.0, fontWeight: FontWeight.w700),
      bodyTextStyle: bodyStyle,
      bodyPadding: EdgeInsets.fromLTRB(16.0, 0.0, 16.0, 16.0),
      pageColor: Colors.white,
      imagePadding: EdgeInsets.zero,
    );

    return ViewModelBuilder<OnBoardingScreensViewModel>.reactive(
      viewModelBuilder: () => OnBoardingScreensViewModel(),
      builder: (context, model, child) => SafeArea(
        child: Scaffold(
          body: IntroductionScreen(
            pages: [
              PageViewModel(
                title: "Prototype Version",
                body:
                    "Thank you for testing our prototype, we hope you will enjoy it. The following gives you information about the app.",
                image: HerculesWorldLogo(),
                // _buildImage(kAFKCreditsLogoPath, 150),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Incentivize a healthy screen time balance",
                body:
                    "Children can earn Hercules Credits through outdoor activities and can redeem these credits to unlock screen time.",
                image: _buildImage(kIllustrationInfographic, 500),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Create a child's account",
                body:
                    "You can monitor your child’s activity from this parent account and switch to the child’s account to allow them to earn and redeem credits.",
                image: _buildImage(kIllustrationAnnaHercules, 280),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Let your child earn credits",
                body:
                    "Your child can earn Hercules Credits through gps-based outdoor games. You are also able to create these games in your preferred locations or manually add credits to the child’s account.",
                image: _buildImage(kIllustrationActivity, 250),
                decoration: pageDecoration,
                //reverse: true,
              ),
              PageViewModel(
                title: "Let your child use screen time",
                body:
                    "Your child can spend Hercules Credits for screen time, may it be for streaming, gaming, or anything else your child enjoys. We will start a timer and notify you when the screen time is over.",
                image: _buildImage(kIllustrationScreenTime, 240),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Let’s develop a healthier screen time balance ",
                body: "",
                image: _buildImage(kIllustrationParentsMeditate, 190),
                decoration: pageDecoration,
                footer: AfkCreditsButton(
                  onTap: model.replaceWithHomeView,
                  title: "Start Now",
                ),
              ),
            ],
            onDone: model.replaceWithHomeView,
            showDoneButton: false,
            showSkipButton: false,
            skipOrBackFlex: 0,
            nextFlex: 0,
            showBackButton: true,
            showNextButton: true,
            //rtl: true, // Display as right-to-left
            back: const Icon(Icons.arrow_back),
            skip: const Text('Skip',
                style: TextStyle(fontWeight: FontWeight.w600)),
            next: const Icon(Icons.arrow_forward),
            done: const Text('Done',
                style: TextStyle(fontWeight: FontWeight.w600)),
            curve: Curves.fastLinearToSlowEaseIn,
            //controlsMargin: const EdgeInsets.all(16),
            // controlsPadding: kIsWeb
            //     ? const EdgeInsets.all(12.0)
            //     : const EdgeInsets.fromLTRB(8.0, 4.0, 8.0, 4.0),
            dotsDecorator: const DotsDecorator(
              size: Size(10.0, 10.0),
              color: Color(0xFFBDBDBD),
              activeSize: Size(22.0, 10.0),
              activeShape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(25.0)),
              ),
            ),
            dotsContainerDecorator: const ShapeDecoration(
              color: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(8.0)),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
