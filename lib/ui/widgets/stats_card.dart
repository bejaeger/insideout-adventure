import 'package:afkcredits/constants/asset_locations.dart';
import 'package:afkcredits/enums/stats_type.dart';
import 'package:afkcredits/ui/widgets/icon_credits_amount.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';
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
  final Widget? icon;
  final void Function()? onButtonPressed;
  final void Function()? onCardPressed;

  const StatsCard(
      {Key? key,
      required this.statistic,
      this.height: 120,
      this.title,
      this.subtitle,
      this.onButtonPressed,
      this.buttonText = "Donate",
      this.onCardPressed,
      this.statisticCredits,
      this.iconHeight,
      this.statsType = StatsType.unlockedCredits,
      this.icon})
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
                blurRadius: 2,
                color: Colors.black26,
                spreadRadius: 0.1,
                offset: Offset(1, 1),
              ),
            ],
          ),
          child: Column(
            children: [
              icon ??
                  AFKCreditsIcon(
                      height: iconHeight,
                      locked: statsType == StatsType.unlockedCredits
                          ? false
                          : true),
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
                                  fontSize: 14,
                                  color: kcPrimaryColorSecondary,
                                  fontWeight: FontWeight.w600),
                            ),
                          ), //verticalSpaceTiny,
                        statisticCredits != null
                            ? FittedBox(
                                fit: BoxFit.contain,
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Text(
                                      statistic,
                                      maxLines: 1,
                                      style: textTheme(context)
                                          .headline2!
                                          .copyWith(
                                            fontSize: 20,
                                            color: kcPrimaryColorSecondary,
                                          ),
                                    ),
                                    Text(
                                      " = ",
                                      style: textTheme(context)
                                          .headline2!
                                          .copyWith(
                                            fontSize: 20,
                                            color: kcPrimaryColorSecondary,
                                          ),
                                    ),
                                    CreditsAmount(
                                        height: 15,
                                        amount: 0,
                                        amountString: statisticCredits!)
                                  ],
                                ),
                              )
                            : Text(
                                statistic,
                                maxLines: 1,
                                style: textTheme(context).headline6!.copyWith(
                                    fontSize: 32,
                                    color: kcPrimaryColorSecondary),
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
                                color: kcPrimaryColor,
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
  final Alignment alignment;
  const AFKCreditsIcon({
    Key? key,
    this.locked = false,
    this.height,
    this.alignment = Alignment.center,
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
                alignment: alignment,
                child: Image.asset(kAFKCreditsLogoPath,
                    height: (height ?? 70) - 10.0),
              ),
              if (locked)
                Align(
                  alignment: locked ? Alignment.center : Alignment.bottomRight,
                  child: PhysicalModel(
                    color: Colors.grey[200]!.withOpacity(0.05),
                    elevation: 0,
                    shape: BoxShape.circle,
                    child: Icon(locked ? Icons.lock : Icons.lock_open,
                        size: 40, color: kcGreyTextColor),
                  ),
                )
            ],
          ),
        ));
  }
}
