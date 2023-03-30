import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/datamodels/quests/active_quests/activated_quest.dart';
import 'package:afkcredits/enums/connectivity_type.dart';
import 'package:afkcredits/ui/custom_dialogs/collect_credits/collect_credits_dialog_viewmodel.dart';
import 'package:afkcredits/ui/widgets/animations/confetti_from_top.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:provider/provider.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

class CollectCreditsDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const CollectCreditsDialogView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<CollectCreditsDialogViewModel>.reactive(
      viewModelBuilder: () =>
          CollectCreditsDialogViewModel(status: request.data["status"]),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Dialog(
          elevation: 5,
          insetPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 30),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16.0),
          ),
          backgroundColor: Colors.white,
          child: _BasicDialogContent(
            request: request,
            completer: completer,
            model: model,
          ),
        ),
      ),
    );
  }
}

class _BasicDialogContent extends StatefulWidget {
  final CollectCreditsDialogViewModel model;
  final DialogRequest request;
  final Function(DialogResponse dialogResponse) completer;

  _BasicDialogContent({
    Key? key,
    required this.request,
    required this.completer,
    required this.model,
  }) : super(key: key);

  @override
  State<_BasicDialogContent> createState() => _BasicDialogContentState();
}

class _BasicDialogContentState extends State<_BasicDialogContent> {
  final log = getLogger("CollectCreditsDialogView");
  late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    _confettiController =
        ConfettiController(duration: const Duration(seconds: 10));
    _confettiController.play();
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    ActivatedQuest? activeQuest = widget.request.data["activeQuest"];
    var connectionStatus = Provider.of<ConnectivityType>(context);
    return Stack(
      children: [
        AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: widget.model.isBusy ? 0.0 : 1.0,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                padding: const EdgeInsets.only(
                  top: 32,
                  left: 16,
                  right: 16,
                  bottom: 32,
                ),
                alignment: Alignment.center,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    verticalSpaceSmall,
                    Text(
                        widget.model.hasCollectedCreditsInDialog
                            ? "SUCCESS!"
                            : "Congratulations!",
                        textAlign: TextAlign.center,
                        style: textTheme(context).headline6!.copyWith(
                            color: kcBlackHeadlineColor,
                            fontSize: 32,
                            fontWeight: FontWeight.w800)),
                    verticalSpaceSmall,
                    if (activeQuest?.quest != null)
                      InsideOutText.body(
                          widget.model.isNeedToCollectCredits
                              ? "You get " +
                                  activeQuest!.quest.afkCredits.toString() +
                                  " credits"
                              : "You mastered this mission and earned " +
                                  activeQuest!.quest.afkCredits.toString() +
                                  " Hercules credits!",
                          align: TextAlign.center),
                    if (connectionStatus == ConnectivityType.Offline)
                      verticalSpaceSmall,
                    if (connectionStatus == ConnectivityType.Offline)
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          InsideOutText.body(
                            "Waiting for data connection...",
                            align: TextAlign.center,
                          ),
                          InsideOutText.body("WARNING: Don't close the app!"),
                          verticalSpaceSmall,
                          CircularProgressIndicator(color: kcPrimaryColor),
                          verticalSpaceSmall,
                        ],
                      ),

                    if (activeQuest?.quest == null &&
                        !widget.model.isNeedToCollectCredits)
                      InsideOutText.warn(
                          "Error: Unfortunately something went wrong when finishing the quest. Please let the developers know."),
                    verticalSpaceSmall,
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 1),
                      child: !widget.model.hasCollectedCreditsInDialog
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(
                                kAFKCreditsLogoPath,
                                color: kcPrimaryColor,
                                width: screenWidth(context, percentage: 0.4),
                              ),
                            )
                          : FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(
                                Icons.check,
                                size: 200,
                                color: kcPrimaryColor,
                              ),
                            ),
                    ),
                    verticalSpaceMedium,
                    // if (connectionStatus == ConnectivityType.Offline)
                    //   Column(
                    //     crossAxisAlignment: CrossAxisAlignment.center,
                    //     mainAxisAlignment: MainAxisAlignment.center,
                    //     children: [
                    //       InsideOutText.body("WARNING: Don't close the app!"),
                    //       InsideOutText.body(
                    //         "Waiting for data connection...",
                    //         align: TextAlign.center,
                    //       ),
                    //       verticalSpaceSmall,
                    //       CircularProgressIndicator(color: kcPrimaryColor),
                    //     ],
                    //   ),
                    // Padding(
                    //   padding: const EdgeInsets.symmetric(horizontal: 20),
                    //   child: const Text(
                    //       "Please make sure you have an active network connection.",
                    //       style: TextStyle(color: Colors.red),
                    //       textAlign: TextAlign.center),
                    // ),
                    if (widget.model.isNoNetwork) verticalSpaceTiny,
                    if (connectionStatus != ConnectivityType.Offline)
                      widget.model.isNeedToCollectCredits
                          ? InsideOutButton(
                              width: 150,
                              disabled:
                                  connectionStatus == ConnectivityType.Offline,
                              onTap:
                                  connectionStatus == ConnectivityType.Offline
                                      ? null
                                      : widget.model.getCredits,
                              title: "Get credits",
                              trailing: Icon(Icons.arrow_forward,
                                  size: 20, color: Colors.white),
                            )
                          : InsideOutButton(
                              width: 150,
                              onTap: () => widget
                                  .completer(DialogResponse(confirmed: true)),
                              title: "Continue",
                              trailing: Icon(Icons.arrow_forward,
                                  size: 20, color: Colors.white),
                            ),
                  ],
                ),
              ),
            ],
          ),
        ),
        Positioned.fill(
          child: Align(
            alignment: Alignment.center,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 50),
              opacity: widget.model.isBusy ? 1.0 : 0.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: kcPrimaryColor),
                  verticalSpaceMedium,
                  Text("Getting credits...",
                      style: textTheme(context).headline6),
                ],
              ),
            ),
          ),
        ),
        ConfettieFromTop(confettiController: _confettiController),
      ],
    );
  }
}
