import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class ShortQuestInstruction extends StatelessWidget {
  final String description;
  const ShortQuestInstruction({Key? key, required this.description})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.9),
          borderRadius: BorderRadius.circular(16.0)),
      child: Column(mainAxisSize: MainAxisSize.min, children: [
        Text(description,
            textAlign: TextAlign.center, style: textTheme(context).headline6),
      ]),
    );
  }
}
