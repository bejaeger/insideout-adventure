import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/ui/custom_dialogs/super_user_settings/super_user_settings_dialog_viewmodel.dart';
import 'package:afkcredits/ui/widgets/custom_app_bar/activated_quest_panel.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SuperUserSettingsDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const SuperUserSettingsDialogView(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SuperUserSettingsDialogViewModel>.reactive(
      viewModelBuilder: () => SuperUserSettingsDialogViewModel(),
      builder: (context, model, child) => Dialog(
        elevation: 5,
        insetPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.all(12.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(16),
                  color: Colors.grey[200],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("# pushed / recorded positions: "),
                        Text(model.numberPushedLocations.toString() +
                            " / " +
                            model.allRecordedLocations.length.toString()),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text("current gps accuracy"),
                        Text(model.currentGPSAccuracy != null
                            ? model.currentGPSAccuracy!.toString() + " m"
                            : "nan"),
                      ],
                    ),
                    Wrap(
                      children: [
                        TextButton(
                            onPressed: model.resetLocationsList,
                            child: Text("Reset locations list"))
                      ],
                    )
                  ],
                ),
              ),
              Divider(),
              SwitchListTile(
                  title: Text("Record location data?"),
                  subtitle: Text(
                      "Data is recorded during the quest and pushed to notion."),
                  value: model.isRecordingLocationData,
                  onChanged: (bool value) =>
                      model.setIsRecordingLocationData(value)),
              SwitchListTile(
                  title: Text("Permanent Admin Mode?"),
                  subtitle: Text(
                      "Don't show dialog to choose user mode or admin mode but always be admin."),
                  value: model.isPermanentAdminMode,
                  onChanged: (bool value) =>
                      model.setIsPermanentAdminMode(value)),
              SwitchListTile(
                  title: Text("Permanent User Mode?"),
                  subtitle: Text("Same as above but always be user."),
                  value: model.isPermanentUserMode,
                  onChanged: (bool value) =>
                      model.setIsPermanentUserMode(value)),
              verticalSpaceMedium,
              Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: () => completer(DialogResponse(confirmed: true)),
                    child: Text(
                      "Ok",
                    ),
                  ),
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
