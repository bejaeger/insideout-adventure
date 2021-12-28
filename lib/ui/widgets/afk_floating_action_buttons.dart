import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class AFKFloatingActionButtons extends StatelessWidget {
  final void Function() onPressed1;
  final IconData? iconData1;
  final String? title1;
  final void Function()? onPressed2;
  final IconData? iconData2;
  final Widget? icon1;
  final String? title2;
  final double yOffset;
  final bool isShimmering;
  const AFKFloatingActionButtons({
    Key? key,
    required this.onPressed1,
    this.iconData1,
    this.onPressed2,
    this.iconData2,
    this.title1,
    this.title2,
    this.isShimmering = false,
    this.yOffset = 10,
    this.icon1,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        if (onPressed2 != null)
          AFKFloatingActionButton(
            title: title2,
            onPressed: onPressed2!,
            icon: Icon(iconData2!, size: 34, color: Colors.white),
          ),
        if (onPressed2 != null) verticalSpaceSmall,
        AFKFloatingActionButton(
          title: title1,
          onPressed: onPressed1,
          icon: Shimmer.fromColors(
              baseColor: isShimmering ? kGreyTextColor : Colors.white,
              highlightColor: Colors.white,
              period: const Duration(milliseconds: 1000),
              enabled: this.isShimmering,
              child: icon1 ??
                  Icon(iconData1 ?? Icons.refresh_rounded,
                      size: 34, color: Colors.white)),
        ),
        SizedBox(height: yOffset),
      ],
    );
  }
}
