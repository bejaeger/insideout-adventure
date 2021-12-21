import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

class QuestCategoryCard extends StatelessWidget {
  final void Function(QuestType) onPressed;
  final QuestType category;
  final Color? backgroundColor;
  const QuestCategoryCard({
    Key? key,
    required this.onPressed,
    required this.category,
    this.backgroundColor = Colors.blue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () => onPressed(category),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
              decoration: BoxDecoration(
                  color: backgroundColor,
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 5,
                      spreadRadius: 1,
                      color: Colors.black26,
                      offset: Offset(3, 3),
                    )
                  ]),
              // width: 180,
              // height: 180,
              padding: const EdgeInsets.all(8.0),
              child: Center(
                  child: FittedBox(
                fit: BoxFit.contain,
                child: Text(describeEnum(category.toString()),
                    style: textTheme(context)
                        .headline6!
                        .copyWith(color: Colors.grey[200])),
              ))),
        ));
  }
}
