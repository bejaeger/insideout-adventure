import 'package:afkcredits/app_config_provider.dart';
import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/ui/views/common_drawer_view/common_drawer_view.dart';
import 'package:afkcredits/ui/views/common_drawer_view/common_drawer_viewmodel.dart';
import 'package:afkcredits/ui/widgets/terms_and_privacy.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:badges/badges.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ParentDrawerView extends StatelessWidget {
  const ParentDrawerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CommonDrawerViewModel>.reactive(
      viewModelBuilder: () => CommonDrawerViewModel(),
      builder: (context, model, child) => CommonDrawerView(
        userName: model.currentUser.fullName,
        children: [
          verticalSpaceSmall,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            child: ListTile(
              title: InsideOutText.body("Introduction"),
              leading: Icon(Icons.info_rounded),
              onTap: model.navToOnboardingScreens,
            ),
          ),
          verticalSpaceTiny,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            child: ListTile(
              title: InsideOutText.body("Help Desk"),
              leading: Icon(Icons.help_center),
              onTap: model.navToHelpDesk,
            ),
          ),
          verticalSpaceTiny,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            child: ListTile(
              title: Badge(
                alignment: Alignment.centerLeft,
                badgeColor: kcOrange,
                position: BadgePosition.topEnd(end: 40, top: -3),
                showBadge: !model.userHasGivenFeedback,
                child: InsideOutText.body("Feedback"),
              ),
              leading: Icon(Icons.chat_bubble_rounded),
              onTap: model.navToFeedbackView,
            ),
          ),
          verticalSpaceTiny,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            child: ListTile(
                title: InsideOutText.body("Terms & Policies"),
                leading: Icon(Icons.book),
                onTap: () => showTermsAndPrivacyDialog(
                    context, model.appConfigProvider)),
          ),
          verticalSpaceTiny,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            child: ListTile(
              title: InsideOutText.body("About"),
              leading: Icon(Icons.article),
              onTap: () => showAboutDialog(
                context: context,
                applicationIcon: Image.asset(
                  "assets/inside_out_logo_io_adv.png",
                  height: 50,
                  width: 50,
                ),
                applicationName: "InsideOut Adventure",
                applicationVersion: model.appConfigProvider.versionName,
                children: [
                  Text(
                    "We are a young Vancouver-based startup with the goal to incentivize children to be more active and to find a balance between physical activity and screen time usage. "
                    "We highly appreciate any feedback and suggestion. "
                    "Please reach out at: \n"
                    "${model.appConfigProvider.contactEmail}",
                    style: bodyStyle,
                  ),
                ],
              ),
            ),
          ),
          verticalSpaceSmall,
          Divider(),
          verticalSpaceSmall,
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
            child: ListTile(
              title: InsideOutText.body("Logout"),
              leading: Icon(Icons.logout_rounded),
              onTap: model.handleLogoutEvent,
            ),
          ),
        ],
      ),
    );
  }
}
