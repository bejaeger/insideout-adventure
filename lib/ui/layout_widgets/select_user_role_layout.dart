import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class SelectUserRoleLayout extends StatelessWidget {
  final void Function() onBackPressed;
  final void Function() onExplorerPressed;
  final void Function() onSponsorPressed;
  final void Function()? onSuperUserPressed;
  final void Function()? onAdminMasterPressed;
  final void Function()? onAdminPressed;

  final String? explorerButtonTitle;
  final String? sponsorButtonTitle;
  final bool isBusy;

  const SelectUserRoleLayout(
      {Key? key,
      required this.onBackPressed,
      required this.onExplorerPressed,
      required this.onSponsorPressed,
      this.explorerButtonTitle = "CREATE EXPLORER ACCOUNT",
      this.sponsorButtonTitle = "CREATE SPONSOR ACCOUNT",
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
                Icons.arrow_back_ios,
                color: Colors.black,
              ),
              onPressed: onBackPressed,
            ),
            Text(
              "Select your account type",
              style: textTheme(context).headline4,
            ),
            verticalSpaceLarge,
            Text(
              "Are You An Explorer?",
              style: textTheme(context).headline6,
            ),
            // verticalSpaceLarge,
            // Text(
            //   "Are You An Admin?",
            //   style: textTheme(context).headline6,
            // ),
            verticalSpaceSmall,
            ElevatedButton(
                onPressed: onExplorerPressed,
                child: Text("Create Explorer Account")),
            verticalSpaceLarge,
            Text(
              "Are You A Sponsor?",
              style: textTheme(context).headline6,
            ),
            verticalSpaceSmall,
            ElevatedButton(
                onPressed: onSponsorPressed,
                child: Text("Create Sponsor Account")),
            verticalSpaceLarge,
            // -------------------------------------
            // For Development ONLY!
            if (onSuperUserPressed != null && onAdminMasterPressed != null)
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("For Development"),
                  Text("------------------------------>>"),
                  verticalSpaceSmall,
                  Text(
                    "Are You A Super User?",
                    style: textTheme(context).headline6,
                  ),
                  verticalSpaceSmall,
                  ElevatedButton(
                      onPressed: onSuperUserPressed,
                      child: Text("Create A Super User Account")),
                  verticalSpaceSmall,
                  Text(
                    "Are You A Admin?",
                    style: textTheme(context).headline6,
                  ),
                  verticalSpaceSmall,
                  ElevatedButton(
                      onPressed: onAdminPressed,
                      child: Text("Create An Admin Account")),
                  verticalSpaceSmall,
                  Text(
                    "Are You A Master Admin?",
                    style: textTheme(context).headline6,
                  ),
                  verticalSpaceSmall,
                  ElevatedButton(
                      onPressed: onAdminMasterPressed,
                      child: Text("Create A Master Admin Account")),
                  verticalSpaceSmall,
                ],
              ),
            if (isBusy) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
