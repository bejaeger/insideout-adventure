import 'package:afkcredits/app/app.logger.dart';
import 'package:afkcredits/ui/widgets/animations/confetti_from_top.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:confetti/confetti.dart';
import 'package:flutter/material.dart';
import 'package:stacked_services/stacked_services.dart';
import 'dart:math';

class CollectedMarkerDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const CollectedMarkerDialog({
    Key? key,
    required this.request,
    required this.completer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      elevation: 5,
      insetPadding: EdgeInsets.symmetric(horizontal: 30, vertical: 0),
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
  final log = getLogger("CollectedMarkerDialog");
  double height = 10;
  late final AnimationController _controller;
  late final Animation<double> _animation;

  //late ConfettiController _confettiController;

  @override
  void initState() {
    super.initState();
    // _confettiController =
    //     ConfettiController(duration: const Duration(seconds: 10));
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    );
    _animation = CurvedAnimation(
      parent: _controller,
      curve: Curves.elasticOut,
    );
    _controller.forward();
    //_confettiController.play();
  }

  @override
  void dispose() {
    _controller.dispose();
    //_confettiController.dispose();
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
                  Text(
                    "Marker collected!",
                    textAlign: TextAlign.center,
                    style: textTheme(context).headline6!.copyWith(
                        color: kcPrimaryColor,
                        fontSize: 32,
                        fontWeight: FontWeight.w800),
                  ),
                  verticalSpaceMedium,
                  Align(
                    alignment: Alignment.center,
                    child: ScaleTransition(
                      scale: _animation,
                      // duration: Duration(milliseconds: 500),
                      // height: height,
                      child: FittedBox(
                        child: Icon(
                          Icons.check,
                          size: 200,
                          color: kcPrimaryColor,
                        ),
                      ),
                    ),
                  ),
                  verticalSpaceLarge,
                  AfkCreditsButton(
                    width: 180,
                    title: "Continue",
                    trailing: Icon(Icons.arrow_forward,
                        size: 20, color: Colors.white),
                    onTap: () =>
                        widget.completer(DialogResponse(confirmed: true)),
                  )
                ],
              ),
            ),
          ],
        ),
        //ConfettieFromTop(confettiController: _confettiController),
      ],
    );
  }

  /// A custom Path to paint stars.
  Path drawStar(Size size) {
    // Method to convert degree to radians
    double degToRad(double deg) => deg * (pi / 180.0);

    const numberOfPoints = 5;
    final halfWidth = size.width / 2;
    final externalRadius = halfWidth;
    final internalRadius = halfWidth / 2.5;
    final degreesPerStep = degToRad(360 / numberOfPoints);
    final halfDegreesPerStep = degreesPerStep / 2;
    final path = Path();
    final fullAngle = degToRad(360);
    path.moveTo(size.width, halfWidth);

    for (double step = 0; step < fullAngle; step += degreesPerStep) {
      path.lineTo(halfWidth + externalRadius * cos(step),
          halfWidth + externalRadius * sin(step));
      path.lineTo(halfWidth + internalRadius * cos(step + halfDegreesPerStep),
          halfWidth + internalRadius * sin(step + halfDegreesPerStep));
    }
    path.close();
    return path;
  }
}
