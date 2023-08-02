import 'package:afkcredits/ui/views/permissions/permissions_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_safe_area.dart';
import 'package:afkcredits/ui/widgets/insideout_logo.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
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
        return CustomSafeArea(
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
                      InsideOutText.headingThree(
                          "Cannot use app without permissions",
                          align: TextAlign.center),
                      verticalSpaceSmall,
                      InsideOutText.headingFourLight(
                          "Please make sure your location service is enabled and restart the app",
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
                      InsideOutLogo(),
                    ],
                  )),
        );
      },
    );
  }
}
