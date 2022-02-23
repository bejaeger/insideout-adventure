import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/enums/quest_type.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
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
                      blurRadius: 3,
                      spreadRadius: 1,
                      color: Colors.black26,
                      offset: Offset(1, 1),
                    )
                  ]),
              // width: 180,
              // height: 180,
              padding: const EdgeInsets.only(
                  top: 15.0, left: 20, right: 20, bottom: 15),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Icon(getIconForCategory(category),
                        size: 60, color: kGreyTextColor.withOpacity(0.9)),
                  ),
                  Spacer(),
                  Text(getStringForCategory(category),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme(context)
                          .headline6!
                          .copyWith(color: Colors.grey[200])),
                ],
              )),
        ));
  }
}
