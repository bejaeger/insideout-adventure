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
        alignment: Alignment.bottomCenter,
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
                  Container(width: 100),
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
