import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/ui/views/common_viewmodels/main_footer_viewmodel.dart';
import 'package:afkcredits/ui/widgets/fading_widget.dart';
import 'package:afkcredits/ui/widgets/outline_box.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MainFooterOverlayView extends StatelessWidget {
  const MainFooterOverlayView({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // log.wtf("==>> Rebuild MainFooterView");
    return ViewModelBuilder<MainFooterViewModel>.reactive(
      viewModelBuilder: () => MainFooterViewModel(),
      onModelReady: (model) => model.listenToLayout(),
      builder: (context, model, child) => Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
          //alignment: Alignment.bottomCenter,
          child: FadingWidget(
            show: !(model.isShowingQuestDetails || model.hasActiveQuest) ||
                model.isFadingOutQuestDetails,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Expanded(
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: model.isMenuOpen ? 0 : 1,
                    child: OutlineBox(
                      width: 80,
                      height: 60,
                      borderWidth: 0,
                      text: "SCREEN TIME",
                      onPressed: model.navToCreditsScreenTimeView,
                      color: kDarkTurquoise,
                      textColor: Colors.white,
                    ),
                  ),
                ),
                AnimatedContainer(
                  duration: Duration(milliseconds: 300),
                  width: model.isMenuOpen ? 200 : 130,
                  curve: Curves.linear,
                  child: CircularMenu(
                    toggleButtonOnPressed: () {
                      model.isMenuOpen = !model.isMenuOpen;
                      model.notifyListeners();
                    },
                    alignment: Alignment.bottomCenter,
                    //backgroundWidget: OutlineBox(text: "MENU"),
                    startingAngleInRadian: 1.3 * 3.14,
                    endingAngleInRadian: 1.7 * 3.14,
                    toggleButtonColor: kDarkTurquoise,
                    toggleButtonMargin: 0,
                    toggleButtonBoxShadow: [],
                    toggleButtonSize: 35,
                    radius: model.isSuperUser ? 120 : 80,
                    items: [
                      CircularMenuItem(
                        icon: Icons.settings,
                        color: Colors.grey[600],
                        margin: 0,
                        boxShadow: [],
                        onTap: () {
                          model.showNotImplementedSnackbar();
                        },
                      ),
                      CircularMenuItem(
                        icon: Icons.logout,
                        color: Colors.redAccent.shade700.withOpacity(0.9),
                        margin: 0,
                        boxShadow: [],
                        onTap: model.logout,
                        //model.logout();
                      ),
                      if (model.isSuperUser)
                        CircularMenuItem(
                          icon: Icons.person,
                          color: Colors.orange.shade700.withOpacity(0.9),
                          margin: 0,
                          boxShadow: [],
                          onTap: model.openSuperUserSettingsDialog,
                          //model.logout();
                        ),
                    ],
                  ),
                ),
                Expanded(
                  child: AnimatedOpacity(
                    duration: Duration(milliseconds: 100),
                    opacity: model.isMenuOpen ? 0 : 1,
                    child: OutlineBox(
                      width: 80,
                      height: 60,
                      text: "QUESTS",
                      color: kDarkTurquoise,
                      textColor: Colors.white,
                      borderWidth: 0,
                      onPressed: model.showQuestListOverlay,
                    ),
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
