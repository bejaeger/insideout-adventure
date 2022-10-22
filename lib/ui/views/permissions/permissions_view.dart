import 'package:afkcredits/ui/views/permissions/permissions_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/custom_app_bar.dart';
import 'package:afkcredits/ui/widgets/hercules_world_logo.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';

// view that asks for all permissions necessary for the app
class PermissionsView extends StatelessWidget {
  const PermissionsView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<PermissionsViewModel>.reactive(
      viewModelBuilder: () => PermissionsViewModel(),
      onModelReady: (model) async {
        model.runPermissionLogic();
      },
      builder: (context, model, child) {
        return SafeArea(
          child: model.showReinstallScreen
              ? Container(
                  height: screenHeight(context),
                  width: screenWidth(context),
                  color: kcGreenWhiter,
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      AfkCreditsText.headingThree(
                          "Cannot use app without permissions",
                          align: TextAlign.center),
                      verticalSpaceSmall,
                      AfkCreditsText.headingFourLight(
                          "Please allow us to use your location. You can re-install the app and we will ask you for permission again.",
                          align: TextAlign.center),
                    ],
                  ),
                )
              : Container(
                  height: screenHeight(context),
                  width: screenWidth(context),
                  color: kcPrimaryColor,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      verticalSpaceLarge,
                      HerculesWorldLogo(),
                    ],
                  )),
        );
      },
    );
  }
}
