import 'package:afkcredits_ui/afkcredits_ui.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/foundation/key.dart';
import 'package:flutter/src/widgets/framework.dart';

class GrabberLine extends StatelessWidget {
  const GrabberLine({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return const SizedBox(
      width: 30,
      child: Divider(
        thickness: 3,
        color: kcMediumGrey,
      ),
    );
  }
}
