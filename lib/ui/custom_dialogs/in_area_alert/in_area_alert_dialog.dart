import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:stacked_services/stacked_services.dart';

class InAreaAlertDialogView extends StatelessWidget {
  final bool isQrCodeInArea;
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const InAreaAlertDialogView({
    Key? key,
    required this.request,
    required this.completer,
    required this.isQrCodeInArea,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 5,
      //insetPadding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16.0)),
      backgroundColor: Colors.white,
      child: _BasicDialogContent(
        request: request,
        completer: completer,
        isQrCodeInArea: isQrCodeInArea,
      ),
    );
  }
}

class _BasicDialogContent extends StatefulWidget {
  final bool isQrCodeInArea;
  final DialogRequest request;
  final Function(DialogResponse dialogResponse) completer;

  _BasicDialogContent({
    Key? key,
    required this.request,
    required this.completer,
    required this.isQrCodeInArea,
  }) : super(key: key);

  @override
  State<_BasicDialogContent> createState() => _BasicDialogContentState();
}

class _BasicDialogContentState extends State<_BasicDialogContent>
    with TickerProviderStateMixin {
  final log = getLogger("InAreaAlertDialogView");
  double height = 10;
  late final AnimationController _controller;
  late final Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.bounceOut,
    );
    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(
                top: 16,
                left: 16,
                right: 16,
                bottom: 16,
              ),
              alignment: Alignment.center,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  verticalSpaceSmall,
                  Text(
                    "Checkpoint in area!",
                    textAlign: TextAlign.center,
                    style: textTheme(context).headline6!.copyWith(
                        color: kPrimaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w800),
                  ),
                  verticalSpaceTiny,
                  FadeTransition(
                    opacity: _animation,
                    child: Text("Look for the marker and scan it",
                        textAlign: TextAlign.center,
                        style: textTheme(context).headline6!.copyWith(
                            color: kPrimaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ),
                  verticalSpaceLarge,
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () async {
                        dynamic scanned =
                            await widget.request.data["scanQrCodeFunction"]();
                        if (scanned is bool && scanned == true) {
                          widget.completer(DialogResponse(confirmed: true));
                        }
                      },
                      child: ScaleTransition(
                        scale: _animation,
                        // duration: Duration(milliseconds: 500),
                        // height: height,
                        child: Container(
                          height: 120,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: kShadowColor,
                                blurRadius: 5,
                                spreadRadius: 2,
                                offset: Offset(2, 2),
                              ),
                            ],
                          ),
                          child: FittedBox(
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: kPrimaryColor,
                                  child: Icon(
                                    Icons.qr_code_scanner,
                                    //size: 100,
                                    color: Colors.grey[50],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  verticalSpaceTiny,
                  if (widget.isQrCodeInArea)
                    ScaleTransition(
                      scale: _animation,
                      // duration: Duration(milliseconds: 500),
                      // height: height,
                      child: Text(
                        "OPEN SCANNER",
                        style: textTheme(context)
                            .headline6!
                            .copyWith(color: kPrimaryColor),
                      ),
                    ),
                  verticalSpaceLarge,
                  //QrCodeButton(),
                  FadeTransition(
                    opacity: _animation,
                    child: TextButton(
                      onPressed: () =>
                          widget.completer(DialogResponse(confirmed: true)),
                      child: Text(
                        "Go Back",
                        style: TextStyle(color: kBlackHeadlineColor),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
