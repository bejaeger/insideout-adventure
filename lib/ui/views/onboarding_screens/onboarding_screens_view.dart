import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/views/onboarding_screens/onboarding_screens_viewmodel.dart';
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
                title: "Incentivize your children to be active",
                body:
                    "Hercules World introduces a fair system to let your child earn and manage their own screen time responsibly.",
                image: _buildImage(kIllustrationInfographic, 500),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Create a child's account",
                body:
                    "Create a child's account and monitor the account's activities",
                image: _buildImage(kIllustrationAnnaHercules, 280),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Your child can earn screen time credits",
                body:
                    "Use this or another phone to let your child earn credits by completing outdoor quests",
                image: _buildImage(kIllustrationActivityWithArrows, 500),
                decoration: pageDecoration,
                //reverse: true,
              ),
              PageViewModel(
                title: "Your child can activate a screen time timer",
                body: "Your child can responsibly manage screen time",
                image: _buildImage(kIllustrationScreenTime, 240),
                decoration: pageDecoration,
              ),
              PageViewModel(
                title: "Create peace of mind",
                body:
                    "You will be notified when your child's screen time expires",
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
