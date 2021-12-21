import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/enums/stats_type.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final StatsType statsType;
  final double height;
  final String statistic;
  final String? statisticCredits;
  final String? title;
  final String? subtitle;
  final String buttonText;
  final double? iconHeight;
  final void Function()? onButtonPressed;
  final void Function()? onCardPressed;

  const StatsCard(
      {Key? key,
      required this.statistic,
      this.height: 130,
      this.title,
      this.subtitle,
      this.onButtonPressed,
      this.buttonText = "Donate",
      this.onCardPressed,
      this.statisticCredits,
      this.iconHeight,
      this.statsType = StatsType.unlockedCredits})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardPressed,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          height: height,
          constraints: BoxConstraints(maxHeight: height),
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: BorderRadius.circular(25.0),
            boxShadow: [
              BoxShadow(
                blurRadius: 5,
                color: Colors.black26,
                spreadRadius: 1,
                offset: Offset(3, 3),
              ),
            ],
          ),
          child: Column(
            children: [
              AFKCreditsIcon(
                  height: iconHeight,
                  locked:
                      statsType == StatsType.unlockedCredits ? false : true),
              Expanded(
                child: Stack(
                  fit: StackFit.expand,
                  children: [
                    Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        if (title != null)
                          FittedBox(
                            fit: BoxFit.contain,
                            child: Text(
                              title!,
                              style: textTheme(context).headline4!.copyWith(
                                  fontSize: 18,
                                  color: kDarkTurquoise,
                                  fontWeight: FontWeight.w600),
                            ),
                          ), //verticalSpaceTiny,
                        statisticCredits != null
                            ? FittedBox(
                                fit: BoxFit.contain,
                                child: Text(
                                  statistic +
                                      " = " +
                                      statisticCredits! +
                                      " AFKC",
                                  maxLines: 1,
                                  style: textTheme(context).headline2!.copyWith(
                                        fontSize: 20,
                                        color: kDarkTurquoise,
                                      ),
                                ),
                              )
                            : Text(
                                statistic,
                                maxLines: 1,
                                style: textTheme(context).headline6!.copyWith(
                                    fontSize: 32, color: kDarkTurquoise),
                              ),
                        if (subtitle != null)
                          Text(
                            subtitle!,
                            textAlign: TextAlign.center,
                            maxLines: 2,
                            style: textTheme(context).bodyText2!.copyWith(
                                  fontSize: 13,
                                ),
                          ),
                        verticalSpaceSmall,
                      ],
                    ),
                    if (onButtonPressed != null)
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: GestureDetector(
                          onTap: onButtonPressed,
                          child: Container(
                              alignment: Alignment.center,
                              height: 40,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(25.0),
                                color: kPrimaryColor,
                              ),
                              child: Text(buttonText,
                                  style: textTheme(context).headline4!.copyWith(
                                      fontSize: 16, color: Colors.white))),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class AFKCreditsIcon extends StatelessWidget {
  final bool locked;
  final double? height;
  const AFKCreditsIcon({
    Key? key,
    this.locked = false,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        height: height ?? 70,
        child: AspectRatio(
          aspectRatio: 1,
          child: Stack(
            //fit: StackFit.expand,
            children: [
              Align(
                  alignment: Alignment.center,
                  child: Image.asset(kAFKCreditsLogoPath,
                      height: (height ?? 70) - 10.0)),
              if (locked)
                Align(
                  alignment: locked ? Alignment.center : Alignment.bottomRight,
                  child: PhysicalModel(
                    color: Colors.grey[200]!.withOpacity(0.05),
                    elevation: 0,
                    shape: BoxShape.circle,
                    child: Icon(locked ? Icons.lock : Icons.lock_open,
                        size: 40, color: kGreyTextColor),
                  ),
                )
            ],
          ),
        ));
  }
}
