import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class HerculesWorldLogo extends StatelessWidget {
  final bool isBusy;
  final double sizeScale;
  const HerculesWorldLogo({
    Key? key,
    this.isBusy = false,
    this.sizeScale = 1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        // AFKCreditsIcon(height: 170),
        // verticalSpaceSmall,
        Text("HERCULES",
            style: textTheme(context).headline6!.copyWith(
                  fontSize: 40 * sizeScale,
                  color: kcOrange,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 1,
                )),
        Text("WORLD",
            style: textTheme(context).headline6!.copyWith(
                fontSize: 60 * sizeScale,
                height: 0.95,
                fontWeight: FontWeight.w800,
                color: kcOrangeYellow,
                letterSpacing: 1)),
        if (isBusy) verticalSpaceMedium,
        if (isBusy)
          AFKProgressIndicator(
            linear: false,
            color: kcOrange,
          ),
      ],
    );
  }
}
