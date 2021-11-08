import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/utils/currency_formatting_helpers.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class StatsCard extends StatelessWidget {
  final double height;
  final String statistic;
  final String? statisticCredits;
  final String? title;
  final String? subtitle;
  final String buttonText;
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
      this.statisticCredits})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onCardPressed,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25.0),
        ),
        elevation: 4,
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            height: height,
            child: Stack(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Column(
                      children: [
                        if (title != null)
                          Text(
                            title!,
                            style: textTheme(context).bodyText2!.copyWith(
                                  fontSize: 18,
                                ),
                          ), //verticalSpaceTiny,
                        statisticCredits != null
                            ? Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    statistic,
                                    maxLines: 1,
                                    style:
                                        textTheme(context).headline2!.copyWith(
                                              fontSize: 28,
                                            ),
                                  ),
                                  Text(
                                    " -> ",
                                    style:
                                        textTheme(context).headline2!.copyWith(
                                              fontSize: 28,
                                            ),
                                  ),
                                  Text(
                                    statisticCredits! + " AFKC",
                                    maxLines: 1,
                                    style:
                                        textTheme(context).headline2!.copyWith(
                                              fontSize: 28,
                                            ),
                                  ),
                                ],
                              )
                            : Text(
                                statistic,
                                maxLines: 1,
                                style: textTheme(context).headline2!.copyWith(
                                      fontSize: 28,
                                    ),
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
                      ],
                    ),
                    Container(height: 0),
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
        ),
      ),
    );
  }
}
