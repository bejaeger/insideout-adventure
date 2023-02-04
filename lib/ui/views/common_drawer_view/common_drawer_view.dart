import 'package:afkcredits/ui/views/common_drawer_view/common_drawer_viewmodel.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class CommonDrawerView extends StatelessWidget {
  final List<Widget> children;
  final String userName;
  const CommonDrawerView(
      {Key? key, required this.children, required this.userName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommonDrawerViewModel>.reactive(
        viewModelBuilder: () => CommonDrawerViewModel(),
        builder: (context, model, child) {
          late String realUserName;
          if (userName == "") {
            realUserName = "Test user";
          } else {
            realUserName = userName;
          }
          return SizedBox(
            width: screenWidth(context, percentage: 0.7),
            child: Drawer(
              child: SafeArea(
                child: ListView(
                  children: [
                    DrawerHeader(
                      decoration: BoxDecoration(
                        color: kcPrimaryColor,
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          CircleAvatar(
                            radius: 34,
                            backgroundColor: kcWhiteTextColor,
                            child: AfkCreditsText.headingFourLight(
                                getInitialsFromName(realUserName)),
                          ),
                          horizontalSpaceMedium,
                          Flexible(
                            child: Text(
                              realUserName,
                              style: subheadingStyle.copyWith(
                                  color: kcWhiteTextColor),
                            ),
                          ),
                          horizontalSpaceSmall,
                        ],
                      ),
                    ),
                    ...children
                  ],
                ), // AfkCreditsText.subheading(userName),
              ),
            ),
          );
        });
  }
}
