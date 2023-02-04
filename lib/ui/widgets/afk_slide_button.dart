import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';
import 'package:slide_to_act/slide_to_act.dart';

class AFKSlideButton extends StatelessWidget {
  final bool canStartQuest;
  final void Function() onSubmit;
  final Alignment? alignment;
  const AFKSlideButton(
      {Key? key,
      required this.canStartQuest,
      required this.onSubmit,
      this.alignment})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
          horizontal:
              0), // const EdgeInsets.symmetric(horizontal: kHorizontalPadding * 2),
      child: SlideAction(
        sliderButtonIconPadding: 12,
        sliderButtonIconSize: 22,
        sliderButtonIcon: Icon(Icons.play_arrow_rounded, color: kcPrimaryColor),
        alignment: alignment ?? Alignment.center,
        outerColor: kcPrimaryColor,
        child: canStartQuest
            ? Shimmer.fromColors(
                baseColor: kcGreyTextColor.withOpacity(1),
                highlightColor: Colors.white,
                period: const Duration(milliseconds: 1000),
                child: AfkCreditsText.subheading("      Start"),
              )
            : Text("Cannot start",
                style: textTheme(context)
                    .headline6!
                    .copyWith(fontSize: 22, color: kcWhiteTextColor)),
        height: 50,
        elevation: 1,
        sliderRotate: false,
        onSubmit: canStartQuest ? onSubmit : null,
        borderRadius: 30,
      ),
    );
  }
}
