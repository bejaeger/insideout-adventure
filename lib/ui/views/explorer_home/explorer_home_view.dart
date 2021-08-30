import 'package:afkcredits/ui/views/explorer_home/explorer_home_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ExplorerHomeView extends StatelessWidget {
  const ExplorerHomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExplorerHomeViewModel>.reactive(
      viewModelBuilder: () => ExplorerHomeViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: CustomAppBar(
          title: "Hi Explorer!",
        ),
        body: ListView(
          children: [
            verticalSpaceMedium,
            ElevatedButton(
                // onPressed: model.navigateToExplorerHomeView,
                onPressed: model.navigateToMapView,
                //child: Text("Go to explorer home/map")),
                child: Text("Go to explorer Map  ")),
            verticalSpaceMedium,
            ElevatedButton(
              onPressed: model.startQuest,
              child: Text("Start Quest"),
              //imagePath: ImagePath.peopleHoldingHands,
            ),
            if (model.hasActiveQuest)
              Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      onPressed: model.collectMarker1,
                      child: Text("Dummy Collect Marker 1"),
                      //imagePath: ImagePath.peopleHoldingHands,
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: model.collectMarker2,
                      child: Text("Dummy Collect Marker 2"),

                      //imagePath: ImagePath.peopleHoldingHands,
                    ),
                  ),
                  Expanded(
                    child: ElevatedButton(
                      onPressed: model.collectMarker3,
                      child: Text("Dummy Collect Marker 3"),
                      //imagePath: ImagePath.peopleHoldingHands,
                    ),
                  ),
                ],
              ),
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
