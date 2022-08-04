import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/enums/collect_credits_status.dart';
import 'package:afkcredits/enums/distance_check_status.dart';
import 'package:afkcredits/ui/views/active_quest_standalone_ui/active_distance_estimate_quest/dialog/travelled_distance_dialog_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

// ! NOT USED ATM

class TravelledDistanceDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const TravelledDistanceDialogView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TravelledDistanceDialogViewModel>.reactive(
      viewModelBuilder: () => TravelledDistanceDialogViewModel(
          status: CollectCreditsStatus.todo), // hardcoded status here!
      onModelReady: (model) => model.waitForProcess(request: request),
      builder: (context, model, child) => Dialog(
        elevation: 0,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        backgroundColor: Colors.white,
        child: _BasicDialogContent(
          request: request,
          completer: completer,
          model: model,
        ),
      ),
    );
  }
}

class _BasicDialogContent extends StatelessWidget {
  final TravelledDistanceDialogViewModel model;
  final DialogRequest request;
  final Function(DialogResponse dialogResponse) completer;

  _BasicDialogContent({
    Key? key,
    required this.request,
    required this.completer,
    required this.model,
  }) : super(key: key);

  final log = getLogger("TravelledDistanceDialogView");

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
      //if (!model.isBusy)

      AnimatedOpacity(
        duration: Duration(milliseconds: 100),
        opacity: model.isBusy ? 0.0 : 1.0,
        child: Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 32,
                left: 16,
                right: 16,
                bottom: 12,
              ),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  verticalSpaceMedium,
                  if (model.hasCollectedCreditsInDialog) verticalSpaceMedium,
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                            !model.hasCollectedCreditsInDialog
                                ? (model.title ?? '')
                                : "Collected Credits",
                            maxLines: 1,
                            textAlign: TextAlign.center,
                            style: textTheme(context).headline6!.copyWith(
                                fontWeight: FontWeight.w800, fontSize: 28)),
                      ),
                    ],
                  ),
                  if (!model.hasCollectedCreditsInDialog) verticalSpaceMedium,
                  if (!model.hasCollectedCreditsInDialog)
                    Text(
                      model.description ?? '',
                      textAlign: TextAlign.center,
                      style: textTheme(context).headline4!.copyWith(
                          // color: _getStatusColor(model.status),
                          fontSize: 18,
                          fontWeight: FontWeight.w400),
                    ),
                  verticalSpaceLarge,
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      if (model.secondaryButtonTitle != null)
                        TextButton(
                          onPressed: () =>
                              completer(DialogResponse(confirmed: false)),
                          child: Text(
                            model.secondaryButtonTitle!,
                          ),
                        ),
                      model.hasCollectedCreditsInDialog == false
                          ? ElevatedButton(
                              onPressed: model.distanceCheckStatus ==
                                      DistanceCheckStatus.success
                                  ? model.getCredits
                                  : () => completer(
                                      DialogResponse(confirmed: false)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  model.mainButtonTitle ?? '',
                                  style: textTheme(context).headline6!.copyWith(
                                      color: kWhiteTextColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            )
                          : ElevatedButton(
                              onPressed: () =>
                                  completer(DialogResponse(confirmed: true)),
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  "Go Back",
                                  style: textTheme(context).headline6!.copyWith(
                                      color: kWhiteTextColor,
                                      fontSize: 24,
                                      fontWeight: FontWeight.w800),
                                ),
                              ),
                            ),
                    ],
                  ),
                ],
              ),
            ),
            Positioned(
              top: -28,
              child: CircleAvatar(
                minRadius: 20,
                maxRadius: 32,
                backgroundColor: _getStatusColor(model.distanceCheckStatus),
                child: Icon(
                  _getStatusIcon(model.distanceCheckStatus),
                  size: 32,
                  color: Colors.white,
                ),
              ),
            ),

            // Center(
            //   child: Container(
            //     color: Colors.transparent,
            //     width: 50,
            //     height: 50,
            //     child: CircularProgressIndicator(),
            //   ),
            // ),
          ],
        ),
      ),
      Positioned.fill(
        child: Align(
          alignment: Alignment.center,
          child: AnimatedOpacity(
            duration: Duration(milliseconds: 50),
            opacity: model.isBusy ? 1.0 : 0.0,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: kPrimaryColor),
                verticalSpaceMedium,
                Text(
                    model.distanceCheckStatus == DistanceCheckStatus.success
                        ? "Getting credits..."
                        : "Checking distance...",
                    style: textTheme(context).headline6),
              ],
            ),
          ),
        ),
      ),
    ]);
  }

  Color _getStatusColor(DistanceCheckStatus? status) {
    if (status != null) {
      switch (status) {
        case DistanceCheckStatus.failed:
          return Colors.red;
        case DistanceCheckStatus.warning:
          return Colors.amber.shade800;
        default:
          return kPrimaryColor;
      }
    } else {
      return kPrimaryColor;
    }
  }

  IconData _getStatusIcon(DistanceCheckStatus? status) {
    if (status != null) {
      switch (status) {
        case DistanceCheckStatus.failed:
          return Icons.close;
        case DistanceCheckStatus.warning:
          return Icons.warning_amber;
        case DistanceCheckStatus.toofar:
          return Icons.warning_amber;
        case DistanceCheckStatus.notenough:
          return Icons.warning_amber;
        default:
          return Icons.check;
      }
    } else {
      return Icons.check;
    }
  }
}
