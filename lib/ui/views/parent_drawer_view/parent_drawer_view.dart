import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/parent_drawer_view/parent_drawer_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class ParentDrawerView extends StatelessWidget {
  const ParentDrawerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ParentDrawerViewModel>.reactive(
      viewModelBuilder: () => ParentDrawerViewModel(),
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
                              child: AfkCreditsText.headingTwo("MENU")),
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
                              color: Colors.black, size: 35),
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
                        child: AfkCreditsButton(
                            title: "Create Quest",
                            onTap: model.navToCreateQuest),
                      ),
                    ],
                  ),
                ),
                verticalSpaceMedium,
                Divider(),
                verticalSpaceMedium,
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalPadding),
                  child: Row(
                    children: [
                      // Expanded(
                      //   child: SmallButton(
                      //       title: "Logout", onPressed: model.logout),
                      // ),
                      Expanded(
                        child: TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(0.0),
                              primary: kBlackHeadlineColor),
                          // onPressed: model.navigateToExplorerHomeView,
                          onPressed: model.logout,
                          //child: Text("Go to explorer home/map")),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child:
                                Text("Logout", style: TextStyle(fontSize: 20)),
                          ),
                        ),
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
