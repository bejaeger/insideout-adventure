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
      viewModelBuilder: () =>
          CollectCreditsDialogViewModel(status: request.data["status"]),
      builder: (context, model, child) => WillPopScope(
        onWillPop: () async {
          return false;
        },
        child: Dialog(
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
    print("------------------------------------");
    print(model.status);
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
                    Text(
                        model.hasCollectedCreditsInDialog
                            ? "SUCCESS!"
                            : "Congratulations!",
                        textAlign: TextAlign.center,
                        style: textTheme(context).headline6!.copyWith(
                            color: kPrimaryColor,
                            fontSize: 32,
                            fontWeight: FontWeight.w800)),
                    verticalSpaceSmall,
                    Text(
                        model.isNeedToCollectCredits
                            ? "You get " +
                                request.data["activeQuest"].quest.afkCredits
                                    .toString() +
                                " AFK Credits"
                            : "You mastered this mission and earned " +
                                request.data["activeQuest"].quest.afkCredits
                                    .toString() +
                                " AFK Credits!",
                        textAlign: TextAlign.center,
                        style: textTheme(context)
                            .headline4!
                            .copyWith(color: kPrimaryColor, fontSize: 18)),
                    verticalSpaceSmall,
                    AnimatedSwitcher(
                      duration: Duration(milliseconds: 1),
                      child: !model.hasCollectedCreditsInDialog
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
                    if (model.isNoNetwork)
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: const Text(
                            "Please make sure you have an active network connection.",
                            style: TextStyle(color: Colors.red),
                            textAlign: TextAlign.center),
                      ),
                    if (model.isNoNetwork) verticalSpaceTiny,
                    model.isNeedToCollectCredits
                        ? ElevatedButton(
                            onPressed: model.getCredits,
                            child: Text("Get Credits",
                                style: textTheme(context)
                                    .headline6!
                                    .copyWith(color: kWhiteTextColor)))
                        : ElevatedButton(
                            onPressed: () =>
                                completer(DialogResponse(confirmed: true)),
                            child: Text(
                              "Continue",
                              style: textTheme(context)
                                  .headline6!
                                  .copyWith(color: kWhiteTextColor),
                            ),
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
