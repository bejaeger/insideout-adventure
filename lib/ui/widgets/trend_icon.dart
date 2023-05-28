import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

class TrendIcon extends StatelessWidget {
  final num? metric;
  final bool screenTime;
  const TrendIcon({Key? key, required this.metric, this.screenTime = false})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return metric == null
        ? SizedBox(height: 0, width: 0)
        : metric! > 0
            ? Icon(Icons.north_east,
                color: screenTime ? kcRed : kcAccentuatedGreen)
            : metric == 0
                ? SizedBox(height: 0, width: 0)
                : Icon(Icons.south_east,
                    color: screenTime ? kcAccentuatedGreen : kcRed);
  }
}
