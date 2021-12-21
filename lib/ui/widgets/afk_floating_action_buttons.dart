import 'package:afkcredits/ui/widgets/my_floating_action_button.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class AFKFloatingActionButtons extends StatelessWidget {
  final void Function() onPressed1;
  final IconData iconData1;
  final String? title1;
  final void Function()? onPressed2;
  final IconData? iconData2;
  final String? title2;
  const AFKFloatingActionButtons({
    Key? key,
    required this.onPressed1,
    required this.iconData1,
    this.onPressed2,
    this.iconData2,
    this.title1,
    this.title2,
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
            icon: Icon(iconData2!, size: 32, color: Colors.white),
          ),
        if (onPressed2 != null) verticalSpaceSmall,
        AFKFloatingActionButton(
            title: title1,
            onPressed: onPressed1,
            icon: Icon(iconData1, size: 32, color: Colors.white)),
        verticalSpaceSmall,
      ],
    );
  }
}
