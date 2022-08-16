import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class BottomFloatingActionButtons extends StatelessWidget {
  final String titleMain;
  final String? titleSecondary;
  final void Function() onTapMain;
  final void Function()? onTapSecondary;
  final bool swapButtons;
  const BottomFloatingActionButtons({
    Key? key,
    required this.titleMain,
    this.titleSecondary,
    required this.onTapMain,
    this.onTapSecondary,
    this.swapButtons = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(color: Colors.white, boxShadow: [
        BoxShadow(
            offset: Offset(0, -1),
            blurRadius: 0.1,
            spreadRadius: 0.3,
            color: kcShadowColor)
      ]),
      height: 70,
      width: screenWidth(context),
      child: Row(
        children: [
          const SizedBox(width: klHorizontalPadding),
          Expanded(
            child: swapButtons
                ? AfkCreditsButton.outline(
                    title: titleMain,
                    onTap: onTapMain,
                  )
                : AfkCreditsButton(
                    title: titleMain,
                    onTap: onTapMain,
                  ),
          ),
          if (titleSecondary != null) horizontalSpaceMedium,
          if (titleSecondary != null)
            Expanded(
              child: swapButtons
                  ? AfkCreditsButton(
                      title: titleSecondary!,
                      onTap: onTapSecondary,
                      disabled: onTapSecondary == null,
                    )
                  : AfkCreditsButton.outline(
                      title: titleSecondary!,
                      onTap: onTapSecondary,
                    ),
            ),
          const SizedBox(width: klHorizontalPadding),
          //verticalSpaceSmall,
        ],
      ),
    );
  }
}
