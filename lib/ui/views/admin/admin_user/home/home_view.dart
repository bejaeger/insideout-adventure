import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      //onModelReady: (model) => model.listenToData(),
      fireOnModelReadyOnce: true,
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(title: Text("Admin Home View")),
        body: ListView(
          children: [
            verticalSpaceMedium,
            ElevatedButton(
              // onPressed: model.navigateToExplorerHomeView,
              onPressed: model.logout,
              //child: Text("Go to explorer home/map")),
              child: Text("Logout  "),
            ),
          ],
        ),
      ),
    );
  }
}
