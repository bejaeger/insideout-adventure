import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/ui/views/drawer_widget/drawer_widget_viewmodel.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class DrawerWidgetView extends StatelessWidget {
  const DrawerWidgetView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<DrawerWidgetViewModel>.reactive(
      viewModelBuilder: () => DrawerWidgetViewModel(),
      //onModelReady: (model) => model.init(),
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
                            padding: EdgeInsets.all(25),
                            child: Text(
                              'MENU',
                              style: textTheme(context).headline6!.copyWith(
                                    color: kcPrimaryColorSecondary,
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
                              color: kcPrimaryColorSecondary, size: 35),
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpaceMedium,
                if (model.currentUser.createdByUserWithId != null)
                  Padding(
                    padding: const EdgeInsets.all(kHorizontalPadding),
                    child: Row(
                      children: [
                        Expanded(
                          child: ElevatedButton(
                            // onPressed: model.navigateToExplorerHomeView,
                            onPressed: model.handleSwitchToSponsorEvent,
                            //child: Text("Go to explorer home/map")),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Text("Parents Area \u279A",
                                  style: TextStyle(fontSize: 20)),
                            ),
                          ),
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
                        child: TextButton(
                          style: TextButton.styleFrom(
                              padding: const EdgeInsets.all(0.0),
                              primary: kcBlackHeadlineColor),
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
                verticalSpaceLarge,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
