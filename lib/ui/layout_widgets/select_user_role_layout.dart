import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class SelectUserRoleLayout extends StatelessWidget {
  final void Function() onBackPressed;
  final void Function() onExplorerPressed;
  final void Function() onSponsorPressed;
  final void Function()? onSuperUserPressed;
  final void Function()? onAdminMasterPressed;
  final void Function()? onAdminPressed;

  final bool isBusy;

  const SelectUserRoleLayout(
      {Key? key,
      required this.onBackPressed,
      required this.onExplorerPressed,
      required this.onSponsorPressed,
      this.isBusy = false,
      this.onSuperUserPressed,
      this.onAdminMasterPressed,
      this.onAdminPressed})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25),
        child: ListView(
          children: [
            verticalSpaceRegular,
            IconButton(
              //padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              icon: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: onBackPressed,
            ),
            AfkCreditsText.headingOne(
              "Select your account type",
            ),
            verticalSpaceLarge,
            verticalSpaceSmall,
            AfkCreditsButton(
              onTap: onExplorerPressed,
              title: "I am a child",
              height: 80,
              disabled: true,
            ),
            verticalSpaceLarge,
            AfkCreditsButton(
              onTap: onSponsorPressed,
              title: "I am a parent",
              height: 80,
            ),
            verticalSpaceLarge,
            if (isBusy) AFKProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
