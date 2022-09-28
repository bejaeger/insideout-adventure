import 'package:flutter/material.dart';

class RoundCloseButton extends StatelessWidget {
  final void Function()? onTap;
  final Color? color;
  const RoundCloseButton({
    Key? key,
    required this.onTap,
    this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
        //color: Colors.green,
        padding: const EdgeInsets.all(8.0),
        child: Container(
            height: 40,
            width: 40,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(width: 2),
              color: color,
            ),
            child: Icon(Icons.close_outlined, size: 24)),
      ),
    );
  }
}
