import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class BottomFloatingActionButtons extends StatelessWidget {
  final String titleMain;
  final Widget? leadingMain;
  final Widget? leadingSecondary;
  final String? titleSecondary;
  final void Function() onTapMain;
  final void Function()? onTapSecondary;
  final bool swapButtons;
  final bool busySecondary;
  final bool busyMain;
  const BottomFloatingActionButtons({
    Key? key,
    required this.titleMain,
    this.titleSecondary,
    required this.onTapMain,
    this.onTapSecondary,
    this.swapButtons = false,
    this.busySecondary = false,
    this.busyMain = false,
    this.leadingMain,
    this.leadingSecondary,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(color: Colors.white, boxShadow: [
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
                    leading: leadingMain,
                    onTap: onTapMain,
                  )
                : AfkCreditsButton(
                    leading: leadingMain,
                    title: titleMain,
                    onTap: onTapMain,
                    busy: busyMain,
                  ),
          ),
          if (titleSecondary != null) horizontalSpaceMedium,
          if (titleSecondary != null)
            Expanded(
              child: swapButtons
                  ? AfkCreditsButton(
                      title: titleSecondary!,
                      leading: leadingSecondary,
                      onTap: busySecondary ? null : onTapSecondary,
                      disabled: onTapSecondary == null,
                      busy: busySecondary,
                    )
                  : AfkCreditsButton.outline(
                      title: titleSecondary!,
                      leading: leadingSecondary,
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
