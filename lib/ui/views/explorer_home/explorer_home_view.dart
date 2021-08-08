import 'package:afkcredits/ui/views/explorer_home/explorer_home_viewmodel.dart';
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
        appBar: AppBar(
          title: Text("Hi Explorer!"),
        ),
        body: ListView(
          children: [
            verticalSpaceMassive,
            Text("Map View"),
          ],
        ),
      ),
    );
  }
}
