import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/ui/widgets/stats_card.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';
import 'raised_purchased_dialog_viewmodel.dart';

class RaisedPurchasedDialogView extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const RaisedPurchasedDialogView({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<RaisedPurchasedDialogViewModel>.reactive(
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
              if (request.data.imageUrl != null)
                Center(
                  child: Image.network(
                    request.data.imageUrl!,
                    height: 150,
                    //fit: BoxFit.fill,
                  ),
                ),
              verticalSpaceSmall,
              Center(
                child: Text(
                  formatAmount(request.data.amount) +
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
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Available:"),
                  AFKCreditsIcon(
                    height: 25,
                    alignment: Alignment.centerRight,
                  ),
                  horizontalSpaceTiny,
                  Text(model.currentUserStats.afkCreditsBalance.toString()),
                ],
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
                    onPressed: () => completer(DialogResponse(confirmed: true)),
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
      viewModelBuilder: () => RaisedPurchasedDialogViewModel(),
    );
  }
}
