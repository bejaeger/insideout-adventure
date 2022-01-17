import 'package:afkcredits/constants/asset_locations.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'manage_quest_viewmodel.dart';

class ManageQuestView extends StatelessWidget {
  const ManageQuestView({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ManageQuestViewModel>.reactive(
      builder: (context, model, child) => Scaffold(
        body: CustomScrollView(
          slivers: [
            const SliverAppBar(
              centerTitle: true,
              title: Text("Manage Quests"),
              floating: true,
              expandedHeight: 80,
            ),
            QuestGestureDetectorList(model: model),
          ],
        ),
      ),
      viewModelBuilder: () => ManageQuestViewModel(),
    );
  }
}

// ignore: must_be_immutable
class QuestGestureDetectorList extends StatelessWidget {
  ManageQuestViewModel? model;
  QuestGestureDetectorList({required this.model});
  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, crossAxisSpacing: 20, mainAxisSpacing: 20),
      delegate: SliverChildBuilderDelegate((BuildContext context, int index) {
        return GestureDetector(
          onTap: () {
            model!.NavigateToQuestViews(index: index);
            //model!.navToAddGiftCard();
            print('Clikced By Felix ${index.toString()}');
          },
          child: Container(
            height: 250,
            child: Card(
              semanticContainer: true,
              clipBehavior: Clip.antiAliasWithSaveLayer,
              child: Image.asset(assetsQuestImages[index]
                  //fit: BoxFit.fill,
                  ),
              elevation: 5,
            ),
          ),
        );
      }, childCount: assetsQuestImages.length),
    );
  }
}
