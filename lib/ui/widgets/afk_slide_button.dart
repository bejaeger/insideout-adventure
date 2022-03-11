import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:afkcredits/datamodels/quests/quest.dart';
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
      required this.quest,
      required this.canStartQuest,
      required this.onSubmit,
      this.alignment})
      : super(key: key);

  final Quest quest;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: kHorizontalPadding),
      child: SlideAction(
        sliderButtonIconPadding: 12,
        sliderButtonIconSize: 22,
        // sliderButtonIcon: Icon(Icons.play_arrow, color: kPrimaryColor),
        alignment: alignment ?? Alignment.center,
        outerColor: kPrimaryColor,
        //text: "Start",
        child: canStartQuest
            ? Shimmer.fromColors(
                baseColor: kGreyTextColor.withOpacity(0.9),
                highlightColor: Colors.white,
                period: const Duration(milliseconds: 1000),
                child: Text("Start",
                    style: textTheme(context)
                        .headline6!
                        .copyWith(fontSize: 22, color: kWhiteTextColor)),
              )
            : Text("Cannot start",
                style: textTheme(context)
                    .headline6!
                    .copyWith(fontSize: 22, color: kWhiteTextColor)),
        height: 50,
        elevation: 1,
        sliderRotate: false,
        //key: _key,
        onSubmit: canStartQuest ? onSubmit : null,
        borderRadius: 50,
        //sliderButtonIcon: Icon(Icons.play_arrow)
        // submittedIcon: Icon(Icons.railway_alert),
        // animationDuration: Duration(seconds: 1),
      ),
    );
  }
}
