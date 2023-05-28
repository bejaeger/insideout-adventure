import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';

class SelectableBox extends StatelessWidget {
  final bool selected;
  final Widget child;
  final void Function()? onTap;
  final EdgeInsetsGeometry? padding;
  final double? height;
  const SelectableBox({
    Key? key,
    required this.selected,
    required this.child,
    this.onTap,
    this.padding,
    this.height,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        clipBehavior: Clip.hardEdge,
        decoration: BoxDecoration(
          border: Border.all(
              width: 5, color: selected ? kcPrimaryColor : Colors.transparent),
          borderRadius: BorderRadius.circular(15.0),
        ),
        padding: padding ?? const EdgeInsets.all(4.0),
        child: child,
      ),
    );
  }
}
