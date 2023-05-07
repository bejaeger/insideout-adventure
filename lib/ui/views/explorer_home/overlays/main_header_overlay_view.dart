import 'package:afkcredits/constants/constants.dart';
import 'package:afkcredits/constants/inside_out_credit_system.dart';
import 'package:afkcredits/ui/views/explorer_home/overlays/main_header_overlay_viewmodel.dart';
import 'package:afkcredits/ui/widgets/credits_to_screentime_widget.dart';
import 'package:afkcredits/ui/widgets/custom_drop_down_menu.dart';
import 'package:afkcredits/ui/widgets/explorer_home_widgets/avatar_overlay.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

class MainHeaderOverlayView extends StatelessWidget {
  final bool show;
  final int avatarIdx;
  const MainHeaderOverlayView(
      {Key? key, required this.show, required this.avatarIdx})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<MainHeaderOverlayViewModel>.reactive(
      viewModelBuilder: () => MainHeaderOverlayViewModel(),
      builder: (context, model, child) => IgnorePointer(
        ignoring: !show,
        child: AnimatedOpacity(
          opacity: show ? 1 : 0,
          duration: Duration(milliseconds: 500),
          child: Container(
            alignment: Alignment.bottomCenter,
            height: 90,
            //color: Colors.blue.withOpacity(0.5),
            padding: const EdgeInsets.only(
                left: kHorizontalPadding, right: 10, top: 15, bottom: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: const EdgeInsets.only(
                      top: 3, right: 5.0, bottom: 17.0, left: 5.0),
                  child: AvatarOverlay(
                    percentage: model.percentageOfNextLevel,
                    level: model.currentLevel(),
                    onPressed: model.showExplorerAccountOverlay,
                    avatarIdx: avatarIdx,
                  ),
                ),
                //Spacer(),
                horizontalSpaceSmall,
                GestureDetector(
                  onTap: model.showCreditsOverlay,
                  child: Center(
                    child: Container(
                        padding: const EdgeInsets.only(
                            right: 15.0, top: 14, bottom: 4.0, left: 8.0),
                        child: CreditsAmount(
                          amount:
                              model.currentUserStats.afkCreditsBalance.toInt(),
                          spacing: 4,
                          height: 22,
                        )),
                  ),
                ),
                horizontalSpaceRegular,
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: CustomDropDownMenu(
                    color: kcGreenDark,
                    icon1: Icon(Icons.settings, color: kcMediumGrey, size: 22),
                    onTap1: model.showExplorerSettingsDialog,
                    text1: 'Settings',
                    icon2: Icon(Icons.logout, color: kcMediumGrey, size: 22),
                    onTap2: model.handleLogoutEvent,
                    text2: 'Logout',
                    icon3: model.isSuperUser
                        ? Icon(Icons.person, color: kcMediumGrey, size: 22)
                        : null,
                    text3: model.isSuperUser ? "Super Settings" : null,
                    onTap3: model.isSuperUser
                        ? model.openSuperUserSettingsDialog
                        : null,
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
