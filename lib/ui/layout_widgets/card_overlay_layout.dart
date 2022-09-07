import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class CardOverlayLayout extends StatelessWidget {
  final void Function() onBack;
  final double height;
  final Widget child;
  final Color color1;
  final Color color2;

  const CardOverlayLayout(
      {Key? key,
      required this.onBack,
      this.height = 400,
      required this.child,
      this.color1 = Colors.white,
      this.color2 = kcYellow})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: screenHeight(context) - kTopHeaderPadding,
      child: Stack(
        children: [
          // to dismiss the dialog when tapped outside
          Container(
            height: screenHeight(context),
            width: screenWidth(context),
            child: GestureDetector(
              onTap: onBack,
              onVerticalDragStart: (_) => onBack(),
            ),
          ),
          GestureDetector(
            onTap: () => null,
            onVerticalDragStart: (_) => onBack(),
            child: Padding(
              padding: const EdgeInsets.only(
                  left: 12.0, right: 12.0, top: kTopHeaderPadding),
              child: Container(
                padding: const EdgeInsets.only(
                    left: 20.0, right: 20.0, top: 20.0, bottom: 5.0),
                //height: height,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                      //colors: [Colors.white, kcPrimaryColor],
                      colors: [color1, color2],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      stops: [0.2, 1],
                    ),
                    boxShadow: [
                      BoxShadow(
                        blurRadius: 0.5,
                        spreadRadius: 0.6,
                        //offset: Offset(1, 1),
                        color: kcShadowColor,
                      )
                    ],
                    //color: kcCultured,
                    borderRadius: BorderRadius.circular(20.0)),
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      child,
                      //Spacer(),
                      verticalSpaceMedium,
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GrabberLine(),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          //Text("HALLO"),
        ],
      ),
    );
  }
}
