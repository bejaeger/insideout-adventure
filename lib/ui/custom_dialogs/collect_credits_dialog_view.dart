import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/enums/collect_credits_status.dart';
import 'package:afkcredits/ui/custom_dialogs/collect_credits_dialog_viewmodel.dart';
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
              elevation: 0,
              backgroundColor: Colors.transparent,
              child: _BasicDialogContent(
                request: request,
                completer: completer,
                model: model,
              ),
            ));
  }
}

class _BasicDialogContent extends StatelessWidget {
  final dynamic model;
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
    return Stack(children: [
      if (!model.isBusy) ...[
        AnimatedOpacity(
          duration: Duration(milliseconds: 1500),
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
                    verticalSpaceSmall,
                    Text("CONGRATULATIONS!",
                        style: textTheme(context)
                            .headline5!
                            .copyWith(color: kPrimaryColor)),
                    Text("You found the Trophy",
                        style: textTheme(context)
                            .headline6!
                            .copyWith(color: kPrimaryColor)),
                    verticalSpaceSmall,
                    AnimatedSwitcher(
                      duration: Duration(seconds: 2),
                      child: model.status == CreditsCollectionStatus.toCollect
                          ? Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Image.asset(kAFKCreditsLogoPath),
                            )
                          : FittedBox(
                              fit: BoxFit.fill,
                              child: Icon(
                                Icons.check,
                                size: 10000,
                                color: kPrimaryColor,
                              ),
                            ),
                    ),
                    if (request.data?.quest?.afkCredits != null)
                      AnimatedSwitcher(
                        duration: Duration(seconds: 2),
                        child: model.status == CreditsCollectionStatus.toCollect
                            ? Text(
                                "It's worth " +
                                    request.data.quest.afkCredits.toString() +
                                    " Credits!",
                                style: textTheme(context)
                                    .headline6!
                                    .copyWith(color: kPrimaryColor))
                            : Text(
                                "Successfully collected " +
                                    request.data.quest.afkCredits.toString() +
                                    " credits",
                                style: textTheme(context)
                                    .headline6!
                                    .copyWith(color: kPrimaryColor)),
                      ),
                    verticalSpaceMedium,
                    model.status == CreditsCollectionStatus.toCollect
                        ? ElevatedButton(
                            onPressed: model.collectCredits,
                            child: Text("Collect Your Credits",
                                style: textTheme(context)
                                    .headline6!
                                    .copyWith(color: kWhiteTextColor)))
                        : Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              TextButton(
                                  onPressed: () => completer(
                                      DialogResponse(confirmed: true)),
                                  child: Text("Go back",
                                      style: textTheme(context)
                                          .headline6!
                                          .copyWith(
                                              color: kBlackHeadlineColor))),
                            ],
                          )
                  ],
                ),
              ),
              // AnimatedOpacity(
              //   duration: Duration(milliseconds: 500),
              //   opacity: model.status == CreditsCollectionStatus.toCollect
              //       ? 0.0
              //       : 1.0,
              //   child: Positioned(
              //     top: -28,
              //     child: CircleAvatar(
              //       minRadius: 16,
              //       maxRadius: 28,
              //       backgroundColor: kPrimaryColor,
              //       child: Icon(
              //         Icons.check,
              //         size: 28,
              //         color: Colors.white,
              //       ),
              //     ),
              //   ),
              // ),
            ],
          ),
        ),
      ],
    ]);
  }
}
