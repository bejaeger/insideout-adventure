import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/ui/custom_dialogs/in_area_alert/in_area_alert_dialog_viewmodel.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:stacked/stacked.dart';
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
    return ViewModelBuilder<InAreaAlertDialogViewModel>.reactive(
        viewModelBuilder: () => InAreaAlertDialogViewModel(),
        builder: (context, model, child) {
          return Dialog(
            elevation: 5,
            //insetPadding: EdgeInsets.symmetric(horizontal: 50, vertical: 50),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16.0)),
            backgroundColor: Colors.white,
            child: _BasicDialogContent(
              request: request,
              model: model,
              completer: completer,
              isQrCodeInArea: isQrCodeInArea,
            ),
          );
        });
  }
}

class _BasicDialogContent extends StatefulWidget {
  final bool isQrCodeInArea;
  final DialogRequest request;
  final InAreaAlertDialogViewModel model;
  final Function(DialogResponse dialogResponse) completer;

  _BasicDialogContent({
    Key? key,
    required this.request,
    required this.completer,
    required this.isQrCodeInArea,
    required this.model,
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
                    widget.isQrCodeInArea
                        ? "Marker in area!"
                        : "Checkpoint reached!",
                    textAlign: TextAlign.center,
                    style: textTheme(context).headline6!.copyWith(
                        color: kcPrimaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w800),
                  ),
                  verticalSpaceTiny,
                  FadeTransition(
                    opacity: _animation,
                    child: Text(
                        widget.isQrCodeInArea
                            ? "Look for the marker and scan it"
                            : "",
                        textAlign: TextAlign.center,
                        style: textTheme(context).headline6!.copyWith(
                            color: kcPrimaryColor,
                            fontSize: 16,
                            fontWeight: FontWeight.w400)),
                  ),
                  verticalSpaceLarge,
                  Align(
                    alignment: Alignment.center,
                    child: GestureDetector(
                      onTap: () async {
                        dynamic scanned =
                            await widget.request.data["function"]();
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
                                color: kcShadowColor,
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
                                  backgroundColor: kcPrimaryColor,
                                  child: Icon(
                                    widget.model.isUsingAR
                                        ? Icons.camera_alt_outlined
                                        : Icons.add_circle_outline_rounded,
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
                  verticalSpaceSmall,

                  ScaleTransition(
                    scale: _animation,
                    // duration: Duration(milliseconds: 500),
                    // height: height,
                    child: Text(
                      widget.model.isUsingAR
                          ? "Find credits"
                          : "Collect credits",
                      style: textTheme(context)
                          .headline6!
                          .copyWith(color: kcPrimaryColor),
                    ),
                  ),
                  verticalSpaceLarge,
                  //QrCodeButton(),
                  FadeTransition(
                    opacity: _animation,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        if (widget.model.isUsingAR)
                          TextButton(
                            onPressed: () async {
                              dynamic collected =
                                  await widget.request.data["functionNoAr"]();
                              if (collected is bool && collected == true) {
                                widget
                                    .completer(DialogResponse(confirmed: true));
                              }
                            },
                            child: Text(
                              "Collect immediately",
                              style: TextStyle(color: kcBlackHeadlineColor),
                            ),
                          ),
                        if (widget.isQrCodeInArea)
                          TextButton(
                            onPressed: () => print("hi"),
                            child: Text(
                              "Show Clue",
                              style: TextStyle(color: kcBlackHeadlineColor),
                            ),
                          ),
                      ],
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
