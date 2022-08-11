import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';

class SmallButton extends StatelessWidget {
  final void Function()? onPressed;
  final String title;
  final bool withShadow;

  const SmallButton({
    Key? key,
    required this.onPressed,
    required this.title,
    this.withShadow = true,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
          decoration: BoxDecoration(
            boxShadow: withShadow
                ? [
                    BoxShadow(
                        spreadRadius: 1, blurRadius: 1, color: Colors.black12)
                  ]
                : [],
            border: Border.all(style: BorderStyle.solid, color: Colors.white30),
            borderRadius: BorderRadius.all(Radius.circular(12.0)),
            color: kcRed.withOpacity(0.5),
          ),
          padding: const EdgeInsets.all(10.0),
          child: Text(title,
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[50], fontSize: 16))),
    );
  }
}
