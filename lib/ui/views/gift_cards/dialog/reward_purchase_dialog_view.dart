import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/image_urls.dart';
import 'package:afkcredits/ui/widgets/stats_card.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'package:transparent_image/transparent_image.dart';
import 'reward_purchase_dialog_viewmodel.dart';

class RewardPurchaseDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  final bool isScreenTime;
  const RewardPurchaseDialogView({
    Key? key,
    required this.request,
    required this.completer,
    required this.isScreenTime,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RewardPurchaseDialogViewModel>.reactive(
      builder: (context, model, child) => Dialog(
        elevation: 5,
        insetPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 50),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
        backgroundColor: Colors.white,
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            //mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (isScreenTime ||
                  (!isScreenTime && request.data?.imageUrl != null))
                Center(
                  child: FadeInImage.memoryNetwork(
                    fadeInDuration: Duration(milliseconds: 200),
                    placeholder: kTransparentImage,
                    image: isScreenTime
                        ? kScreenTimeImageUrl
                        : request.data.imageUrl!,
                    height: 150,
                    //fit: BoxFit.fill,
                  ),
                ),
              verticalSpaceSmall,
              Center(
                child: Text(
                  isScreenTime
                      ? "Voucher for ${request.data.hours} hours screen time"
                      : formatAmount(request.data.amount) +
                          " " +
                          request.data.categoryName.toString() +
                          " gift card",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
              verticalSpaceMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Price: ", style: textTheme(context).headline4),
                  AFKCreditsIcon(height: 50),
                  Text(centsToAfkCredits(request.data.amount).toString(),
                      style: textTheme(context).headline4),
                ],
              ),
              model.hasEnoughCredits(
                      credits: centsToAfkCredits(request.data.amount))
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Available:"),
                        AFKCreditsIcon(
                          height: 25,
                          alignment: Alignment.centerRight,
                        ),
                        horizontalSpaceTiny,
                        Text(model.currentUserStats.afkCreditsBalance
                            .toString()),
                      ],
                    )
                  : Center(
                      child: Text("Not enough credits",
                          //textAlign: TextAlign.center,
                          style: textTheme(context)
                              .bodyText1!
                              .copyWith(color: Colors.red)),
                    ),
              verticalSpaceMedium,
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    onPressed: () =>
                        completer(DialogResponse(confirmed: false)),
                    child: Text(
                      request.secondaryButtonTitle.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                          color: Colors.black),
                    ),
                  ),
                  ElevatedButton(
                    onPressed: model.hasEnoughCredits(
                            credits: centsToAfkCredits(request.data.amount))
                        ? () => completer(DialogResponse(confirmed: true))
                        : null,
                    child: Text(
                      request.mainButtonTitle.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                          color: kWhiteTextColor),
                    ),
                  )
                ],
              ),
            ],
          ),
        ),
      ),
      viewModelBuilder: () => RewardPurchaseDialogViewModel(),
    );
  }
}
