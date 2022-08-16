import 'package:afkcredits/datamodels/payments/money_transfer.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class TransferListTile extends StatelessWidget {
  final num amount;
  final MoneyTransfer transaction;
  final String? descriptor;
  final String? senderName;
  final bool showBottomDivider;
  final bool showTopDivider;
  final bool dense;
  final Color backgroundColor;
  final void Function()? onTap;

  const TransferListTile(
      {Key? key,
      required this.amount,
      required this.transaction,
      this.showBottomDivider = true,
      this.showTopDivider = false,
      this.dense = false,
      this.onTap,
      this.backgroundColor = kcBlue,
      this.descriptor,
      this.senderName})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showTopDivider == true)
            Divider(
              color: Colors.grey[500],
              thickness: 0.5,
            ),
          ListTile(
            visualDensity: VisualDensity.compact,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            leading: CircleAvatar(
                backgroundColor: backgroundColor,
                child: Text(getInitialsFromName(
                    transaction.transferDetails.recipientName))),
            // FlutterLogo(),
            title: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (descriptor != null)
                  Text(
                    descriptor!,
                    style: textTheme(context).bodyText2!.copyWith(
                          fontSize: dense ? 13 : 15,
                        ),
                  ),
                Text(transaction.transferDetails.recipientName,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style:
                        textTheme(context).headline6!.copyWith(fontSize: 16)),
              ],
            ),
            // @see https://api.flutter.dev/flutter/intl/DateFormat-class.html
            //.add_jm()
            subtitle: Text(
              formatDate(transaction.createdAt.toDate()),
              style: textTheme(context).bodyText2!.copyWith(
                    fontSize: dense ? 13 : 15,
                  ),
            ),
            trailing: Text(
              formatAmount(amount),
            ),
          ),
          if (showBottomDivider == true)
            Divider(
              color: Colors.grey[500],
              thickness: 0.5,
            ),
        ],
      ),
    );
  }
}
