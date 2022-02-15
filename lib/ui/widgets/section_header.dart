// Heading for section with text button on the right
//
//
//

import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:flutter/material.dart';
import 'package:afkcredits/utils/ui_helpers.dart';

class SectionHeader extends StatelessWidget {
  final void Function()? onButtonTap;
  final String title;
  final String textButtonText;
  final Widget? trailingIcon;
  final double titleSize;
  final double? horizontalPadding;
  final double? verticalPadding;
  final double titleOpacity;

  const SectionHeader(
      {Key? key,
      required this.title,
      this.onButtonTap,
      this.textButtonText = "SEE ALL",
      this.trailingIcon,
      this.titleSize = 24,
      this.horizontalPadding,
      this.verticalPadding,
      this.titleOpacity = 0.7})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? kHorizontalPadding,
          vertical: verticalPadding ?? kVerticalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: textTheme(context).headline6!.copyWith(
                  fontSize: titleSize,
                  color: kBlackHeadlineColor.withOpacity(titleOpacity))),
          if (onButtonTap != null)
            GestureDetector(
              onTap: onButtonTap,
              child: Icon(
                Icons.arrow_forward_ios_rounded,
                size: 24,
                color: kBlackHeadlineColor.withOpacity(titleOpacity),
              ),
            ),
          if (trailingIcon != null) trailingIcon!,
        ],
      ),
    );
  }
}
