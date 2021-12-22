import 'package:afkcredits/constants/colors.dart';
import 'package:flutter/material.dart';

class AFKProgressIndicator extends StatelessWidget {
  final bool centered;
  final bool linear;
  final Color? color;
  const AFKProgressIndicator(
      {Key? key, this.centered = true, this.linear = false, this.color})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return linear == false
        ? Align(
            alignment: Alignment.center,
            child: CircularProgressIndicator(color: color ?? kPrimaryColor),
          )
        : LinearProgressIndicator(
            color: color ?? kPrimaryColor,
            backgroundColor: kPrimaryColor.withOpacity(0.5));
  }
}
