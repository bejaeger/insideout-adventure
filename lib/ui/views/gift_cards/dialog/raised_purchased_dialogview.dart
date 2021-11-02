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
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              if (request.data.imageUrl != null)
                Image.network(
                  request.data.imageUrl!,
                  fit: BoxFit.fill,
                ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text(formatAmount(request.data.amount)),
                  horizontalSpaceSmall,
                  Text(
                    request.data.categoryName.toString(),
                  ),
                  horizontalSpaceSmall,
                  Text(formatAmount(request.data.amount)),
                ],
              ),
              horizontalSpaceSmall,
              Text("Price in AFK Credits: To Be Added"),
              Text("Available Credits: " +
                  model.currentUserStats.afkCreditsBalance.toString()),
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
                  MaterialButton(
                    onPressed: () => completer(DialogResponse(confirmed: true)),
                    child: Text(
                      request.mainButtonTitle.toString(),
                      style: TextStyle(
                          fontSize: 20,
                          //fontWeight: FontWeight.bold,
                          color: Colors.black),
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
