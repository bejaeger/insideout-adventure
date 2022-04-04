import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/image_urls.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/select_screen_time_view/select_screen_time_viewmodel.dart';
import 'package:afkcredits/ui/widgets/explorer_home_widgets/afk_credits_display.dart';
import 'package:afkcredits/ui/widgets/main_long_button.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:transparent_image/transparent_image.dart';

import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SelectScreenTimeView extends StatelessWidget {
  const SelectScreenTimeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SelectScreenTimeViewModel>.reactive(
      viewModelBuilder: () => SelectScreenTimeViewModel(),
      builder: (context, model, child) {
        return MainPage(
          child: Container(
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 20, right: 20, top: 40, bottom: 90),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Align(
                      alignment: Alignment.centerLeft,
                      child: AfkCreditsText.headingOne("Screen time")),
                  verticalSpaceMedium,
                  Container(
                    height: 100,
                    padding: const EdgeInsets.all(15.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15.0),
                      border: Border.all(),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.max,
                      children: [
                        AfkCreditsText.subheading("8:08 PM"),
                        verticalSpaceTiny,
                        Expanded(
                          child: AfkCreditsText.body(
                              "10 min screen time cost 10 credits at this time."),
                        ),
                      ],
                    ),
                  ),
                  verticalSpaceMedium,
                  AfkCreditsText.subheading("Total available"),
                  verticalSpaceSmall,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Hero(
                        tag: "CREDITS",
                        child: Image.asset(kAFKCreditsLogoPath, height: 32),
                      ),
                      horizontalSpaceSmall,
                      AfkCreditsText.headingTwo(
                          model.currentUserStats.afkCreditsBalance.toString()),
                      horizontalSpaceSmall,
                      Icon(Icons.arrow_right_alt_rounded, size: 28),
                      verticalSpaceMedium,
                      horizontalSpaceTiny,
                      Lottie.network(
                          'https://assets8.lottiefiles.com/packages/lf20_wTfKKa.json',
                          height: 45),
                      AfkCreditsText.headingTwo(
                          model.totalAvailableScreenTime.toString() + " min"),
                    ],
                  ),
                  //Icon(Icons.arrow_downward_rounded, size: 40),
                  verticalSpaceMedium,
                  Lottie.network(
                      'https://assets8.lottiefiles.com/packages/lf20_l3jzffol.json',
                      height: 120),
                  verticalSpaceMedium,
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 70),
                  //   child: Divider(thickness: 2),
                  // ),
                  // verticalSpaceMedium,
                  Spacer(),
                  MainLongButton(
                      onTap: model.startScreenTime, title: "Start screen time"),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
