import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/common_drawer_view/common_drawer_view.dart';
import 'package:afkcredits/ui/views/common_drawer_view/common_drawer_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ParentDrawerView extends StatelessWidget {
  const ParentDrawerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommonDrawerViewModel>.reactive(
      viewModelBuilder: () => CommonDrawerViewModel(),
      builder: (context, model, child) =>
          CommonDrawerView(userName: model.currentUser.fullName, children: [
        // if (model.isAnyoneUsingScreenTime)
        //   AfkCreditsButton(
        //       title: "Screen time session",
        //       onTap: model.navToActiveScreenTimeView),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
          child: Row(
            children: [
              Expanded(
                child: AfkCreditsButton(
                    title: "Show introduction",
                    onTap: model.navToOnboardingScreens),
              ),
            ],
          ),
        ),
        verticalSpaceMedium,
        Divider(),
        verticalSpaceMedium,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
          child: TextButton(
            style: TextButton.styleFrom(
                padding: const EdgeInsets.all(0.0),
                primary: kcBlackHeadlineColor),
            // onPressed: model.navigateToExplorerHomeView,
            onPressed: model.logout,
            //child: Text("Go to explorer home/map")),
            child: Padding(
              padding: const EdgeInsets.all(12.0),
              child: Text("Logout", style: TextStyle(fontSize: 20)),
            ),
          ),
        ),
      ]),
    );
  }
}
