import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class NotCloseToQuestNote extends StatelessWidget {
  const NotCloseToQuestNote({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          // clipBehavior: Clip.antiAlias,
          padding: const EdgeInsets.all(10.0),
          decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.9),
              borderRadius: BorderRadius.circular(16.0)),
          width: screenWidth(context, percentage: 0.7),
          child: Text("Cannot start the quest because you are not near it.",
              textAlign: TextAlign.center,
              style: textTheme(context)
                  .bodyText2!
                  .copyWith(color: Colors.red, fontSize: 16)),
        ),
      ],
    );
  }
}
