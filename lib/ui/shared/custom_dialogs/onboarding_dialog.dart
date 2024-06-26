import 'package:afkcredits/constants/asset_locations.dart';
import 'package:flutter/material.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:stacked_services/stacked_services.dart';

class OnboardingDialog extends StatelessWidget {
  final DialogRequest request;
  final Function(DialogResponse) completer;
  const OnboardingDialog(
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
                Text('WELCOME',
                    textAlign: TextAlign.center,
                    style: textTheme(context).headline4),
                Text('to InsideOut Adventure',
                    textAlign: TextAlign.center,
                    style: textTheme(context)
                        .headline6!
                        .copyWith(fontWeight: FontWeight.w800)),
                verticalSpaceSmall,
                Text(
                    'Thank you for using our app! Your feedback is highly welcome.',
                    textAlign: TextAlign.center),
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
                          Text(
                            'Let\'s go',
                            style: textTheme(context).bodyText2!.copyWith(
                                fontSize: 16,
                                color: kcPrimaryColor,
                                fontWeight: FontWeight.w600),
                          ),
                          horizontalSpaceTiny,
                          Padding(
                            padding: const EdgeInsets.only(top: 4),
                            child: Icon(Icons.arrow_forward,
                                size: 20, color: kcPrimaryColor),
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
            top: -35,
            child: CircleAvatar(
                minRadius: 16,
                maxRadius: 35,
                backgroundColor: kcPrimaryColor,
                child: Image.asset(kInsideOutLogo, height: 38)
                // Icon(
                //   Icons.favorite,
                //   size: 28,
                //   color: Colors.white,
                // ),
                ),
          ),
        ],
      ),
    );
  }
}
