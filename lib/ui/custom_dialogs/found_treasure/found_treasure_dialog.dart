import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:stacked_services/stacked_services.dart';

class FoundTreasureDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const FoundTreasureDialog({
    Key? key,
    required this.request,
    required this.completer,
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
      ),
    );
  }
}

class _BasicDialogContent extends StatefulWidget {
  final DialogRequest request;
  final Function(DialogResponse dialogResponse) completer;

  _BasicDialogContent({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  State<_BasicDialogContent> createState() => _BasicDialogContentState();
}

class _BasicDialogContentState extends State<_BasicDialogContent>
    with TickerProviderStateMixin {
  final log = getLogger("FoundTreasureDialog");
  double height = 10;
  late final AnimationController _controller;
  // ..repeat(reverse: true);
  late final Animation<double> _animation;
  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
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
                  Text("Schatz gefunden!",
                      textAlign: TextAlign.center,
                      style: textTheme(context).headline6!.copyWith(
                          color: kPrimaryColor,
                          fontSize: 32,
                          fontWeight: FontWeight.w800)),
                  verticalSpaceMedium,
                  Align(
                    alignment: Alignment.center,
                    child: ScaleTransition(
                      scale: _animation,
                      // duration: Duration(milliseconds: 500),
                      // height: height,
                      child: Image.asset(kTreasureIconPath, width: 150),
                    ),
                  ),
                  verticalSpaceMedium,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        onPressed: () =>
                            widget.completer(DialogResponse(confirmed: true)),
                        child: Text(
                          "Weiter",
                          style: textTheme(context)
                              .headline6!
                              .copyWith(color: kWhiteTextColor),
                        ),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }
}
