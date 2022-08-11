import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class MainLongButton extends StatelessWidget {
  final void Function() onTap;
  final Color? color;
  final String title;
  const MainLongButton(
      {Key? key,
      required this.onTap,
      required this.title,
      this.color = kcPrimaryColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 50,
        alignment: Alignment.center,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(15.0), color: color),
        child: AfkCreditsText.button(title),
      ),
    );
  }
}
