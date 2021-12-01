

import 'package:afkcredits/ui/views/quests/quest_list_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class QuestListView extends StatelessWidget {
 const QuestListView({Key? key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return ViewModelBuilder<QuestListViewModel>.reactive(
     viewModelBuilder: () => QuestListViewModel(),
     builder: (context, model, child) => Scaffold(
       appBar: CustomAppBar(
         title: "Quest List",
       ),
       body: Column(
         children: [
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               GestureDetector(
                 onTap: model.navigateToSingleQuestView,
                 child: Container(width: 200, height: 200, color: Colors.blue, child: Text("Minigames"))),
               GestureDetector(
                onTap: model.navigateToMapView,
                 child: Container(width: 200, height: 200, color: Colors.green, child: Text("Map games"))),
             ],
           ),
           Row(
             mainAxisAlignment: MainAxisAlignment.center,
             children: [
               Container(width: 200, height: 200, color: Colors.orange),
               Container(width: 200, height: 200, color: Colors.yellow),
             ],
           )

         ]
       )
     ),
   );
 }
}