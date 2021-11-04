// Heading for section with text button on the right
//
//
//

import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/constants/layout.dart';
import 'package:flutter/material.dart';
import 'package:afkcredits/utils/ui_helpers.dart';

class SectionHeader extends StatelessWidget {
  final void Function()? onTextButtonTap;
  final String title;
  final String textButtonText;
  final Widget? trailingIcon;
  final double titleSize;
  final double? horizontalPadding;

  const SectionHeader(
      {Key? key,
      required this.title,
      this.onTextButtonTap,
      this.textButtonText = "SEE ALL",
      this.trailingIcon,
      this.titleSize = 20,
      this.horizontalPadding})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
          horizontal: horizontalPadding ?? kHorizontalPadding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(title,
              style: textTheme(context)
                  .headline6!
                  .copyWith(fontSize: titleSize, color: kBlackHeadlineColor)),
          if (onTextButtonTap != null)
            IconButton(
                onPressed: onTextButtonTap,
                icon: Icon(
                  Icons.more_horiz,
                  size: 28,
                  color: kBlackHeadlineColor,
                )),
          // TextButton(
          //   onPressed: onTextButtonTap,
          //   child: Text(
          //     textButtonText,
          //     style: textTheme(context)
          //         .headline6!
          //         .copyWith(color: ColorSettings.greyTextColor, fontSize: 14),
          //   ),
          // ),
          if (trailingIcon != null) trailingIcon!,
        ],
      ),
    );
  }
}
