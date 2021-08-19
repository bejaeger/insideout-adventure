import 'package:afkcredits/ui/views/sponsor_home/sponsor_home_viewmodel.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class SponsorHomeView extends StatelessWidget {
  const SponsorHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SponsorHomeViewModel>.reactive(
      viewModelBuilder: () => SponsorHomeViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("Hi Sponsor!"),
        ),
        body: ListView(
          children: [
            verticalSpaceMassive,
            Text("Sponsor Home View"),
            verticalSpaceMassive,
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
