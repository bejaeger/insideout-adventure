import 'package:afkcredits/ui/custom_dialogs/ward_settings_for_guardian/ward_settings_for_guardian_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class WardSettingsForGuardianDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const WardSettingsForGuardianDialogView(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<WardSettingsForGuardianDialogViewModel>.reactive(
      viewModelBuilder: () => WardSettingsForGuardianDialogViewModel(
          wardUid: request.data["wardUid"]),
      builder: (context, model, child) {
        String? name = request.data["name"];
        if (name == null) {
          name = "your child";
        }
        return Dialog(
          elevation: 5,
          insetPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
          backgroundColor: Colors.white,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: SingleChildScrollView(
              child: Container(
                constraints: BoxConstraints(
                  minHeight: screenHeight(context, percentage: 0.3),
                ),
                padding: const EdgeInsets.symmetric(vertical: 15),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 18.0),
                      child: InsideOutText.headingFour("Settings"),
                    ),
                    verticalSpaceMedium,
                    SwitchListTile(
                      dense: true,
                      title: Text("Verify screen time"),
                      subtitle: Text(
                          "You need to accept the screen time requested by $name before the timer starts"),
                      value: model.isAcceptScreenTimeFirstTmp,
                      onChanged: (bool value) =>
                          model.setIsAcceptScreenTime(value),
                    ),
                    SwitchListTile(
                      dense: true,
                      title: Text("Uses his/her own phone"),
                      subtitle: Text("Does $name use his or her own phone?"),
                      value: model.isUsingOwnPhoneTmp,
                      onChanged: (bool value) =>
                          model.setIsUsingOwnPhone(value),
                    ),
                    // SwitchListTile(
                    //   dense: true,
                    //   title: Text("Show avatar animation on map"),
                    //   subtitle: Text(
                    //       "Turning off avatar can make the app run smoother"),
                    //   value: model.isShowAvatarAndMapEffects,
                    //   onChanged: (bool value) =>
                    //       model.setIsShowAvatarAndMapEffects(value),
                    // ),
                    // SwitchListTile(
                    //   dense: true,
                    //   title: Text("Show completed search quests"),
                    //   subtitle: Text(
                    //       "Clean-up your map by making completed quests invisible"),
                    //   value: model.isShowingCompletedQuests,
                    //   onChanged: (bool value) =>
                    //       model.setIsShowingCompletedQuests(value),
                    // ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
