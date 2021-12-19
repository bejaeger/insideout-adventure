import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StatelessWidget {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<HomeViewModel>.reactive(
      onModelReady: (model) => model.setQuestList(),
      fireOnModelReadyOnce: true,
      viewModelBuilder: () => HomeViewModel(),
      builder: (context, model, child) => model.getListOfQuest == null
          ? Center(
              child: Container(
                child: CircularProgressIndicator(
                  backgroundColor: Colors.green,
                ),
              ),
            )
          : Scaffold(
              appBar: AppBar(title: Text("Admin Home View")),
              body: SingleChildScrollView(
                child: Container(
                  height: MediaQuery.of(context).size.height / 2,
                  child: Column(
                    children: [
                      Text('AM Creating a Quest List Here'),
                      Expanded(
                        flex: 3,
                        child: ListView.builder(
                          itemCount: model.getListOfQuest!.length,
                          itemBuilder: (BuildContext context, int index) {
                            return Card(
                              margin: const EdgeInsets.symmetric(
                                  vertical: 10.0,
                                  horizontal: kHorizontalPadding),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25.0),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.all(16.0),
                                child: Container(
                                    //height: height,
                                    child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        model.getListOfQuest![index].name
                                            .toString(),
                                        style: textTheme(context).headline4),
                                    // if (model.nearbyQuests[index]. != null)
                                    /*                     Text(subtitle!,
                                            style: textTheme(context)
                                                .bodyText2!
                                                .copyWith(fontSize: 18)),
                                      Text("Credits to earns: " +
                                          quest.afkCredits.toString()),
                                      Text("Type: " +
                                          describeEnum(quest.type).toString()),
                                      if (sponsoringSentence != null)
                                        Text(sponsoringSentence!), */
                                  ],
                                )),
                              ),
                            );
                          },
                        ),
                      ),

                      /*       QuestListScreen(
                  onCardTapped: model.onQuestInListTapped,
                  quests: model.nearbyQuests,
                  switchToMap: model.toggleIndex,
                  isBusy: model.isBusy,
              ), */
                      verticalSpaceMedium,
                      Expanded(
                        child: ElevatedButton(
                          // onPressed: model.navigateToExplorerHomeView,
                          onPressed: model.logout,
                          //child: Text("Go to explorer home/map")),
                          child: Text("Logout  "),
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
