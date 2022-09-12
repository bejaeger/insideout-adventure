import 'package:flutter/material.dart';
import '../../afkcredits_ui.dart';

class QuestTypeCard extends StatelessWidget {
  final void Function() onPressed;
  final QuestType category;
  final Color? backgroundColor;
  const QuestTypeCard({
    Key? key,
    required this.onPressed,
    required this.category,
    this.backgroundColor = kcScreenTimeBlue,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => onPressed(),
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Container(
          decoration: BoxDecoration(
            color: getColorForCategory(category).withOpacity(0.9),
            borderRadius: BorderRadius.circular(24),
            boxShadow: const [
              BoxShadow(
                blurRadius: 2,
                spreadRadius: 1,
                color: kcShadowColor,
                offset: Offset(1, 1),
              )
            ],
          ),
          // width: 180,
          // height: 180,
          padding:
              const EdgeInsets.only(top: 15.0, left: 20, right: 20, bottom: 15),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Icon(getIconForCategory(category.toSimpleString()),
                    size: 60, color: kcGreyTextColor.withOpacity(0.9)),
              ),
              const Spacer(),
              Text(
                getStringForCategory(category),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme(context)
                    .headline6!
                    .copyWith(color: Colors.grey[200]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
