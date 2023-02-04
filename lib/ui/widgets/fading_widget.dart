import 'package:flutter/material.dart';

//
// A little helper widget that uses animatied opacity and ignore pointer
// to fade in and out a widget on the map
//

class FadingWidget extends StatelessWidget {
  final Widget child;
  final bool show;
  final int durationInMs;
  final bool? ignorePointer;
  const FadingWidget({
    Key? key,
    required this.child,
    required this.show,
    this.durationInMs = 400,
    this.ignorePointer,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IgnorePointer(
      ignoring: ignorePointer ?? !show,
      child: AnimatedOpacity(
        duration: Duration(milliseconds: durationInMs),
        opacity: show ? 1 : 0,
        child: child,
      ),
    );
  }
}
