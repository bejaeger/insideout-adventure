import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/image_urls.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_purchase.dart';
import 'package:afkcredits/ui/layout_widgets/main_page.dart';
import 'package:afkcredits/ui/views/screen_time/screen_time_viewmodel.dart';
import 'package:afkcredits/ui/widgets/screen_time_button.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

// !!! DEPRECATED !!!

class ScreenTimeView extends StatelessWidget {
  const ScreenTimeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ScreenTimeViewModel>.reactive(
      viewModelBuilder: () => ScreenTimeViewModel(),
      builder: (context, model, child) => MainPage(
        onBackPressed: model.popView,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
          child: Column(
            //crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              verticalSpaceMedium,
              AfkCreditsText.headingOne("Screen Time"),
              verticalSpaceLarge,
              Wrap(
                children: [
                  SizedBox(
                    height: 160,
                    width: 160,
                    child: ScreenTimeButton(
                      title:
                          "${model.getScreenTimeCategories()[0].hours} hours",
                      credits: centsToAfkCredits(
                          model.getScreenTimeCategories()[0].amount),
                      backgroundColor: kDarkTurquoise,
                      titleColor: kWhiteTextColor,
                      imageUrl: kScreenTimeImageUrl,
                      onPressed: () => model.handleScreenTimePurchase(
                          model.getScreenTimeCategories()[0]),
                    ),
                  ),
                  SizedBox(
                    height: 160,
                    width: 160,
                    child: ScreenTimeButton(
                      title:
                          "${model.getScreenTimeCategories()[1].hours} hours",
                      credits: centsToAfkCredits(
                          model.getScreenTimeCategories()[1].amount),
                      backgroundColor: kDarkTurquoise,
                      titleColor: kWhiteTextColor,
                      imageUrl: kScreenTimeImageUrl,
                      onPressed: () => model.handleScreenTimePurchase(
                          model.getScreenTimeCategories()[1]),
                    ),
                  ),
                  SizedBox(
                    height: 160,
                    width: 160,
                    child: ScreenTimeButton(
                      title:
                          "${model.getScreenTimeCategories()[2].hours} hours",
                      credits: centsToAfkCredits(
                          model.getScreenTimeCategories()[2].amount),
                      backgroundColor: kDarkTurquoise,
                      titleColor: kWhiteTextColor,
                      imageUrl: kScreenTimeImageUrl,
                      onPressed: () => model.handleScreenTimePurchase(
                          model.getScreenTimeCategories()[2]),
                    ),
                  ),
                  SizedBox(
                    height: 160,
                    width: 160,
                    child: ScreenTimeButton(
                      title:
                          "${model.getScreenTimeCategories()[3].hours} hours",
                      credits: centsToAfkCredits(
                          model.getScreenTimeCategories()[3].amount),
                      backgroundColor: kDarkTurquoise,
                      titleColor: kWhiteTextColor,
                      imageUrl: kScreenTimeImageUrl,
                      onPressed: () => model.handleScreenTimePurchase(
                          model.getScreenTimeCategories()[3]),
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}

// class ScreenTimeVoucherList extends StatelessWidget {
//   final double? height;
//   final List<ScreenTimePurchase> screenTimeVoucherList;
//   final Future Function(ScreenTimePurchase) onPressed;
//   const ScreenTimeVoucherList(
//       {Key? key,
//       this.height,
//       required this.screenTimeVoucherList,
//       required this.onPressed})
//       : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return GridView.builder(
//       itemCount: screenTimeVoucherList.length,
//       gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//         childAspectRatio: 1,
//         crossAxisSpacing: 10,
//         mainAxisSpacing: 10,
//         crossAxisCount: 1,
//       ),
//       itemBuilder: (context, index) {
//         return SizedBox(
//           height: 120,
//           width: 120,
//           child: ScreenTimeButton(
//             title: "${screenTimeVoucherList[index].hours} hours",
//             credits: centsToAfkCredits(screenTimeVoucherList[index].amount),
//             backgroundColor: kDarkTurquoise,
//             titleColor: kWhiteTextColor,
//             imageUrl: kScreenTimeImageUrl,
//             onPressed: () => onPressed(screenTimeVoucherList[index]),
//           ),
//         );
//       },
//     );
//   }
// }
