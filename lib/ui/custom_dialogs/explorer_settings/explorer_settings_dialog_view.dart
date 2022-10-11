import 'package:afkcredits/ui/custom_dialogs/explorer_settings/explorer_settings_dialog_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class ExplorerSettingsDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const ExplorerSettingsDialogView(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<ExplorerSettingsDialogViewModel>.reactive(
      viewModelBuilder: () => ExplorerSettingsDialogViewModel(),
      builder: (context, model, child) {
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
                      child: AfkCreditsText.headingFour("Settings"),
                    ),
                    verticalSpaceMedium,
                    SwitchListTile(
                      dense: true,
                      title: Text("Augmented reality"),
                      subtitle: Text("Use augmented reality for quests?"),
                      value: model.isUsingAR,
                      onChanged: (bool value) =>
                          model.setARFeatureEnabled(value),
                    ),
                    SwitchListTile(
                      dense: true,
                      title: Text("Show avatar animation on map"),
                      subtitle: Text(
                          "Turning off avatar can make the app run smoother"),
                      value: model.isShowAvatarAndMapEffects,
                      onChanged: (bool value) =>
                          model.setIsShowAvatarAndMapEffects(value),
                    ),
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
