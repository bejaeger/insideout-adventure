import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class SelectUserRoleLayout extends StatelessWidget {
  final void Function() onBackPressed;
  final void Function() onExplorerPressed;
  final void Function() onSponsorPressed;
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
      this.isBusy = false})
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
            if (isBusy) CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
