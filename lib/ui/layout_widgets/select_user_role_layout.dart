import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

class SelectUserRoleLayout extends StatelessWidget {
  final void Function() onBackPressed;
  final void Function() onWardPressed;
  final void Function() onGuardianPressed;
  final void Function()? onSuperUserPressed;
  final void Function()? onAdminMasterPressed;
  final void Function()? onAdminPressed;

  final bool isBusy;

  const SelectUserRoleLayout(
      {Key? key,
      required this.onBackPressed,
      required this.onWardPressed,
      required this.onGuardianPressed,
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
              padding: EdgeInsets.zero,
              alignment: Alignment.centerLeft,
              icon: Icon(
                Icons.arrow_back,
                color: Colors.black,
              ),
              onPressed: onBackPressed,
            ),
            InsideOutText.headingOne(
              "Select your account type",
            ),
            verticalSpaceLarge,
            verticalSpaceSmall,
            InsideOutButton(
              onTap: onWardPressed,
              title: "I am a child",
              height: 80,
              disabled: true,
            ),
            verticalSpaceLarge,
            InsideOutButton(
              onTap: onGuardianPressed,
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
