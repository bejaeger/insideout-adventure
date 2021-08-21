import 'dart:math';

import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/users/user.dart';
import 'package:afkcredits/ui/views/sponsor_home/sponsor_home_viewmodel.dart';
import 'package:afkcredits/ui/widgets/section_header.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SponsorHomeView extends StatelessWidget {
  const SponsorHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SponsorHomeViewModel>.reactive(
      viewModelBuilder: () => SponsorHomeViewModel(),
      onModelReady: (model) => model.listenToData(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Hi Sponsor!"),
        ),
        body: ListView(
          physics: ScrollPhysics(),
          children: [
            verticalSpaceMassive,
            SectionHeader(
              title: "Supported Explorers",
            ),
            verticalSpaceSmall,
            if (model.supportedExplorers.length == 0)
              model.isBusy
                  ? CircularProgressIndicator()
                  : ElevatedButton(
                      onPressed: model.navigateToAddExplorerView,
                      child: Text("Support First Explorer -> "),
                      //imagePath: ImagePath.peopleHoldingHands,
                    ),
            if (model.supportedExplorers.length > 0)
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
                child: ExplorersList(
                    explorers: model.supportedExplorers,
                    onAddNewExplorerPressed: model.navigateToAddExplorerView),
              ),
            // _sendMoneyButton(context, model),
            verticalSpaceLarge,
            Divider(),
            verticalSpaceMedium,
            ElevatedButton(
                // onPressed: model.navigateToExplorerHomeView,
                onPressed: model.logout,
                //child: Text("Go to explorer home/map")),
                child: Text("Logout  ")),
          ],
        ),
      ),
    );
  }
}

class ExplorersList extends StatelessWidget {
  final List<User> explorers;
  final void Function() onAddNewExplorerPressed;

  const ExplorersList({
    Key? key,
    required this.explorers,
    required this.onAddNewExplorerPressed,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      //scrollDirection: Axis.horizontal,
      physics: ScrollPhysics(),
      shrinkWrap: true,
      itemCount: min(explorers.length + 1, 10),
      itemBuilder: (context, index) {
        if (index == min(explorers.length, 9)) {
          return Column(
            children: [
              horizontalSpaceSmall,
              ElevatedButton(
                  // onPressed: model.navigateToExplorerHomeView,
                  onPressed: onAddNewExplorerPressed,
                  //child: Text("Go to explorer home/map")),
                  child: Text("Add")),
            ],
          );
        } else {
          return Column(
            children: [
              horizontalSpaceSmall,
              Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0),
                  ),
                  child: ListTile(title: Text(explorers[index].fullName))),
            ],
          );
        }
      },
    );
  }
}
