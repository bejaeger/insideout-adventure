import 'package:afkcredits/constants/asset_locations.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked_services/stacked_services.dart';

class NumberQuestsFoundDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const NumberQuestsFoundDialog(
      {Key? key, required this.request, required this.completer})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Dialog(
      backgroundColor: Colors.transparent,
      //insetPadding: const EdgeInsets.symmetric(horizontal: 40.0, vertical: 120),
      child: Stack(
        clipBehavior: Clip.none,
        alignment: Alignment.topCenter,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: screenWidth(context, percentage: 0.04),
            ),
            padding: const EdgeInsets.only(
              top: 32,
              left: 16,
              right: 16,
              bottom: 12,
            ),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                verticalSpaceSmall,
                verticalSpaceSmall,
                Text('Found ${request.data} quests nearby!',
                    textAlign: TextAlign.center,
                    style: textTheme(context)
                        .headline6!
                        .copyWith(fontWeight: FontWeight.w800)),
                verticalSpaceMedium,
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    TextButton(
                      onPressed: () =>
                          completer(DialogResponse(confirmed: true)),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          InsideOutButton(
                            title: 'Let\'s go',
                            trailing: Icon(Icons.arrow_forward,
                                size: 20, color: Colors.white),
                            width: 180,
                            height: 45,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Positioned(
            top: -40,
            child: CircleAvatar(
                minRadius: 16,
                maxRadius: 38,
                backgroundColor: kcOrange,
                child: Image.asset(kActivityIcon,
                    height: 45, color: kcVeryLightGrey)),
          ),
        ],
      ),
    );
  }
}
