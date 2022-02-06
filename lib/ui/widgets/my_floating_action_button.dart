import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class AFKFloatingActionButton extends StatelessWidget {
  final Widget icon;
  final void Function() onPressed;
  final double height;
  final double width;
  final String? title;
  final Color? backgroundColor;
  const AFKFloatingActionButton(
      {Key? key,
      required this.icon,
      required this.onPressed,
      this.height = 75,
      this.width = 75,
      this.backgroundColor,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
      clipBehavior: Clip.antiAlias,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        // boxShadow: [
        //   BoxShadow(
        //     blurRadius: 1,
        //     spreadRadius: 5,
        //     color: kShadowColor,
        //     offset: Offset(1, 1),
        //   )
        // ],
      ),
      child: FloatingActionButton(
        splashColor: kDarkTurquoise,
        elevation: 4,
        heroTag: null,
        backgroundColor: backgroundColor ?? Theme.of(context).primaryColor,
        foregroundColor: Colors.black,
        onPressed: onPressed,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            icon,
            if (title != null) verticalSpaceTiny,
            if (title != null)
              Text(title!,
                  style: textTheme(context)
                      .bodyText2!
                      .copyWith(color: kWhiteTextColor, fontSize: 12))
          ],
        ),
      ),
    );
  }
}
