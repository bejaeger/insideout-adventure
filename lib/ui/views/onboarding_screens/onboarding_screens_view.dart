import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/onboarding_screens/onboarding_screens_viewmodel.dart';
import 'package:afkcredits/ui/widgets/activity_conversion_icon.dart';
import 'package:afkcredits/ui/widgets/hercules_world_logo.dart';
import 'package:afkcredits/ui/widgets/screen_time_conversion_icon.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
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
                titleWidget: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: AfkCreditsText.headingTwo(
                      "Incentivizing a healthy screen time balance"),
                ),
                // body:
                //     "Thank you for testing our prototype, we hope you will enjoy it. The following gives you information about the app.",
                bodyWidget: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.all(6.0),
                  child: Column(
                    children: [
                      AfkCreditsText.bodyItalic(
                          "Prototype Version - " + model.versionName),
                      verticalSpaceMedium,
                      AfkCreditsText.body(
                          "Thank you for testing our prototype, we hope you will enjoy it."),
                    ],
                  ),
                ),
                image: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Container(
                      padding: const EdgeInsets.only(bottom: 30.0),
                      //color: Colors.red,
                      child: HerculesWorldLogo(
                        sizeScale: 1.1,
                      ),
                    ),
                  ],
                ),
                // _buildImage(kAFKCreditsLogoPath, 150),
                decoration: pageDecoration,
              ),
              PageViewModel(
                //title: "Our Concept",
                titleWidget: Container(
                  alignment: Alignment.centerLeft,
                  padding: const EdgeInsets.only(left: 20),
                  child: AfkCreditsText.headingTwo("Our Concept"),
                ),
                //body:
                //  "Children can earn Hercules Credits through outdoor activities and can redeem these credits to unlock screen time.",
                bodyWidget: OnboardingBodyWidget(
                  text1:
                      "Children can earn Hercules Credits through outdoor activities",
                  text2:
                      "Children can redeem Hercules Credits to activate screen time",
                  text3: "Parents can monitor and relax",
                  icon1: OnboardingActivityConversionIcon(),
                  icon2: OnboardingScreenTimeConversionIcon(),
                  //  icon1: Image.asset(
                  //   kActivityIcon,
                  //   height: 24,
                  //   color: kcActivityIconColor,
                  // ),
                  //  icon2: Image.asset(
                  //   kScreenTimeIcon,
                  //   height: 24,
                  //   color: kcScreenTimeBlue,
                  // ),
                ),
                // image: HerculesWorldLogo(),
                image: _buildImage(kIllustrationInfographic, 500),
                decoration: pageDecoration,
              ),
              PageViewModel(
                //title: "Create a child's account",
                titleWidget: OnboardingTitleWidget(
                    subtitle: "Step 1", title: "Create child account"),
                // body:
                //     "You can monitor your child’s activity from this parent account and switch to the child’s account to allow them to earn and redeem credits.",
                bodyWidget: OnboardingBodyWidget(
                  text1:
                      "Switch back and forth between parent and child account",
                  text2: "Monitor child activity from this parent account",
                ),
                // text3:
                //     "Let your child earn and redeem credits from child account"),
                image: _buildImage(kIllustrationAnnaHercules, 280),
                decoration: pageDecoration,
              ),
              PageViewModel(
                titleWidget: OnboardingTitleWidget(
                    subtitle: "Step 2",
                    title: "Let your child earn screen time credits"),
                bodyWidget: OnboardingBodyWidget(
                  icon1: OnboardingActivityConversionIcon(),
                  text1:
                      "Your child can earn Hercules Credits through gps-based outdoor games",
                  text2:
                      "You as a parent can create these games in your preferred locations",
                  // text3: "Parents can manually add credits to child account",
                ),
                // "Your child can earn Hercules Credits through gps-based outdoor games. You are also able to create these games in your preferred locations or manually add credits to the child’s account.",
                image: _buildImage(kIllustrationActivity, 250),
                decoration: pageDecoration,
                //reverse: true,
              ),
              PageViewModel(
                titleWidget: OnboardingTitleWidget(
                    subtitle: "Step 3", title: "Add credits manually"),
                bodyWidget: OnboardingBodyWidget(
                  // icon1: Image.asset(kScreenTimeIcon,
                  //     color: kcScreenTimeBlue, height: 24),
                  // icon1: OnboardingScreenTimeConversionIcon(),
                  text1:
                      "Think about rewarding activities like soccer, groceries, reading, etc",
                  text2:
                      "If you went for a Sunday walk together and forgot to use this app, you can give credits afterwards",
                  // text2:
                  //     "Your child can enjoy its fair earned screen time for streaming, gaming, or any other screen use",
                  // text3: "You will be notified once the screen time is over",
                ),
                //  "Your child can spend Hercules Credits for screen time, may it be for streaming, gaming, or anything else your child enjoys. We will start a timer and notify you when the screen time is over.",
                image: _buildImage(kIllustrationActivity, 250),
                decoration: pageDecoration,
              ),
              PageViewModel(
                titleWidget: OnboardingTitleWidget(
                    subtitle: "Step 4",
                    title: "Monitor activity and screen time usage"),
                bodyWidget: OnboardingBodyWidget(
                  // icon1: Image.asset(kScreenTimeIcon,
                  //     color: kcScreenTimeBlue, height: 24),
                  // icon1: OnboardingScreenTimeConversionIcon(),
                  //text1: "See your children's stats at a glance",
                  // icon2: Image.asset(kScreenTimeIcon2,
                  //     color: kcScreenTimeBlue, height: 24),
                  // text2:
                  //     "Let your child enjoy the fair earned time on the screen",
                  // text2:
                  //     "Your child can enjoy its fair earned screen time for streaming, gaming, or any other screen use",
                  text1:
                      "Establish a healthy balance between activity and screen time",
                ),
                footer: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: AfkCreditsButton(
                    onTap: () =>
                        model.replaceWithHomeView(showPermissionView: true),
                    title: "Start Now",
                  ),
                ),

                //  "Your child can spend Hercules Credits for screen time, may it be for streaming, gaming, or anything else your child enjoys. We will start a timer and notify you when the screen time is over.",
                image: _buildImage(kIllustrationParentsMeditate, 190),
                decoration: pageDecoration,
              ),
              // PageViewModel(
              //   //title: "Let’s develop a healthier screen time balance ",
              //   titleWidget: OnboardingTitleWidget(
              //       subtitle: "",
              //       title: "Let's develop a healthier screen time balance"),
              //   body: "",
              //   image: _buildImage(kIllustrationParentsMeditate, 190),
              //   decoration: pageDecoration,
              //   footer: Padding(
              //     padding: const EdgeInsets.all(15.0),
              //     child: AfkCreditsButton(
              //       onTap: model.replaceWithHomeView,
              //       title: "Start Now",
              //     ),
              //   ),
              // ),
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

