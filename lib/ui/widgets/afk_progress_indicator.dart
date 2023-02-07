import 'package:insideout_ui/insideout_ui.dart';
import 'package:flutter/material.dart';

class AFKProgressIndicator extends StatelessWidget {
  final bool centered;
  final bool linear;
  final Color? color;
  final Alignment? alignment;
  const AFKProgressIndicator(
      {Key? key,
      this.centered = true,
      this.linear = false,
      this.color,
      this.alignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return linear == false
        ? Align(
            alignment: alignment ?? Alignment.center,
            child: CircularProgressIndicator(color: color ?? kcPrimaryColor),
          )
        : LinearProgressIndicator(
            color: color ?? kcPrimaryColor,
            backgroundColor: kcPrimaryColor.withOpacity(0.5));
  }
}
