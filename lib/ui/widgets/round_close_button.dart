import 'package:flutter/material.dart';

class RoundCloseButton extends StatelessWidget {
  final void Function()? onTap;
  const RoundCloseButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.translucent,
      child: Container(
          height: 40,
          width: 40,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            border: Border.all(width: 2),
          ),
          child: Icon(Icons.close_outlined, size: 24)),
    );
  }
}
