import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/image_urls.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/widgets/explorer_home_widgets/afk_credits_display.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:transparent_image/transparent_image.dart';

class CreditsScreenTimeView extends StatelessWidget {
  const CreditsScreenTimeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // return SafeArea(
    //   child: Scaffold(
    //     body: Stack(
    //       children: [
    //         AnimatedOpacity(
    //           opacity: 1,
    //           duration: Duration(milliseconds: 500),
    //           child: Container(
    //             height: 100,
    //             //color: Colors.blue.withOpacity(0.5),
    //             padding: const EdgeInsets.symmetric(
    //                 horizontal: kHorizontalPadding, vertical: 10),
    //             child: Row(
    //               mainAxisAlignment: MainAxisAlignment.start,
    //               children: [
    //                 Padding(
    //                   padding: const EdgeInsets.only(right: 5.0, top: 14),
    //                   child: Row(
    //                     mainAxisAlignment: MainAxisAlignment.start,
    //                     children: [
    //                       Hero(
    //                         tag: "CREDITS",
    //                         child: Image.asset(kAFKCreditsLogoPath, height: 80),
    //                       ),
    //                       horizontalSpaceTiny,
    //                       AfkCreditsText.headline("130"),
    //                     ],
    //                   ),
    //                 ),
    //               ],
    //             ),
    //           ),
    //         ),
    //       ],
    //     ),
    //   ),
    // );

    return MainPage(
      child: Container(
        child: Padding(
          padding: const EdgeInsets.only(top: 100, bottom: 150),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              AfkCreditsText.headingThree("Go get your screen time"),
              verticalSpaceMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Hero(
                    tag: "CREDITS",
                    child: Image.asset(kAFKCreditsLogoPath, height: 50),
                  ),
                  horizontalSpaceSmall,
                  AfkCreditsText.headingOne("130"),
                  horizontalSpaceSmall,
                  Icon(Icons.arrow_right_alt_rounded, size: 40),
                  verticalSpaceMedium,
                  Lottie.network(
                      'https://assets8.lottiefiles.com/packages/lf20_wTfKKa.json',
                      height: 80),
                  AfkCreditsText.headingOne("2 h"),
                ],
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 70),
                child: Divider(thickness: 2),
              ),
              //Icon(Icons.arrow_downward_rounded, size: 40),
              Spacer(),
              Lottie.network(
                  'https://assets8.lottiefiles.com/packages/lf20_l3jzffol.json',
                  height: 180),
              verticalSpaceSmall,
              AfkCreditsText.subheading("Enjoy what you earned ;)"),
            ],
          ),
        ),
      ),
    );
    // child: Column(
    //   mainAxisAlignment: MainAxisAlignment.center,
    //   children: [
    //     Hero(
    //       tag: "CREDITS",
    //       child: Row(
    //         children: [
    //           Image.asset(kAFKCreditsLogoPath, height: 50),
    //           horizontalSpaceTiny,
    //           AfkCreditsText.headingOne("130"),
    //         ],
    //       ),
    //     ),
    //     verticalSpaceMassive,
    //     FadeInImage.memoryNetwork(
    //       fadeInDuration: Duration(milliseconds: 200),
    //       placeholder: kTransparentImage,
    //       image: kScreenTimeImageUrl,
    //       placeholderFit: BoxFit.none,
    //       height: 70,
    //       //fit: BoxFit.fill,
    //     ),
    //   ],
    // ),
    //   ),
    // );
  }
}
