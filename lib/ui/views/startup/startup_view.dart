import 'dart:async';

import 'package:afkcredits/ui/views/startup/startup_viewmodel.dart';
import 'package:afkcredits/ui/widgets/insideout_logo.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked/stacked.dart';
import 'package:new_version/new_version.dart';

class StartUpView extends StatelessWidget {
  const StartUpView({Key? key}) : super(key: key);

  Future runNewVersionLogic(BuildContext context, Completer completer) async {
    final newVersion = NewVersion(
        // iOSId: 'com.google.Vespa',
        // androidId: 'com.google.android.apps.cloudconsole',
        );
    final VersionStatus? versionStatus = await newVersion.getVersionStatus();
    if (versionStatus != null) {
      newVersion.showUpdateDialog(
          context: context, versionStatus: versionStatus);
    }

    // BASIC
    // newVersion.showAlertIfNecessary(context: context);

    // ADVCANCED WITH CUSTOM CASE
    // final status = await newVersion.getVersionStatus();
    // if (status != null) {
    //   debugPrint(status.releaseNotes);
    //   debugPrint(status.appStoreLink);
    //   debugPrint(status.localVersion);
    //   debugPrint(status.storeVersion);
    //   debugPrint(status.canUpdate.toString());
    //   newVersion.showUpdateDialog(
    //     context: context,
    //     versionStatus: status,
    //     dialogTitle: 'Custom Title',
    //     dialogText: 'Custom Text',
    //   );
    // }
    completer.complete();
  }

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<StartUpViewModel>.reactive(
      onModelReady: (model) async {
        Completer completer = Completer();
        SchedulerBinding.instance.addPostFrameCallback(
          (timeStamp) async {
            await runNewVersionLogic(context, completer);
          },
        );
        await completer.future;
        model.runStartupLogic();
      },
      viewModelBuilder: () => StartUpViewModel(),
      builder: (context, model, child) => model.showLoadingScreen()
          ? Scaffold(
              body: Center(
                child: InsideOutLogo(isBusy: true, center: true),
              ),
            )
          : Scaffold(
              body: Center(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Failure to log in",
                          style: textTheme(context).headline2),
                      verticalSpaceMedium,
                      Text(
                          "Unfortunately, there was an error when logging. Please contact our support"),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}
