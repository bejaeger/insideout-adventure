import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/active_quest_drawer/active_quest_drawer_viewmodel.dart';
import 'package:afkcredits/ui/widgets/small_button.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ActiveQuestDrawerView extends StatelessWidget {
  const ActiveQuestDrawerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ActiveQuestDrawerViewModel>.reactive(
      viewModelBuilder: () => ActiveQuestDrawerViewModel(),
      builder: (context, model, child) => Drawer(
        child: SafeArea(
          child: SingleChildScrollView(
            child: Column(
              children: [
                Stack(
                  children: [
                    Align(
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Padding(
                            padding: EdgeInsets.only(
                                top: 25, bottom: 25, right: 25, left: 70),
                            child: Text(
                              'Active Quest',
                              maxLines: 2,
                              style: textTheme(context).headline6!.copyWith(
                                    color: Colors.red,
                                    fontSize: 30,
                                  ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerLeft,
                      child: Padding(
                        padding: const EdgeInsets.all(25.0),
                        child: GestureDetector(
                          onTap: () => Navigator.of(context).pop(),
                          child: Icon(Icons.arrow_back,
                              color: Colors.red, size: 35),
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: SmallButton(
                            title: "Information",
                            onPressed: () => model.showQuestInfoDialog(
                                quest: model.activeQuest.quest)),
                      ),
                    ],
                  ),
                ),
                verticalSpaceMedium,
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: SmallButton(
                            title: "Cancel Quest",
                            onPressed: model.isBusy
                                ? () => null
                                : () async =>
                                    await model.cancelOrFinishQuest()),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
