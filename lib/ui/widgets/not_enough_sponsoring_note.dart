import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class NotEnoughSponsoringNote extends StatelessWidget {
  final double topPadding;
  const NotEnoughSponsoringNote({Key? key, this.topPadding = 0})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: screenWidth(context, percentage: 0.7),
      child: Column(
        children: [
          SizedBox(height: topPadding),
          Text("Your funds are not enough to start the quest.",
              textAlign: TextAlign.center,
              style: textTheme(context)
                  .bodyText2!
                  .copyWith(color: Colors.red, fontSize: 16)),
        ],
      ),
    );
  }
}
