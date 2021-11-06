import 'package:flutter/material.dart';

class MyFloatingActionButton extends StatelessWidget {
  final Widget icon;
  final void Function() onPressed;
  final double height;
  final double width;
  const MyFloatingActionButton(
      {Key? key,
      required this.icon,
      required this.onPressed,
      this.height = 65,
      this.width = 65})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      child: FloatingActionButton(
          heroTag: null,
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.black,
          onPressed: onPressed,
          child: icon),
    );
  }
}
