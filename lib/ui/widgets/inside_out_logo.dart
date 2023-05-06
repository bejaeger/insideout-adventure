import 'package:afkcredits/ui/widgets/afk_progress_indicator.dart';
import 'package:insideout_ui/insideout_ui.dart';
import 'package:flutter/material.dart';

class InsideOutLogo extends StatelessWidget {
  final bool isBusy;
  final double sizeScale;
  final Function()? onTap;
  final bool boxed;
  final bool center;
  const InsideOutLogo({
    Key? key,
    this.onTap,
    this.isBusy = false,
    this.sizeScale = 1,
    this.boxed = false,
    this.center = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: boxed
            ? EdgeInsets.symmetric(
                horizontal: 26 * sizeScale,
                vertical: 12 * sizeScale,
              )
            : null,
        decoration: boxed
            ? BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(16),
              )
            : null,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment:
              center ? CrossAxisAlignment.center : CrossAxisAlignment.start,
          children: [
            Text(
              "InsideOut",
              style: textTheme(context).headline6!.copyWith(
                    fontSize: 40 * sizeScale,
                    color: kcPrimaryColor, // Color(0xff8EBDE5), // kcOrange,
                    fontWeight: FontWeight.w600,
                    letterSpacing: 1,
                  ),
            ),
            Text(
              "Adventure",
              style: textTheme(context).headline6!.copyWith(
                    fontSize: 40 * sizeScale,
                    height: 0.95,
                    fontWeight: FontWeight.w600,
                    color:
                        kcPrimaryColor, // Color(0xff8EBDE5), //kcOrangeYellow,
                    letterSpacing: 1,
                  ),
            ),
            if (isBusy) verticalSpaceMedium,
            if (isBusy)
              AFKProgressIndicator(
                linear: false,
                color: kcPrimaryColor,
              ),
          ],
        ),
      ),
    );
  }
}