class OnboardingBodyWidget extends StatelessWidget {
  final String text1;
  final String? text2;
  final String? text3;
  final Widget? icon1;
  final Widget? icon2;
  const OnboardingBodyWidget({
    Key? key,
    required this.text1,
    this.text2,
    this.text3,
    this.icon1,
    this.icon2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 6),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              icon1 ??
                  Icon(Icons.check_circle_outline,
                      color: kcPrimaryColor, size: 24),
              horizontalSpaceSmall,
              Expanded(
                child: AfkCreditsText.body(text1),
              ),
            ],
          ),
          if (text2 != null) verticalSpaceMedium,
          if (text2 != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                icon2 ??
                    Icon(Icons.check_circle_outline,
                        color: kcPrimaryColor, size: 24),
                horizontalSpaceSmall,
                Expanded(
                  child: AfkCreditsText.body(text2!),
                ),
              ],
            ),
          if (text3 != null) verticalSpaceMedium,
          if (text3 != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline,
                    color: kcPrimaryColor, size: 24),
                horizontalSpaceSmall,
                Expanded(
                  child: AfkCreditsText.body(text3!),
                ),
              ],
            ),
        ],
      ),
    );
  }
}

class OnboardingTitleWidget extends StatelessWidget {
  final String subtitle;
  final String title;
  const OnboardingTitleWidget(
      {Key? key, required this.subtitle, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: kHorizontalPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AfkCreditsText.headingFourLight(subtitle),
          horizontalSpaceTiny,
          AfkCreditsText.headingTwo(title),
        ],
      ),
    );
  }
}

class OnboardingColumnBodyWidget extends StatelessWidget {
  final String text1;
  final String? text2;
  final String? text3;
  final Widget? icon1;
  final Widget? icon2;
  const OnboardingColumnBodyWidget({
    Key? key,
    required this.text1,
    this.text2,
    this.text3,
    this.icon1,
    this.icon2,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.centerLeft,
      padding: const EdgeInsets.only(left: 6),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              icon1 ??
                  Icon(Icons.check_circle_outline,
                      color: kcPrimaryColor, size: 24),
              verticalSpaceTiny,
              AfkCreditsText.body(text1),
            ],
          ),
          if (text2 != null) verticalSpaceMedium,
          if (text2 != null)
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                icon2 ??
                    Icon(Icons.check_circle_outline,
                        color: kcPrimaryColor, size: 24),
                verticalSpaceTiny,
                AfkCreditsText.body(text2!),
              ],
            ),
          if (text3 != null) verticalSpaceMedium,
          if (text3 != null)
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Icon(Icons.check_circle_outline,
                    color: kcPrimaryColor, size: 24),
                horizontalSpaceSmall,
                AfkCreditsText.body(text3!),
              ],
            ),
        ],
      ),
    );
  }
}
