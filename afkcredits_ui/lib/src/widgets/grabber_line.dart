import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class GrabberLine extends StatelessWidget {
  final void Function(DragStartDetails)? onVerticalDrag;

  const GrabberLine({Key? key, this.onVerticalDrag}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onVerticalDragStart: onVerticalDrag,
      child: const SizedBox(
        width: 30,
        child: Divider(
          thickness: 3,
          color: kcMediumGrey,
        ),
      ),
    );
  }
}
