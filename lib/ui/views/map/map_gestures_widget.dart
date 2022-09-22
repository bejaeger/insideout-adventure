import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

//
// Class that takes care of map gesture widgets
// Important to have the HitTestBehavior as translucent!
//

class MapGesturesWidget extends StatelessWidget {
  final ignoreGestures;
  final void Function(ScaleUpdateDetails) onRotate;
  final void Function(TapDownDetails)? onTapDown;
  const MapGesturesWidget({
    Key? key,
    required this.ignoreGestures,
    required this.onRotate,
    this.onTapDown,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: ignoreGestures,
      child: Container(
        height: screenHeight(context),
        width: screenWidth(context),
        child: Column(
          children: [
            // This avoids overlap of the below gesture detector (for the main map)
            // and the widgets in the header! Sometimes this creates issues!
            SizedBox(height: 70),
            Expanded(
              child: GestureDetector(
                behavior: HitTestBehavior.translucent,
                onScaleUpdate: onRotate,
                onTapDown: onTapDown,
                // to prevent using Google Map double tap
                // ! Don't do it, otherwise it introduces a
                // ! delay on map marker taps
                // onDoubleTap: () => null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
