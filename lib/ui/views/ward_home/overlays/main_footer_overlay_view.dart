import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/ui/views/common_viewmodels/main_footer_viewmodel.dart';
import 'package:afkcredits/ui/widgets/fading_widget.dart';
import 'package:circular_menu/circular_menu.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';

class MainFooterOverlayView extends StatelessWidget {
  final bool show;
  final bool isUsingScreenTime;
  const MainFooterOverlayView({
    Key? key,
    required this.show,
    this.isUsingScreenTime = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainFooterViewModel>.reactive(
      viewModelBuilder: () => MainFooterViewModel(),
      onModelReady: (model) {
        model.listenToLayout();
      },
      builder: (context, model, child) => Container(
        child: FadingWidget(
          show: show,
          child: Stack(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(left: 15, bottom: 20),
                      child: AnimatedOpacity(
                          duration: Duration(milliseconds: 100),
                          opacity: model.isMenuOpen ? 0 : 1,
                          child: InsideOutButton(
                            title: "",
                            border: isUsingScreenTime
                                ? Border.all(
                                    color: Colors.red,
                                    width: 4,
                                  )
                                : null,
                            color: kcScreenTimeBlue,
                            onTap: () => model.navToSelectScreenTimeView(
                                wardId: model.currentUser.uid,
                                isGuardianAccount: false),
                            height: 60,
                            boxShadow: isUsingScreenTime
                                ? null
                                : mainFooterBoxShadow(),
                            leading: Image.asset(
                              kScreenTimeIcon,
                              color: kcVeryLightGrey,
                              height: 35,
                            ),
                          )),
                    ),
                  ),
                  AnimatedContainer(
                    duration: Duration(milliseconds: 250),
                    width: model.isMenuOpen ? screenWidth(context) : 130,
                    curve: Curves.linear,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 20),
                      child: CircularMenu(
                        toggleButtonOnPressed: () {
                          model.isMenuOpen = !model.isMenuOpen;
                          model.notifyListeners();
                        },
                        toggleButtonBoxShadow: mainFooterBoxShadow(),
                        alignment: Alignment.bottomCenter,
                        startingAngleInRadian: 1.3 * 3.14,
                        endingAngleInRadian: 1.7 * 3.14,
                        toggleButtonColor: kcCultured,
                        toggleButtonIconColor: kcMediumGrey,
                        toggleButtonMargin: 0,
                        toggleButtonSize: 35,
                        radius: model.isSuperUser ? 120 : 90,
                        items: [
                          CircularMenuItem(
                            icon: Icons.settings,
                            color: Colors.grey[600],
                            margin: 0,
                            boxShadow: [],
                            onTap: () {
                              model.showWardSettingsDialog();
                            },
                          ),
                          CircularMenuItem(
                            icon: Icons.logout,
                            color: Colors.redAccent.shade700.withOpacity(0.9),
                            margin: 0,
                            boxShadow: [],
                            onTap: model.handleLogoutEvent,
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
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(right: 15, bottom: 20),
                      child: AnimatedOpacity(
                          duration: Duration(milliseconds: 100),
                          opacity: model.isMenuOpen ? 0 : 1,
                          child: InsideOutButton(
                              title: "",
                              color: kcOrange,
                              onTap: model.showQuestListOverlay,
                              height: 60,
                              leading: Image.asset(
                                kActivityIcon,
                                color: kcVeryLightGrey,
                                height: 35,
                              ),
                              boxShadow: mainFooterBoxShadow())),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<BoxShadow> mainFooterBoxShadow() {
    return [
      BoxShadow(
        offset: Offset(1, 1),
        spreadRadius: 0.5,
        blurRadius: 0.3,
        color: kcShadowColor,
      ),
    ];
  }
}
