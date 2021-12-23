import 'package:afkcredits/constants/colors.dart';
import 'package:afkcredits/utils/ui_helpers.dart';
import 'package:flutter/material.dart';

class AFKFloatingActionButton extends StatelessWidget {
  final Widget icon;
  final void Function() onPressed;
  final double height;
  final double width;
  final String? title;
  const AFKFloatingActionButton(
      {Key? key,
      required this.icon,
      required this.onPressed,
      this.height = 75,
      this.width = 75,
      this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      width: width,
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
          elevation: 8,
          heroTag: null,
          backgroundColor: Theme.of(context).primaryColor,
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
          )),
    );
  }
}
