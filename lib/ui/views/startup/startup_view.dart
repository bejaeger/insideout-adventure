import 'package:afkcredits/ui/views/startup/startup_viewmodel.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Welcome to AFK Credits"),
        ),
        body: ListView(
          children: [
            verticalSpaceMedium,
            ElevatedButton(
                onPressed: () => model.navigateToSponsorHomeView,
                child: Text("Go to sponsor home")),
            verticalSpaceMedium,
            ElevatedButton(
                onPressed: () => model.navigateToExplorerHomeView,
                child: Text("Go to explorer home/map")),
          ],
        ),
      ),
    );
  }
}
