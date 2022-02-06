import 'package:afkcredits/enums/super_user_dialog_type.dart';
import 'package:afkcredits/ui/custom_dialogs/super_user_dialog/super_user_dialog_viewmodel.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
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
                                Text("# uploaded / available positions: "),
                                Text(model.numberPushedLocations.toString() +
                                    " / " +
                                    model.allRecordedLocations.length
                                        .toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("is listening to position?: "),
                                Text(model.isListeningToPosition.toString()),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("current gps accuracy"),
                                Text(model.currentGPSAccuracy != null
                                    ? model.currentGPSAccuracy!.toString() +
                                        " m"
                                    : "nan"),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text("current distance filter: "),
                                Text(model.currentPositionDistanceFilter
                                        .toString() +
                                    " m"),
                              ],
                            ),
                            Wrap(
                              children: [
                                TextButton(
                                  onPressed: model.resetLocationsList,
                                  child: Text("Reset locations list"),
                                ),
                                TextButton(
                                  onPressed: () {
                                    model.cancelPositionListener();
                                    model.notifyListeners();
                                  },
                                  child: Text("Cancel listener"),
                                ),
                                model.addingPositionToNotionDB
                                    ? AFKProgressIndicator()
                                    : TextButton(
                                        onPressed:
                                            model.pushAllPositionsToNotion,
                                        child: Text("Push to notion"))
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
              );
      },
    );
  }
}
