// Heading for section with text button on the right
//
//
//

import 'package:afkcredits/constants/layout.dart';
import 'package:flutter/material.dart';
import 'package:afkcredits_ui/afkcredits_ui.dart';

class SectionHeader extends StatelessWidget {
  final void Function()? onButtonTap;
  final String title;
  final Widget? otherTrailingIcon;
  final double titleSize;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double titleOpacity;
  final Widget? buttonIcon;

  const SectionHeader(
      {Key? key,
      required this.title,
      this.onButtonTap,
      this.otherTrailingIcon,
      this.titleSize = 20,
      this.horizontalPadding,
      this.verticalPadding,
      this.buttonIcon,
      this.titleOpacity = 1})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Padding(
          padding: EdgeInsets.symmetric(
              horizontal: horizontalPadding ?? kHorizontalPadding,
              vertical: verticalPadding ?? kVerticalPadding),
          child: Text(title,
              style: textTheme(context).headline6!.copyWith(
                  fontSize: titleSize,
                  color: kcBlackHeadlineColor.withOpacity(titleOpacity))),
        ),
        if (onButtonTap != null)
          Padding(
            padding: EdgeInsets.symmetric(
                horizontal: ((horizontalPadding ?? kHorizontalPadding) - 8.0)
                    .clamp(0, 10000),
                vertical: ((verticalPadding ?? kVerticalPadding) - 8.0)
                    .clamp(0, 10000)),
            child: GestureDetector(
              onTap: onButtonTap,
              child: Container(
                padding: const EdgeInsets.all(8.0),
                child: buttonIcon ??
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 20,
                      color: kcBlackHeadlineColor.withOpacity(titleOpacity),
                    ),
              ),
            ),
          ),
        if (otherTrailingIcon != null) otherTrailingIcon!,
      ],
    );
  }
}
