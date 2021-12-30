import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/ui/custom_dialogs/collect_credits/collect_credits_dialog_viewmodel.dart';
import 'package:flutter/material.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
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
      viewModelBuilder: () => CollectCreditsDialogViewModel(),
      builder: (context, model, child) => Dialog(
        elevation: 5,
        //insetPadding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
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
    );
  }
}

class _BasicDialogContent extends StatelessWidget {
  final CollectCreditsDialogViewModel model;
  final DialogRequest request;
  final Function(DialogResponse dialogResponse) completer;

  _BasicDialogContent({
    Key? key,
    required this.request,
    required this.completer,
    required this.model,
  }) : super(key: key);

  final log = getLogger("CollectCreditsDialogView");

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        AnimatedOpacity(
          duration: Duration(milliseconds: 500),
          opacity: model.isBusy ? 0.0 : 1.0,
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
                    Text(model.collectedCredits ? "ERFOLG!" : "Gratulation!",
                        textAlign: TextAlign.center,
                        style: textTheme(context).headline6!.copyWith(
                            color: kPrimaryColor,
                            fontSize: 32,
                            fontWeight: FontWeight.w800)),
                    verticalSpaceSmall,
                    Text(
                        model.collectedCredits
                            ? "Du verdienst " +
                                request.data.quest.afkCredits.toString() +
                                " AFK Credits"
                            : "Du hast " +
                                request.data.quest.afkCredits.toString() +
                                " AFK Credits verdient!",
                        textAlign: TextAlign.center,
                        style: textTheme(context)
                            .headline4!
                            .copyWith(color: kPrimaryColor, fontSize: 18)),
                    verticalSpaceSmall,
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 1),
                      child: !model.collectedCredits
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(kAFKCreditsLogoPath,
                                  width: screenWidth(context, percentage: 0.4)),
                            )
                          : FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(
                                Icons.check,
                                size: 200,
                                color: kPrimaryColor,
                              ),
                            ),
                    ),
                    verticalSpaceMedium,
                    !model.collectedCredits
                        ? ElevatedButton(
                            onPressed: model.getCredits,
                            child: Text("Weiter",
                                style: textTheme(context)
                                    .headline6!
                                    .copyWith(color: kWhiteTextColor)))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () => completer(
                                      DialogResponse(confirmed: true)),
                                  child: Text("Zurück",
                                      style: textTheme(context)
                                          .headline6!
                                          .copyWith(
                                              color: kBlackHeadlineColor))),
                            ],
                          )
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
              opacity: model.isBusy ? 1.0 : 0.0,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  CircularProgressIndicator(color: kPrimaryColor),
                  verticalSpaceMedium,
                  Text("Getting credits...",
                      style: textTheme(context).headline6),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}
