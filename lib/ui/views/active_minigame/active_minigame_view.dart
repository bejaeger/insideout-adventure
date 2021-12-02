
import 'package:afkcredits/ui/views/active_minigame/active_minigame_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ActiveMiniGameView extends StatelessWidget {
 const ActiveMiniGameView({Key? key}) : super(key: key);

 @override
 Widget build(BuildContext context) {
   return ViewModelBuilder<ActiveMiniGameViewModel>.reactive(
     viewModelBuilder: () => ActiveMiniGameViewModel(),
     builder: (context, model, child) => Scaffold(
                  appBar: CustomAppBar(
                    title: "Estimate Distance",
                    onBackButton: model.navigateBack,
                  ),
                body: Column(
                  children: [
                    verticalSpaceMediumLarge,
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Container(width: 200, height: 200, color: Colors.cyan),
                      ],
                    ),
                    verticalSpaceMediumLarge,
                    Text("Walk 500 meters"),
                    ElevatedButton(onPressed: model.revealDistance, child: Text("Reveal Distance"))
                  ],
                ),
              ),
   );
 }
}