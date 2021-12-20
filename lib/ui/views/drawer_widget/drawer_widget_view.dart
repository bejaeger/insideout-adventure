import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/ui/views/drawer_widget/drawer_widget_viewmodel.dart';
import 'package:afkcredits/ui/widgets/nav_button_widget.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
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
                                    color: kDarkTurquoise,
                                    fontSize: 35,
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
                                color: kDarkTurquoise, size: 35),
                          ),
                        )),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                      child: NavButtonWidget(
                        title: 'REWARDS',
                        icon: const Icon(
                          Icons.card_giftcard_outlined,
                          color: kDarkTurquoise,
                          size: 70,
                        ),
                        onTap: model.navigateToGiftCardsView,
                      ),
                    ),
                  ],
                ),
                Row(
                  children: [
                    Expanded(
                        child: NavButtonWidget(
                      title: 'ASK FOR FUNDS',
                      icon: const Icon(
                        Icons.arrow_downward_rounded,
                        color: kDarkTurquoise,
                        size: 70,
                      ),
                      onTap: model.showNotImplementedSnackbar,
                    )),
                    // Expanded(
                    //     child: NavButtonWidget(
                    //   title: 'ACHIEVEMENTS',
                    //   icon: const Icon(
                    //     Icons.badge_rounded,
                    //     color: kDarkTurquoise,
                    //     size: 70,
                    //   ),
                    //   onTap: model.showNotImplementedSnackbar,
                    // )),
                  ],
                ),
                verticalSpaceMedium,
                Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: kHorizontalPadding),
                  child: Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          // onPressed: model.navigateToExplorerHomeView,
                          onPressed: model.logout,
                          //child: Text("Go to explorer home/map")),
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child:
                                Text("LOGOUT", style: TextStyle(fontSize: 24)),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
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
                              child: Text("PARENTS AREA",
                                  style: TextStyle(fontSize: 24)),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                verticalSpaceLarge,

                // Row(
                //   children: [
                //     Expanded(
                //         child: navButtonWidget(
                //             'DONATE',
                //             'https://www.freecodecamp.org/donate/',
                //             const Icon(
                //               Icons.favorite,
                //               color: kDarkTurquoise,
                //               size: 70,
                //             ),
                //             true,
                //             model,
                //             context)),
                //   ],
                // ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
