import 'package:afkcredits/enums/super_user_dialog_type.dart';
import 'package:afkcredits/ui/custom_dialogs/super_user_dialog/super_user_dialog_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class SuperUserDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;

  const SuperUserDialogView(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<SuperUserDialogViewModel>.reactive(
      viewModelBuilder: () => SuperUserDialogViewModel(),
      builder: (context, model, child) {
        return request.data == SuperUserDialogType.sendDiagnostics
            ? Dialog(
                elevation: 5,
                insetPadding:
                    EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
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
                        child: model.addingPositionToNotionDB
                            ? AFKProgressIndicator()
                            : Column(
                                children: [
                                  Text("Warning",
                                      style: textTheme(context).headline4),
                                  Text("(super user feature)"),
                                  verticalSpaceSmall,
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                            "Some quest data points have not yet been uploaded (maybe due to network connection outages). Please consider sending diagnostics when you have network connection."),
                                      ),
                                    ],
                                  ),
                                  verticalSpaceSmall,
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                            "# uploaded / available data points: "),
                                      ),
                                      Spacer(),
                                      Expanded(
                                        child: Text(model.numberPushedLocations
                                                .toString() +
                                            " / " +
                                            model.allRecordedLocations.length
                                                .toString()),
                                      ),
                                    ],
                                  ),
                                  verticalSpaceMedium,
                                  ElevatedButton(
                                    onPressed: model.pushAllPositionsToNotion,
                                    child: Text("Send diagnostics"),
                                  ),
                                  verticalSpaceMedium,
                                  TextButton(
                                    onPressed: () => completer(
                                        DialogResponse(confirmed: true)),
                                    child: model.isAllPositionsPushed
                                        ? Text(
                                            "Continue",
                                          )
                                        : Text(
                                            "Don't send diagnostics and continue",
                                          ),
                                  ),
                                ],
                              ),
                      ),
                    ],
                  ),
                ),
              )
            : Dialog(
                elevation: 5,
                insetPadding:
                    EdgeInsets.symmetric(horizontal: 30, vertical: 50),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16.0)),
                backgroundColor: Colors.white,
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SingleChildScrollView(
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
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("is listening to main position?: "),
                                  Text(model.isListeningToMainPosition
                                      .toString()),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("is listening to position?: "),
                                  Text(model.isListeningToPosition.toString()),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("current gps accuracy"),
                                  Text(model.currentGPSAccuracy != null
                                      ? model.currentGPSAccuracy!.toString() +
                                          " m"
                                      : "nan"),
                                ],
                              ),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text("current distance filter: "),
                                  Text(model.currentPositionDistanceFilter
                                          .toString() +
                                      " m"),
                                ],
                              ),
                              Wrap(
                                children: [],
                              )
                            ],
                          ),
                        ),
                        Divider(),
                        SwitchListTile(
                            dense: true,
                            title: Text("Record quest data?"),
                            value: model.isRecordingLocationData,
                            onChanged: (bool value) =>
                                model.setIsRecordingLocationData(value)),
                        SwitchListTile(
                            dense: true,
                            title: Text("Permanent Admin Mode?"),
                            value: model.isPermanentAdminMode,
                            onChanged: (bool value) =>
                                model.setIsPermanentAdminMode(value)),
                        SwitchListTile(
                            dense: true,
                            title: Text("Permanent User Mode?"),
                            value: model.isPermanentUserMode,
                            onChanged: (bool value) =>
                                model.setIsPermanentUserMode(value)),
                        SwitchListTile(
                            dense: true,
                            title: Text("Dummy Marker Collection"),
                            value: model.allowDummyMarkerCollection,
                            onChanged: (bool value) =>
                                model.setAllowDummyMarkerCollection(value)),
                        SwitchListTile(
                            dense: true,
                            title: Text("AR Marker Collection"),
                            value: model.isARAvailable,
                            onChanged: (bool value) =>
                                model.setARFeatureEnabled(value)),
                        SwitchListTile(
                            dense: true,
                            title: Text("Enable GPS Verification"),
                            value: model.enableGPSVerification,
                            onChanged: (bool value) =>
                                model.setEnableGPSVerification(value)),
                        SwitchListTile(
                            dense: true,
                            title: Text("Fake-Complete Quest"),
                            subtitle: Text("Complete quest on next step"),
                            value: model.dummyQuestCompletionVerification,
                            onChanged: (bool value) => model
                                .setDummyQuestCompletionVerification(value)),
                        Row(
                          children: [
                            Text("Add credits cheat"),
                            IconButton(
                              onPressed: model.addCreditsCheat,
                              icon: Icon(Icons.add, size: 30),
                            ),
                            if (model.isCheating) AFKProgressIndicator(),
                          ],
                        ),
                        Row(
                          children: [
                            Text("Remove credits cheat"),
                            IconButton(
                              onPressed: model.deductCreditsCheat,
                              icon: Icon(Icons.remove, size: 30),
                            ),
                            if (model.isCheating) AFKProgressIndicator(),
                          ],
                        ),
                        verticalSpaceMedium,
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            ElevatedButton(
                              onPressed: () =>
                                  completer(DialogResponse(confirmed: true)),
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
      },
    );
  }
}
