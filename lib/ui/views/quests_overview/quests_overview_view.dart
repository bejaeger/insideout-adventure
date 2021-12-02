import 'package:afkcredits/ui/views/quests_overview/quests_overview_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class QuestsOverviewView extends StatelessWidget {
  const QuestsOverviewView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<QuestsOverviewViewModel>.reactive(
      viewModelBuilder: () => QuestsOverviewViewModel(),
      builder: (context, model, child) => Scaffold(
          appBar: CustomAppBar(
            title: "Quests Overview",
          ),
          body: Column(children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                    onTap: model.navigateToSingleQuestView,
                    child: Container(
                        width: 200,
                        height: 200,
                        color: Colors.blue,
                        child: Center(child: Text("Minigames", style: textTheme(context)
                                    .headline5!
                                    .copyWith(color: Colors.grey[200]))))),
                GestureDetector(
                    onTap: model.navigateToMapView,
                    child: Container(
                        width: 200,
                        height: 200,
                        color: Colors.green,
                        child: Center(
                            child: Text("Map games",
                                style: textTheme(context)
                                    .headline5!
                                    .copyWith(color: Colors.grey[200]))))),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(width: 200, height: 200, color: Colors.orange),
                Container(width: 200, height: 200, color: Colors.yellow),
              ],
            )
          ])),
    );
  }
}
