import 'package:afkcredits/ui/widgets/money_transfer_list_tile.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

import 'package:afkcredits/ui/views/transaction_history/transfers_history_viewmodel.dart';
import 'package:stacked/stacked.dart';

class TransfersHistoryView extends StatelessWidget {
  const TransfersHistoryView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ViewModelBuilder<TransfersHistoryViewModel>.reactive(
      viewModelBuilder: () => TransfersHistoryViewModel(),
      builder: (context, model, child) => Scaffold(
        appBar: AppBar(
          title: Text("All Transfers"),
        ),
        body: ListView(
          children: [
            verticalSpaceMedium,
            model.latestTransfers.isEmpty
                ? model.isBusy
                    ? Center(
                        child: CircularProgressIndicator(),
                      )
                    : Center(
                        child: Text("No transfers on record!"),
                      )
                : ListView.builder(
                    shrinkWrap: true,
                    itemCount: model.latestTransfers.length,
                    itemBuilder: (context, index) {
                      var data = model.latestTransfers[index];
                      return TransferListTile(
                        dense: true,
                        onTap: () => model.showMoneyTransferInfoDialog(data),
                        transaction: data,
                        amount: data.transferDetails.amount,
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
