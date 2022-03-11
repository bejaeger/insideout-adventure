import 'dart:async';

import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/image_urls.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/screentime/screen_time_purchase.dart';
import 'package:afkcredits/enums/screen_time_voucher_status.dart';
import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits/utils/string_utils.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:transparent_image/transparent_image.dart';

class ScreenTimeVoucher extends StatefulWidget {
  final ScreenTimePurchase screenTimeVoucher;
  final Future Function(ScreenTimePurchase, bool) onTap;
  final void Function(ScreenTimePurchase) onSeeVoucherTap;

  const ScreenTimeVoucher(
      {Key? key,
      required this.screenTimeVoucher,
      required this.onTap,
      required this.onSeeVoucherTap})
      : super(key: key);

  @override
  State<ScreenTimeVoucher> createState() => _ScreenTimeVoucherState();
}

class _ScreenTimeVoucherState extends State<ScreenTimeVoucher> {
  bool showDeactivate = false;
  int timerSeconds = 6;
  Timer? _timer;
  bool isBusy = false;

  bool isActive = false;
  bool isActivating = false;

  void startCounter() {
    resetCounter();
    showDeactivate = true;
    _timer = Timer.periodic(Duration(seconds: 1), _decrement);
  }

  void resetCounter() {
    _timer?.cancel();
    _timer = null;
    showDeactivate = false;
    timerSeconds = 6;
  }

  bool counterEvent() {
    if (_timer == null)
      return false;
    else {
      return timerSeconds % 2 == 0;
    }
  }

  void _decrement(Timer timer) async {
    timerSeconds = 6 - timer.tick;
    if (timerSeconds == 0) {
      isActive = true;
      resetCounter();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    ScreenTimeVoucherStatus status = widget.screenTimeVoucher.status;
    bool isUsed =
        widget.screenTimeVoucher.status == ScreenTimeVoucherStatus.used;
    if (!(widget.screenTimeVoucher.activatedOn is String)) {
      if (!isActive) {
        isActive = DateTime.now().difference(
                    widget.screenTimeVoucher.activatedOn.toDate()) >=
                Duration(seconds: 5) &&
            DateTime.now()
                    .difference(widget.screenTimeVoucher.activatedOn.toDate()) <
                Duration(
                    hours: widget.screenTimeVoucher.hours.toInt(),
                    minutes: widget.screenTimeVoucher.hours < 1 ? 30 : 0) &&
            showDeactivate == false;
      }
      isActivating = DateTime.now()
                  .difference(widget.screenTimeVoucher.activatedOn.toDate()) <=
              Duration(seconds: 5) ||
          showDeactivate == true;
    }
    return GestureDetector(
      onTap: showDeactivate
          ? () {
              isActive = false;
              resetCounter();
              widget.onTap(widget.screenTimeVoucher, true);
              setState(() {});
            }
          : () => widget.onSeeVoucherTap(widget.screenTimeVoucher),
      child: Card(
        clipBehavior: Clip.hardEdge,
        elevation: 1,
        shape: RoundedRectangleBorder(
          side: BorderSide(
              color: !isActive
                  ? kGreyTextColor.withOpacity(0.2)
                  : Colors.green.withOpacity(0.2),
              width: 2),
          borderRadius: BorderRadius.all(
            Radius.circular(16),
          ),
        ),
        child: Container(
          color: counterEvent()
              ? Colors.orange.withOpacity(0.2)
              : !isActive
                  ? (isUsed && !isActivating)
                      ? kGreyTextColor.withOpacity(0.2)
                      : Colors.white70
                  : Colors.green.withOpacity(0.2),
          padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
          height: 160,
          child: Padding(
            padding: const EdgeInsets.only(top: 8.0, right: 8.0, bottom: 4.0),
            child: Column(
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: FadeInImage.memoryNetwork(
                          fadeInDuration: Duration(milliseconds: 200),
                          placeholder: kTransparentImage,
                          image: kScreenTimeImageUrl,
                          placeholderFit: BoxFit.none,
                          height: 70,
                          //fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    Container(
                      width: screenWidth(context, percentage: 0.35),
                      alignment: Alignment.centerRight,
                      //constraints: BoxConstraints(minWidth: 300),
                      child: FittedBox(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Voucher for"),
                            Text(
                                widget.screenTimeVoucher.hours <= 1
                                    ? widget.screenTimeVoucher.hours
                                            .toString() +
                                        " hour"
                                    : widget.screenTimeVoucher.hours
                                            .toString() +
                                        " hours",
                                style: textTheme(context).headline3!.copyWith(
                                    color: kBlackHeadlineColor, fontSize: 32)),
                            Text("screen time"),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                verticalSpaceTiny,
                status == ScreenTimeVoucherStatus.unused || isBusy
                    ? isBusy
                        ? AFKProgressIndicator(
                            //color: Colors.white,
                            alignment: Alignment.center,
                          )
                        : ElevatedButton(
                            onPressed: () async {
                              showDeactivate = true;
                              final result = await widget.onTap(
                                  widget.screenTimeVoucher, false);
                              if (result == true) {
                                showDeactivate = true;
                                setState(() {});
                                startCounter();
                              } else {
                                showDeactivate = false;
                              }
                            },
                            child: Text("Activate"),
                          )
                    : Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          verticalSpaceSmall,
                          if (isActive ||
                              (showDeactivate == false &&
                                  status == ScreenTimeVoucherStatus.used))
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text("Activated on " +
                                    formatDateDetailsType2(widget
                                            .screenTimeVoucher
                                            .activatedOn is String
                                        ? DateTime.now()
                                        : widget.screenTimeVoucher.activatedOn
                                            ?.toDate())),
                              ],
                            ),
                          if (showDeactivate)
                            Text(
                              "Stop Activating " +
                                  timerSeconds.toString() +
                                  "s",
                              style: textTheme(context)
                                  .bodyText1!
                                  .copyWith(color: Colors.red),
                            ),
                          if (isActive && !showDeactivate)
                            Text(
                              "Active",
                              style: textTheme(context)
                                  .bodyText1!
                                  .copyWith(color: Colors.green),
                            ),
                        ],
                      ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
