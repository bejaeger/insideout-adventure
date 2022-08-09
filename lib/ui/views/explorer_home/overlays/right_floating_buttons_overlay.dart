import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:flutter/material.dart';
import 'dart:math' as m;

class RightFloatingButtons extends StatelessWidget {
  final void Function() onZoomPressed;
  final void Function() onCompassTap;

  // !!! Temporary
  final void Function()? onChangeCharacterTap;

  final double bearing;
  final bool zoomedIn;
  final bool hasActiveQuest;
  final bool isShowingQuestDetails;
  const RightFloatingButtons({
    Key? key,
    required this.bearing,
    required this.onZoomPressed,
    required this.zoomedIn,
    required this.onCompassTap,
    required this.isShowingQuestDetails,
    this.onChangeCharacterTap,
    this.hasActiveQuest = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        if (onChangeCharacterTap != null)
          Align(
            alignment: Alignment(-1, 0.65),
            child: Container(
              color: Colors.grey[200]!.withOpacity(0.3),
              width: 55,
              height: 55,
              child: GestureDetector(onTap: onChangeCharacterTap!),
            ),
          ),
        Align(
          alignment: Alignment(1, -0.35),
          child: Padding(
            padding: const EdgeInsets.only(right: 15),
            child: AnimatedOpacity(
              opacity: (bearing > 5 || bearing < -5) ? 1 : 1,
              duration: Duration(milliseconds: 500),
              child: GestureDetector(
                onTap: onCompassTap,
                child: Transform.rotate(
                  angle: -bearing * m.pi / 180,
                  child: Image.asset(
                    kCompassIcon,
                    height: 38,
                  ),
                ),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomRight,
          child: IgnorePointer(
            ignoring: hasActiveQuest,
            child: AnimatedOpacity(
              duration: Duration(milliseconds: 500),
              opacity: (isShowingQuestDetails || hasActiveQuest) ? 0 : 1,
              child: Padding(
                padding: const EdgeInsets.only(
                  bottom: 120,
                  right: 10,
                ),
                child: GestureDetector(
                  onTap: (isShowingQuestDetails || hasActiveQuest)
                      ? null
                      : onZoomPressed,
                  child: Container(
                    width: 55,
                    height: 55,
                    decoration: BoxDecoration(
                        boxShadow: [
                          BoxShadow(
                              color: kShadowColor,
                              //offset: Offset(1, 1),
                              blurRadius: 0.5,
                              spreadRadius: 0.2)
                        ],
                        border:
                            Border.all(color: Colors.grey[800]!, width: 2.0),
                        borderRadius: BorderRadius.circular(90.0),
                        color: Colors.white.withOpacity(0.9)),
                    alignment: Alignment.center,
                    child: zoomedIn == true
                        ? Icon(Icons.my_location_rounded)
                        : Icon(Icons.location_searching),
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
