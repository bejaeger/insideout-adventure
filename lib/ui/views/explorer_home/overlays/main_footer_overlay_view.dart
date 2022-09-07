import 'package:afkcredits/ui/views/common_viewmodels/main_footer_viewmodel.dart';
import 'package:afkcredits/ui/widgets/fading_widget.dart';
import 'package:afkcredits/ui/widgets/outline_box.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MainFooterOverlayView extends StatelessWidget {
  final bool show;
  const MainFooterOverlayView({
    Key? key,
    required this.show,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // log.wtf("==>> Rebuild MainFooterView");
    return ViewModelBuilder<MainFooterViewModel>.reactive(
      viewModelBuilder: () => MainFooterViewModel(),
      //onModelReady: (model) => model.listenToLayout(),
      onModelReady: (model) {
        // TODO: Move somewhere else!
        // TODO: Needs to go into onboarding!
        AwesomeNotifications().isNotificationAllowed().then(
          (isAllowed) {
            if (!isAllowed) {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: const Text('Allow Notications'),
                  content:
                      const Text("We would like to send you notifications"),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Don\'t Allow'),
                    ),
                    verticalSpaceMedium,
                    TextButton(
                      onPressed: () => AwesomeNotifications()
                          .requestPermissionToSendNotifications()
                          .then(
                            (_) => Navigator.pop(context),
                          ),
                      child: const Text('Allow'),
                    ),
                  ],
                ),
              );
            }
          },
        );

        return model.listenToLayout();
      },
      builder: (context, model, child) => Container(
        child: Padding(
          padding: const EdgeInsets.only(left: 15, right: 15, bottom: 20),
          //alignment: Alignment.bottomCenter,
          child: FadingWidget(
            show: show,
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
                      borderWidth: model.isScreenTimeActive ? 4 : 0,
                      borderColor: model.isScreenTimeActive ? kcRed : null,
                      text: "SCREEN TIME",
                      onPressed: model.navToSelectScreenTimeView,
                      color: kcPrimaryColor,
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
                    toggleButtonColor: kcPrimaryColor,
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
                      color: kcPrimaryColor,
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
